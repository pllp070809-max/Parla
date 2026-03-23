import os
import struct
import zlib

W = 200
H = 200


def _crc32(b: bytes) -> int:
    return zlib.crc32(b) & 0xFFFFFFFF


def _png_chunk(chunk_type: bytes, data: bytes) -> bytes:
    length = struct.pack(">I", len(data))
    crc = struct.pack(">I", _crc32(chunk_type + data))
    return length + chunk_type + data + crc


def write_png_rgb(path: str, pixels_rgb: bytes, w: int = W, h: int = H) -> None:
    if len(pixels_rgb) != w * h * 3:
        raise ValueError(f"pixels_rgb length must be {w*h*3}, got {len(pixels_rgb)}")

    stride = w * 3
    raw = bytearray()
    for y in range(h):
        raw.append(0)  # filter type 0
        start = y * stride
        raw.extend(pixels_rgb[start : start + stride])

    compressed = zlib.compress(bytes(raw), level=9)

    signature = b"\x89PNG\r\n\x1a\n"
    ihdr = struct.pack(">IIBBBBB", w, h, 8, 2, 0, 0, 0)  # 8-bit, RGB, no interlace

    png = bytearray()
    png.extend(signature)
    png.extend(_png_chunk(b"IHDR", ihdr))
    png.extend(_png_chunk(b"IDAT", compressed))
    png.extend(_png_chunk(b"IEND", b""))

    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "wb") as f:
        f.write(png)


def _clamp8(x: int) -> int:
    if x < 0:
        return 0
    if x > 255:
        return 255
    return x


def _make_photo_like(seed: int, base_a, base_b, accent) -> bytes:
    # Deterministic “photo-ish” procedural texture (no external libs).
    out = bytearray(W * H * 3)
    state = seed & 0xFFFFFFFF

    blobs = []
    for _ in range(6):
        state = (1664525 * state + 1013904223) & 0xFFFFFFFF
        bx = state % W
        state = (1664525 * state + 1013904223) & 0xFFFFFFFF
        by = state % H
        state = (1664525 * state + 1013904223) & 0xFFFFFFFF
        br = 18 + (state % 60)
        state = (1664525 * state + 1013904223) & 0xFFFFFFFF
        strength = 0.15 + ((state % 1000) / 1000.0) * 0.40
        blobs.append((bx, by, br, strength))

    ra, ga, ba = base_a
    rb, gb, bb = base_b
    rc, gc, bc = accent

    for y in range(H):
        v = y / (H - 1)
        for x in range(W):
            u = x / (W - 1)

            mix = (0.55 * u) + (0.35 * (1.0 - v)) + (0.10 * (u * v))
            mix = 0.0 if mix < 0 else 1.0 if mix > 1 else mix

            r = ra * (1.0 - mix) + rb * mix
            g = ga * (1.0 - mix) + gb * mix
            b = ba * (1.0 - mix) + bb * mix

            dx = (u - 0.5)
            dy = (v - 0.5)
            dist2 = dx * dx + dy * dy
            vig = 0.72 + 0.28 * (1.0 - min(1.0, dist2 / 0.35))
            r *= vig
            g *= vig
            b *= vig

            for bx, by, br, strength in blobs:
                ddx = x - bx
                ddy = y - by
                d2 = ddx * ddx + ddy * ddy
                if d2 > br * br:
                    continue
                t = (1.0 - (d2 / (br * br)))
                r = r * (1.0 - strength * t) + rc * (strength * t)
                g = g * (1.0 - strength * t) + gc * (strength * t)
                b = b * (1.0 - strength * t) + bc * (strength * t)

            state = (1664525 * state + 1013904223) & 0xFFFFFFFF
            noise = (state / 0xFFFFFFFF)
            n = int((noise - 0.5) * 40)  # -20..+20
            r = _clamp8(int(r) + n)
            g = _clamp8(int(g) + n)
            b = _clamp8(int(b) + n)

            idx = (y * W + x) * 3
            out[idx] = r
            out[idx + 1] = g
            out[idx + 2] = b

    return bytes(out)


def generate_all(out_dir: str) -> None:
    configs = [
        (1_234_567, (26, 190, 220), (190, 70, 210), (245, 245, 255)),  # salon1
        (9_876_543, (235, 165, 60), (195, 55, 80), (255, 235, 210)),   # salon2
        (2_345_678, (50, 195, 105), (65, 120, 220), (235, 245, 255)), # salon3
    ]

    os.makedirs(out_dir, exist_ok=True)
    for i, (seed, a, b, c) in enumerate(configs, start=1):
        pixels = _make_photo_like(seed, a, b, c)
        out_path = os.path.join(out_dir, f"salon{i}.png")
        write_png_rgb(out_path, pixels)
        print(f"Wrote {out_path} ({os.path.getsize(out_path)} bytes)")


if __name__ == "__main__":
    base = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    img_dir = os.path.join(base, "images")
    generate_all(img_dir)

