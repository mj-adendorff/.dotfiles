#!/usr/bin/env python3
"""Ask the terminal how many cells each configured icon actually advances.

lazyjira lays out its columns assuming every icon is 2 cells wide (that is what
go-runewidth, which lazyjira links, reports for all of them). Any icon your
terminal advances by something other than 2 will shift that row's columns.

Run this in the terminal where lazyjira looks misaligned.
"""
import sys, termios, tty, re, os

CONFIG = os.path.join(os.path.dirname(os.path.abspath(__file__)), "config.yml")

def load_icons():
    """Minimal parse of gui.typeIcons / gui.statusIcons - no pyyaml needed."""
    icons, section = [], None
    for line in open(CONFIG, encoding="utf-8"):
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue
        if re.match(r"^\s{2}(typeIcons|statusIcons):\s*$", line.rstrip()):
            section = stripped.rstrip(":")
            continue
        if section:
            m = re.match(r'^\s{4}(.+?):\s*"(.+?)"\s*$', line.rstrip())
            if m:
                icons.append((section, m.group(1), m.group(2)))
            elif not line.startswith("    "):
                section = None
    return icons

try:
    tty_fd = open("/dev/tty", "r+b", buffering=0)
except OSError:
    sys.exit("no controlling terminal - run this directly in your terminal, not through a pipe")

def advance(glyph):
    """Draw glyph at column 1, then ask the terminal where the cursor landed."""
    tty_fd.write(b"\r\x1b[2K" + glyph.encode())
    tty_fd.write(b"\x1b[6n")
    resp = b""
    while not resp.endswith(b"R"):
        resp += tty_fd.read(1)
    return int(re.search(rb"\[(\d+);(\d+)R", resp).group(2)) - 1

icons = load_icons()
if not icons:
    sys.exit(f"found no typeIcons/statusIcons in {CONFIG}")

old = termios.tcgetattr(tty_fd)
try:
    tty.setraw(tty_fd.fileno())
    baseline = advance("X")
    results = [(s, n, g, advance(g)) for s, n, g in icons]
finally:
    termios.tcsetattr(tty_fd, termios.TCSADRAIN, old)
    tty_fd.write(b"\r\x1b[2K")

print(f"baseline: 'X' advances {baseline} cell (sanity check, must be 1)")
print("lazyjira lays out assuming every icon advances exactly 2 cells\n")
print(f"{'SECTION':<12} {'NAME':<22} {'ICON':<5} {'CELLS':>5}  VERDICT")
bad = []
for section, name, glyph, w in results:
    if w == 2:
        verdict = "ok"
    else:
        verdict = f">>> MISALIGNS ({w-2:+d} cell)"
        bad.append((section, name, glyph, w))
    print(f"{section:<12} {name:<22} {glyph:<5} {w:>5}  {verdict}")
print(f"\n{len(bad)} of {len(results)} icons disagree with lazyjira's layout.")
if bad:
    print("Offenders: " + ", ".join(f"{n} {g}" for _, n, g, _ in bad))
