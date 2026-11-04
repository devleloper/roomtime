"""Regenerates the join/leave chimes (original work, AGPL-3.0-only like the project).

Usage (macOS): python3 make_sounds.py && for n in accept exit; do
  afconvert -f m4af -d aac -b 96000 $n.wav ../$n.m4a; done
"""

import math
import struct
import wave

SAMPLE_RATE = 44100


def chime(notes, path):
    """notes: (frequency Hz, duration s, start s); bell-like partials with a soft attack."""
    total = max(start + duration for _, duration, start in notes) + 0.25
    buf = [0.0] * int(total * SAMPLE_RATE)
    for freq, duration, start in notes:
        offset = int(start * SAMPLE_RATE)
        for i in range(int((duration + 0.25) * SAMPLE_RATE)):
            t = i / SAMPLE_RATE
            env = min(1.0, t / 0.008) * math.exp(-t * 7.0)
            value = env * (
                0.62 * math.sin(2 * math.pi * freq * t)
                + 0.25 * math.sin(2 * math.pi * 2 * freq * t)
                + 0.08 * math.sin(2 * math.pi * 3 * freq * t)
            )
            if offset + i < len(buf):
                buf[offset + i] += value
    gain = 0.5 / max(abs(x) for x in buf)
    with wave.open(path, "wb") as out:
        out.setnchannels(1)
        out.setsampwidth(2)
        out.setframerate(SAMPLE_RATE)
        out.writeframes(b"".join(struct.pack("<h", int(x * gain * 32767)) for x in buf))


if __name__ == "__main__":
    chime([(659.25, 0.18, 0.0), (987.77, 0.30, 0.12)], "accept.wav")  # E5 -> B5, rising
    chime([(783.99, 0.18, 0.0), (523.25, 0.30, 0.12)], "exit.wav")  # G5 -> C5, falling
