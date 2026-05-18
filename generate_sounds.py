import wave
import struct
import math
import os

os.makedirs('assets/audios', exist_ok=True)

def generate_tone(filename, freq, duration, volume=0.5):
    sample_rate = 44100
    num_samples = int(sample_rate * duration)
    with wave.open(filename, 'w') as f:
        f.setnchannels(1)
        f.setsampwidth(2)
        f.setframerate(sample_rate)
        for i in range(num_samples):
            env = 1.0 - (i / num_samples)
            value = int(volume * env * 32767.0 * math.sin(2.0 * math.pi * freq * i / sample_rate))
            data = struct.pack('<h', value)
            f.writeframesraw(data)

generate_tone('assets/audios/reveal.wav', 880.0, 0.1)

sample_rate = 44100
with wave.open('assets/audios/victory.wav', 'w') as f:
    f.setnchannels(1)
    f.setsampwidth(2)
    f.setframerate(sample_rate)
    for freq in [523.25, 659.25, 783.99, 1046.50]:
        num_samples = int(sample_rate * 0.15)
        for i in range(num_samples):
            value = int(0.5 * 32767.0 * math.sin(2.0 * math.pi * freq * i / sample_rate))
            data = struct.pack('<h', value)
            f.writeframesraw(data)

with wave.open('assets/audios/defeat.wav', 'w') as f:
    f.setnchannels(1)
    f.setsampwidth(2)
    f.setframerate(sample_rate)
    duration = 0.8
    num_samples = int(sample_rate * duration)
    for i in range(num_samples):
        freq = 400.0 - (300.0 * (i / num_samples))
        env = 1.0 - (i / num_samples)
        value = int(0.5 * env * 32767.0 * math.sin(2.0 * math.pi * freq * i / sample_rate))
        data = struct.pack('<h', value)
        f.writeframesraw(data)

