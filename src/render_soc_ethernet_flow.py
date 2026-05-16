from __future__ import annotations

from pathlib import Path
from typing import Iterable

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "assets" / "soc-ethernet-flow.gif"
WIDTH, HEIGHT = 980, 320
FRAMES = 48


COLORS = {
    "bg0": (5, 22, 42),
    "bg1": (16, 58, 91),
    "grid": (31, 103, 137, 82),
    "panel": (16, 29, 56),
    "text": (245, 248, 255),
    "muted": (188, 205, 222),
    "green": (42, 230, 174),
    "blue": (68, 178, 255),
    "yellow": (255, 205, 65),
    "cyan": (36, 217, 235),
    "pink": (255, 91, 136),
    "violet": (169, 130, 255),
    "line": (255, 224, 94),
    "mono": (173, 255, 221),
}


NODES = [
    ("PC GUI", 42, 106, 124, COLORS["blue"]),
    ("TCP LAN", 202, 106, 146, COLORS["green"]),
    ("HPS Linux", 382, 106, 148, (91, 169, 255)),
    ("Bridge", 566, 106, 126, COLORS["yellow"]),
    ("FPGA PIO", 722, 106, 136, COLORS["pink"]),
    ("HEX", 888, 106, 78, COLORS["violet"]),
]


def font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont:
    candidates = [
        r"C:\Windows\Fonts\arialbd.ttf" if bold else r"C:\Windows\Fonts\arial.ttf",
        r"C:\Windows\Fonts\segoeuib.ttf" if bold else r"C:\Windows\Fonts\segoeui.ttf",
        r"C:\Windows\Fonts\consolab.ttf" if bold else r"C:\Windows\Fonts\consola.ttf",
    ]
    for path in candidates:
        if Path(path).exists():
            return ImageFont.truetype(path, size)
    return ImageFont.load_default()


FONT_LABEL = font(24, True)
FONT_CAPTION = font(18, False)
FONT_SMALL = font(16, False)
FONT_MONO = font(16, False)


def lerp(a: int, b: int, t: float) -> int:
    return round(a + (b - a) * t)


def text_center(draw: ImageDraw.ImageDraw, box: tuple[int, int, int, int], text: str, fnt: ImageFont.FreeTypeFont) -> None:
    left, top, right, bottom = box
    bbox = draw.textbbox((0, 0), text, font=fnt)
    x = left + (right - left - (bbox[2] - bbox[0])) / 2
    y = top + (bottom - top - (bbox[3] - bbox[1])) / 2 - 1
    draw.text((x, y), text, font=fnt, fill=COLORS["text"])


def draw_background(draw: ImageDraw.ImageDraw) -> None:
    for y in range(HEIGHT):
        t = y / (HEIGHT - 1)
        r = lerp(COLORS["bg0"][0], COLORS["bg1"][0], t)
        g = lerp(COLORS["bg0"][1], COLORS["bg1"][1], t)
        b = lerp(COLORS["bg0"][2], COLORS["bg1"][2], t)
        draw.line((0, y, WIDTH, y), fill=(r, g, b))
    for x in range(0, WIDTH, 96):
        draw.line((x, 0, x, HEIGHT), fill=COLORS["grid"], width=1)
    for y in range(0, HEIGHT, 48):
        draw.line((0, y, WIDTH, y), fill=COLORS["grid"], width=1)


def draw_polyline(draw: ImageDraw.ImageDraw, points: Iterable[tuple[int, int]], color: tuple[int, int, int], width: int = 4) -> None:
    pts = list(points)
    for start, end in zip(pts, pts[1:]):
        draw.line((*start, *end), fill=color, width=width)


def point_on_path(points: list[tuple[int, int]], t: float) -> tuple[int, int]:
    segments = []
    total = 0.0
    for a, b in zip(points, points[1:]):
        length = ((b[0] - a[0]) ** 2 + (b[1] - a[1]) ** 2) ** 0.5
        segments.append((a, b, length))
        total += length
    target = (t % 1.0) * total
    seen = 0.0
    for a, b, length in segments:
        if seen + length >= target:
            local = (target - seen) / max(length, 1)
            return lerp(a[0], b[0], local), lerp(a[1], b[1], local)
        seen += length
    return points[-1]


def frame(index: int) -> Image.Image:
    img = Image.new("RGB", (WIDTH, HEIGHT), COLORS["bg0"])
    draw = ImageDraw.Draw(img)
    draw_background(draw)

    draw.text((34, 28), "Luồng điều khiển TCP/Ethernet tới HEX0..HEX5", font=FONT_CAPTION, fill=COLORS["text"])
    draw.text((34, 55), "PC/Android -> TCP LAN -> HPS Linux -> Bridge -> FPGA PIO -> HEX display", font=FONT_SMALL, fill=COLORS["muted"])

    main_y = 135
    main_points = [(24, main_y)]
    for _, x, y, w, _ in NODES:
        main_points.extend([(x - 10, main_y), (x + w + 10, main_y)])
    main_points.append((956, main_y))
    draw_polyline(draw, main_points, COLORS["line"], 4)

    feedback = [(926, 196), (700, 196), (700, 224), (168, 224)]
    draw_polyline(draw, feedback, COLORS["cyan"], 3)
    draw.text((44, 232), "phản hồi OK/ERR", font=FONT_SMALL, fill=COLORS["muted"])

    progress = index / FRAMES
    dot = point_on_path(main_points, progress)
    draw.ellipse((dot[0] - 8, dot[1] - 8, dot[0] + 8, dot[1] + 8), fill=(255, 246, 168), outline=COLORS["text"], width=1)
    dot2 = point_on_path(feedback, progress + 0.35)
    draw.rounded_rectangle((dot2[0] - 18, dot2[1] - 9, dot2[0] + 18, dot2[1] + 9), radius=8, fill=COLORS["cyan"], outline=(151, 255, 255), width=1)

    for label, x, y, w, border in NODES:
        draw.rounded_rectangle((x + 4, y + 5, x + w + 4, y + 63), radius=12, fill=(0, 0, 0, 80))
        draw.rounded_rectangle((x, y, x + w, y + 58), radius=12, fill=COLORS["panel"], outline=border, width=3)
        text_center(draw, (x, y, x + w, y + 58), label, FONT_LABEL)

    draw.rounded_rectangle((34, 272, 946, 308), radius=10, fill=(1, 7, 22), outline=(18, 28, 58), width=2)
    draw.text((54, 282), 'PAYLOAD: "ABC123"   |   TCP:5000   |   ACK: OK   |   HEX0..HEX5', font=FONT_MONO, fill=COLORS["mono"])
    return img


def main() -> None:
    OUT.parent.mkdir(parents=True, exist_ok=True)
    frames = [frame(i).convert("P", palette=Image.Palette.ADAPTIVE, colors=128) for i in range(FRAMES)]
    frames[0].save(OUT, save_all=True, append_images=frames[1:], duration=60, loop=0, optimize=True)
    print(OUT)


if __name__ == "__main__":
    main()
