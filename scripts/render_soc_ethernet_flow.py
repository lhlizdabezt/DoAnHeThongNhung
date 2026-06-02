from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets"
OUT = ASSETS / "soc-ethernet-flow.gif"


def font(size, bold=False):
    candidates = [
        "C:/Windows/Fonts/segoeuib.ttf" if bold else "C:/Windows/Fonts/segoeui.ttf",
        "C:/Windows/Fonts/arialbd.ttf" if bold else "C:/Windows/Fonts/arial.ttf",
    ]
    for path in candidates:
        if Path(path).exists():
            return ImageFont.truetype(path, size=size)
    return ImageFont.load_default()


TITLE = font(34, True)
SUB = font(17)
CARD = font(18, True)
SMALL = font(13)
MONO = font(14, True)


def draw_card(draw, box, title, detail, active, fill):
    x1, y1, x2, y2 = box
    shadow = (8, 18, 40) if active else (15, 23, 42)
    draw.rounded_rectangle((x1 + 4, y1 + 6, x2 + 4, y2 + 6), radius=18, fill=shadow)
    draw.rounded_rectangle(box, radius=18, fill=fill, outline=(226, 232, 240), width=3 if active else 1)
    draw.text((x1 + 18, y1 + 18), title, font=CARD, fill=(15, 23, 42))
    draw.text((x1 + 18, y1 + 50), detail, font=SMALL, fill=(51, 65, 85))
    if active:
        draw.rounded_rectangle((x1 + 18, y2 - 20, x1 + 82, y2 - 10), radius=5, fill=(37, 99, 235))


def frame(active):
    img = Image.new("RGB", (960, 340), (15, 23, 42))
    draw = ImageDraw.Draw(img)
    draw.rounded_rectangle((24, 22, 936, 318), radius=26, fill=(248, 250, 252))
    draw.text((52, 44), "SoC Ethernet Controller", font=TITLE, fill=(15, 23, 42))
    draw.text((54, 88), "DE10-Standard Cyclone V: client payload, HPS Linux server, FPGA display.", font=SUB, fill=(71, 85, 105))

    cards = [
        ("PC Client", "Python GUI", (219, 234, 254)),
        ("TCP Port", "LAN 5000", (204, 251, 241)),
        ("HPS Linux", "Python server", (254, 249, 195)),
        ("FPGA Bridge", "PIO write", (254, 226, 226)),
        ("HEX Display", "HEX0-HEX5", (233, 213, 255)),
    ]
    x = 48
    for index, (name, detail, color) in enumerate(cards):
        draw_card(draw, (x, 146, x + 165, 245), name, detail, index == active, color)
        x += 178

    draw.rounded_rectangle((52, 270, 908, 300), radius=12, fill=(15, 23, 42))
    snippets = [
        "PAYLOAD ABC123",
        "TCP ACK OK",
        "HPS validates length",
        "PIO register write",
        "Seven-segment update",
    ]
    draw.text((74, 279), snippets[active], font=MONO, fill=(125, 211, 252))
    draw.text((700, 279), "Prototype scope: LAN only", font=MONO, fill=(226, 232, 240))
    return img


def main():
    frames = [frame(i % 5) for i in range(25)]
    frames[0].save(OUT, save_all=True, append_images=frames[1:], duration=180, loop=0, optimize=True)
    print(f"wrote {OUT} ({OUT.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
