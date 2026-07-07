#!/usr/bin/env python3
import argparse
import fcntl
import os
import select
import signal
import struct
import sys
import time

EV_SYN = 0
EV_KEY = 1
EV_ABS = 3
SYN_REPORT = 0

KEY_ESC = 1
KEY_ENTER = 28
KEY_LEFTSHIFT = 42
KEY_Z = 44
KEY_X = 45
KEY_C = 46
KEY_V = 47
KEY_UP = 103
KEY_LEFT = 105
KEY_RIGHT = 106
KEY_DOWN = 108

BTN_SOUTH = 0x130
BTN_EAST = 0x131
BTN_NORTH = 0x133
BTN_WEST = 0x134
BTN_TL = 0x136
BTN_TR = 0x137
BTN_SELECT = 0x13A
BTN_START = 0x13B

ABS_X = 0x00
ABS_Y = 0x01
ABS_Z = 0x02
ABS_RZ = 0x05
ABS_HAT0X = 0x10
ABS_HAT0Y = 0x11

UI_DEV_CREATE = 0x5501
UI_DEV_DESTROY = 0x5502
UI_SET_EVBIT = 0x40045564
UI_SET_KEYBIT = 0x40045565

EVENT_STRUCT = "llHHi"
EVENT_SIZE = struct.calcsize(EVENT_STRUCT)

BUTTON_MAP = {
    BTN_SOUTH: KEY_Z,       # Cross: jump
    BTN_WEST: KEY_X,        # Square: shoot
    BTN_EAST: KEY_C,        # Circle: dash
    BTN_NORTH: KEY_V,       # Triangle: EX/special
    BTN_TL: KEY_LEFTSHIFT,  # L1: lock/aim
    BTN_TR: KEY_LEFTSHIFT,  # R1: lock/aim, useful if the pad reports shoulders swapped
    BTN_START: KEY_ENTER,
    BTN_SELECT: KEY_ESC,
}

OUTPUT_KEYS = sorted({
    KEY_ESC, KEY_ENTER, KEY_LEFTSHIFT, KEY_Z, KEY_X, KEY_C, KEY_V,
    KEY_UP, KEY_LEFT, KEY_RIGHT, KEY_DOWN,
})


def emit(fd, event_type, code, value):
    now = time.time()
    sec = int(now)
    usec = int((now - sec) * 1_000_000)
    os.write(fd, struct.pack(EVENT_STRUCT, sec, usec, event_type, code, value))


def sync(fd):
    emit(fd, EV_SYN, SYN_REPORT, 0)


def set_key(fd, key_state, key, pressed):
    pressed = bool(pressed)
    if key_state.get(key, False) == pressed:
        return
    key_state[key] = pressed
    emit(fd, EV_KEY, key, 1 if pressed else 0)
    sync(fd)


def axis_dir(value):
    if value < -1:
        if value < -12000:
            return -1
        if value > 12000:
            return 1
        return 0
    if value > 1:
        if value < 85:
            return -1
        if value > 170:
            return 1
        return 0
    return value


def create_keyboard():
    fd = os.open("/dev/uinput", os.O_WRONLY | os.O_NONBLOCK)
    fcntl.ioctl(fd, UI_SET_EVBIT, EV_KEY)
    for key in OUTPUT_KEYS:
        fcntl.ioctl(fd, UI_SET_KEYBIT, key)

    name = b"Cuphead Pad Bridge"
    user_dev = struct.pack("80sHHHHI", name, 0x03, 0x1209, 0xC0DE, 1, 0)
    user_dev += struct.pack("i" * (64 * 4), *([0] * (64 * 4)))
    os.write(fd, user_dev)
    fcntl.ioctl(fd, UI_DEV_CREATE)
    time.sleep(0.2)
    return fd


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("event_device")
    args = parser.parse_args()

    running = True

    def stop(_signum, _frame):
        nonlocal running
        running = False

    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)

    input_fd = os.open(args.event_device, os.O_RDONLY | os.O_NONBLOCK)
    output_fd = create_keyboard()
    key_state = {}

    stick_x = 0
    stick_y = 0
    hat_x = 0
    hat_y = 0

    def refresh_dirs():
        set_key(output_fd, key_state, KEY_LEFT, stick_x < 0 or hat_x < 0)
        set_key(output_fd, key_state, KEY_RIGHT, stick_x > 0 or hat_x > 0)
        set_key(output_fd, key_state, KEY_UP, stick_y < 0 or hat_y < 0)
        set_key(output_fd, key_state, KEY_DOWN, stick_y > 0 or hat_y > 0)

    try:
        while running:
            ready, _, _ = select.select([input_fd], [], [], 0.25)
            if not ready:
                continue
            data = os.read(input_fd, EVENT_SIZE * 32)
            for offset in range(0, len(data) - EVENT_SIZE + 1, EVENT_SIZE):
                _sec, _usec, event_type, code, value = struct.unpack(
                    EVENT_STRUCT, data[offset:offset + EVENT_SIZE]
                )
                if event_type == EV_KEY and code in BUTTON_MAP:
                    set_key(output_fd, key_state, BUTTON_MAP[code], value)
                elif event_type == EV_ABS:
                    if code == ABS_X:
                        stick_x = axis_dir(value)
                        refresh_dirs()
                    elif code == ABS_Y:
                        stick_y = axis_dir(value)
                        refresh_dirs()
                    elif code == ABS_HAT0X:
                        hat_x = axis_dir(value)
                        refresh_dirs()
                    elif code == ABS_HAT0Y:
                        hat_y = axis_dir(value)
                        refresh_dirs()
                    elif code == ABS_Z:
                        set_key(output_fd, key_state, KEY_LEFTSHIFT, value > 170 or value > 12000)
                    elif code == ABS_RZ:
                        set_key(output_fd, key_state, KEY_X, value > 170 or value > 12000)
    finally:
        for key in list(key_state):
            set_key(output_fd, key_state, key, False)
        try:
            fcntl.ioctl(output_fd, UI_DEV_DESTROY)
        finally:
            os.close(output_fd)
            os.close(input_fd)


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        print(f"uconsole-cuphead-pad-bridge: {exc}", file=sys.stderr)
        sys.exit(1)
