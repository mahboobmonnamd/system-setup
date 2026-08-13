#!/usr/bin/env python3
"""Show 1–9 on Herdr panes, then focus the pane whose number you type.

tmux twin of `display-panes`: Ctrl-a q, then 1–9. Needs kitty_graphics.
"""

from __future__ import annotations

import base64
import itertools
import json
import os
from pathlib import Path
import socket
import sys
import termios
import time
import tty
from typing import Any, Dict, Iterable, List, Mapping, Optional, Sequence, Tuple

PLUGIN_ID = "system-setup.pane-numbers"
HINT_ALPHABET = "123456789"
BADGE_SIZE = 128
BADGE_GRID_COLS = 8
BADGE_GRID_ROWS = 4
PEACH = (254, 100, 11, 255)
PEACH_DARK = (196, 72, 8, 255)
CREAM = (250, 252, 255, 255)
REQUEST_IDS = itertools.count(1)

# Compact 5x7 digits for the dependency-free badge path.
FONT_5X7 = {
    "1": ("00100", "01100", "00100", "00100", "00100", "00100", "01110"),
    "2": ("01110", "10001", "00001", "00010", "00100", "01000", "11111"),
    "3": ("11110", "00001", "00001", "01110", "00001", "00001", "11110"),
    "4": ("00010", "00110", "01010", "10010", "11111", "00010", "00010"),
    "5": ("11111", "10000", "11110", "00001", "00001", "10001", "01110"),
    "6": ("01110", "10000", "10000", "11110", "10001", "10001", "01110"),
    "7": ("11111", "00001", "00010", "00100", "01000", "01000", "01000"),
    "8": ("01110", "10001", "10001", "01110", "10001", "10001", "01110"),
    "9": ("01110", "10001", "10001", "01111", "00001", "00001", "01110"),
}


class HerdrApiError(RuntimeError):
    def __init__(self, code: str, message: str) -> None:
        super().__init__(message)
        self.code = code
        self.message = message


def herdr_socket_path() -> str:
    explicit = os.environ.get("HERDR_SOCKET_PATH")
    if explicit:
        return explicit
    session = os.environ.get("HERDR_SESSION")
    config = Path.home() / ".config" / "herdr"
    if session and session != "default":
        return str(config / "sessions" / session / "herdr.sock")
    return str(config / "herdr.sock")


def api_request(method: str, params: Mapping[str, Any]) -> Dict[str, Any]:
    request_id = f"pane-numbers-{os.getpid()}-{next(REQUEST_IDS)}"
    payload = json.dumps(
        {"id": request_id, "method": method, "params": dict(params)},
        separators=(",", ":"),
    ).encode("utf-8") + b"\n"
    try:
        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
            client.settimeout(3.0)
            client.connect(herdr_socket_path())
            client.sendall(payload)
            with client.makefile("rb") as stream:
                line = stream.readline()
    except OSError as error:
        raise RuntimeError(f"could not reach Herdr: {error}") from error
    if not line:
        raise RuntimeError("Herdr closed the socket without a response")
    response = json.loads(line)
    if response.get("id") != request_id:
        raise RuntimeError("Herdr returned a response with the wrong request id")
    if "error" in response:
        body = response["error"]
        raise HerdrApiError(str(body.get("code", "unknown")), str(body.get("message", "")))
    result = response.get("result")
    if not isinstance(result, dict):
        raise RuntimeError("Herdr returned a response without a result object")
    return result


def spatial_panes(layout: Mapping[str, Any]) -> List[Dict[str, Any]]:
    panes = [dict(pane) for pane in layout.get("panes", []) if isinstance(pane, dict)]
    return sorted(
        panes,
        key=lambda pane: (
            int(pane.get("rect", {}).get("y", 0)),
            int(pane.get("rect", {}).get("x", 0)),
            str(pane.get("pane_id", "")),
        ),
    )


def assign_hints(
    layout: Mapping[str, Any], excluded_pane_ids: Iterable[str] = ()
) -> List[Tuple[str, Dict[str, Any]]]:
    excluded = set(excluded_pane_ids)
    panes = [pane for pane in spatial_panes(layout) if pane.get("pane_id") not in excluded]
    if len(panes) > len(HINT_ALPHABET):
        raise RuntimeError(
            f"this tab has {len(panes)} panes; picker supports {len(HINT_ALPHABET)}"
        )
    return list(zip(HINT_ALPHABET, panes))


def graphics_cell_size(pane_id: str) -> Tuple[int, int]:
    try:
        info = api_request("pane.graphics.info", {"pane_id": pane_id})
    except HerdrApiError as error:
        message = error.message.lower()
        if "cell size" in message and "unavailable" in message:
            raise RuntimeError(
                "Restart this Herdr client once: kitty_graphics was enabled after it started."
            ) from error
        raise
    cell_width = int(info.get("cell_width_px", 0))
    cell_height = int(info.get("cell_height_px", 0))
    if cell_width <= 0 or cell_height <= 0:
        raise RuntimeError(
            "Restart this Herdr client once: it has not reported terminal pixel geometry."
        )
    return cell_width, cell_height


def badge_placement(rect: Mapping[str, Any]) -> Dict[str, int]:
    width = max(0, int(rect.get("width", 0)))
    height = max(0, int(rect.get("height", 0)))
    return {
        "viewport_col": max(0, (width - BADGE_GRID_COLS) // 2),
        "viewport_row": max(0, (height - BADGE_GRID_ROWS) // 2),
        "grid_cols": min(BADGE_GRID_COLS, max(1, width)),
        "grid_rows": min(BADGE_GRID_ROWS, max(1, height)),
    }


def render_badge_rgba(char: str) -> bytes:
    glyph = FONT_5X7.get(char)
    if glyph is None:
        raise ValueError(f"unsupported hint character: {char!r}")
    size = BADGE_SIZE
    pixels = bytearray(size * size * 4)
    margin = 8
    radius = 18

    def inside_round(x: int, y: int, w: int, h: int, r: int) -> bool:
        if r <= 0:
            return True
        near_left, near_right = x < r, x >= w - r
        near_top, near_bottom = y < r, y >= h - r
        if not ((near_left or near_right) and (near_top or near_bottom)):
            return True
        cx = r if near_left else w - r - 1
        cy = r if near_top else h - r - 1
        dx, dy = x - cx, y - cy
        return dx * dx + dy * dy <= r * r

    inner_w = size - 2 * margin
    inner_h = size - 2 * margin
    for y in range(inner_h):
        ratio = y / max(1, inner_h - 1)
        color = tuple(
            round(PEACH[i] + (PEACH_DARK[i] - PEACH[i]) * ratio) for i in range(4)
        )
        for x in range(inner_w):
            if not inside_round(x, y, inner_w, inner_h, radius):
                continue
            px, py = x + margin, y + margin
            offset = (py * size + px) * 4
            pixels[offset : offset + 4] = bytes(color)

    glyph_w, glyph_h = 5, 7
    cell = 12
    start_x = (size - glyph_w * cell) // 2
    start_y = (size - glyph_h * cell) // 2 + 2
    for row_i, row in enumerate(glyph):
        for col_i, bit in enumerate(row):
            if bit != "1":
                continue
            for dy in range(cell - 2):
                for dx in range(cell - 2):
                    px = start_x + col_i * cell + dx
                    py = start_y + row_i * cell + dy
                    if 0 <= px < size and 0 <= py < size:
                        offset = (py * size + px) * 4
                        pixels[offset : offset + 4] = bytes(CREAM)
    return bytes(pixels)


def graphics_params(char: str, pane: Mapping[str, Any]) -> Dict[str, Any]:
    return {
        "pane_id": str(pane["pane_id"]),
        "format": "rgba",
        "image_width": BADGE_SIZE,
        "image_height": BADGE_SIZE,
        "data_base64": base64.b64encode(render_badge_rgba(char)).decode("ascii"),
        "placement": badge_placement(pane.get("rect", {})),
    }


def clear_hints(pane_ids: Iterable[str]) -> None:
    for pane_id in dict.fromkeys(pane_ids):
        try:
            api_request("pane.graphics.clear", {"pane_id": pane_id})
        except (HerdrApiError, RuntimeError):
            pass


def show_hints(assignments: Sequence[Tuple[str, Mapping[str, Any]]]) -> List[str]:
    shown: List[str] = []
    try:
        for char, pane in assignments:
            api_request("pane.graphics.set", graphics_params(char, pane))
            shown.append(str(pane["pane_id"]))
    except (HerdrApiError, RuntimeError):
        clear_hints(shown)
        raise
    return shown


def read_selection(valid: Mapping[str, str]) -> Optional[str]:
    """Read a bare digit (1–9). Ignores Ctrl-a so tab-switch chords stay free."""
    if not sys.stdin.isatty():
        return None
    descriptor = sys.stdin.fileno()
    previous = termios.tcgetattr(descriptor)
    try:
        tty.setraw(descriptor)
        while True:
            raw = os.read(descriptor, 1)
            if not raw or raw in {b"\x03", b"\x07", b"\x1b"}:
                return None
            # Ctrl-a (SOH) starts a tab/window chord — ignore so user can Esc
            # or type a bare digit; never treat prefix+digit as a pane jump.
            if raw == b"\x01":
                sys.stdout.write("\a")
                sys.stdout.flush()
                continue
            try:
                key = raw.decode("ascii")
            except UnicodeDecodeError:
                continue
            if key in valid:
                return valid[key]
            sys.stdout.write("\a")
            sys.stdout.flush()
    finally:
        termios.tcsetattr(descriptor, termios.TCSADRAIN, previous)


def popup_header() -> None:
    sys.stdout.write("\x1b[2J\x1b[H\x1b[?25l")
    sys.stdout.write(
        "\x1b[1mPane numbers\x1b[0m type \x1b[1m1–9\x1b[0m (no Ctrl-a) · Esc cancels"
    )
    sys.stdout.flush()


def restore_popup_cursor() -> None:
    sys.stdout.write("\x1b[?25h")
    sys.stdout.flush()


def state_dir() -> Path:
    configured = os.environ.get("HERDR_PLUGIN_STATE_DIR")
    if configured:
        return Path(configured)
    return Path.home() / ".config" / "herdr" / "plugin-state" / PLUGIN_ID


def log_error(message: str) -> None:
    try:
        directory = state_dir()
        directory.mkdir(parents=True, exist_ok=True)
        with (directory / "errors.log").open("a", encoding="utf-8") as stream:
            stream.write(f"{time.strftime('%Y-%m-%dT%H:%M:%S%z')} {message}\n")
    except OSError:
        pass


def show_error(message: str) -> None:
    sys.stdout.write("\x1b[2J\x1b[H\x1b[31;1mPane numbers\x1b[0m\n")
    sys.stdout.write(message)
    if sys.stdin.isatty():
        sys.stdout.write(" · press any key")
        sys.stdout.flush()
        descriptor = sys.stdin.fileno()
        previous = termios.tcgetattr(descriptor)
        try:
            tty.setraw(descriptor)
            os.read(descriptor, 1)
        finally:
            termios.tcsetattr(descriptor, termios.TCSADRAIN, previous)
    else:
        sys.stdout.flush()


def pick_pane() -> int:
    result = api_request("pane.layout", {})
    layout = result.get("layout")
    if not isinstance(layout, dict):
        raise RuntimeError("Herdr did not return a pane layout")
    picker_pane = os.environ.get("HERDR_PANE_ID", "")
    assignments = assign_hints(layout, excluded_pane_ids={picker_pane} if picker_pane else ())
    if len(assignments) < 2:
        show_error("This tab only has one pane.")
        return 0
    targets = {char: str(pane["pane_id"]) for char, pane in assignments}
    shown: List[str] = []
    popup_header()
    try:
        graphics_cell_size(str(assignments[0][1]["pane_id"]))
        shown = show_hints(assignments)
        selected = read_selection(targets)
    finally:
        restore_popup_cursor()
        clear_hints(shown)
    if selected:
        api_request("pane.focus", {"pane_id": selected})
    return 0


def open_picker() -> int:
    api_request(
        "plugin.pane.open",
        {
            "plugin_id": PLUGIN_ID,
            "entrypoint": "picker",
            "placement": "popup",
            "focus": True,
        },
    )
    return 0


def main(argv: Sequence[str]) -> int:
    command = argv[1] if len(argv) > 1 else "pick"
    if command == "open":
        try:
            return open_picker()
        except (HerdrApiError, RuntimeError) as error:
            log_error(str(error))
            print(f"pane-numbers: {error}", file=sys.stderr)
            return 1
    if command == "pick":
        try:
            return pick_pane()
        except HerdrApiError as error:
            log_error(f"{error.code}: {error.message}")
            if error.code == "feature_disabled":
                show_error("Enable [experimental] kitty_graphics = true.")
            else:
                show_error(f"Herdr error: {error.message}")
            return 1
        except RuntimeError as error:
            log_error(str(error))
            show_error(str(error))
            return 1
    print(f"usage: {Path(argv[0]).name} [open|pick]", file=sys.stderr)
    return 2


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
