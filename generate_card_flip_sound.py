#!/usr/bin/env python3
"""Generate a realistic card flip sound effect using pure Python (no dependencies)"""

import math
import struct
import wave
import random

def generate_card_flip_sound(output_file, duration=0.12, sample_rate=44100):
    """Generate a short, crisp paper card flip sound"""

    num_samples = int(duration * sample_rate)

    # Generate sound data
    audio_data = []

    for i in range(num_samples):
        t = i / sample_rate
        progress = i / num_samples

        sample = 0.0

        # Sharp paper snap at the beginning
        if progress < 0.25:
            snap_progress = progress / 0.25
            # Crisp attack with higher frequencies
            snap = 0.0
            for harmonic in [1, 2, 3]:
                freq = 1200 * harmonic
                snap += math.sin(2 * math.pi * freq * t) * (1.0 / harmonic)

            # Very sharp envelope for snap
            snap_envelope = math.exp(-snap_progress * 25) * (1 - snap_progress ** 2)
            sample += snap * snap_envelope * 0.35

        # Quick rustling texture
        rustle_freq = 300 + 150 * progress
        rustle = math.sin(2 * math.pi * rustle_freq * t)
        rustle += math.sin(2 * math.pi * rustle_freq * 1.5 * t) * 0.5

        # Rustle envelope - quick fade
        rustle_envelope = math.exp(-progress * 8) * math.sin(math.pi * progress)
        sample += rustle * rustle_envelope * 0.18

        # Minimal texture noise
        noise = (random.random() - 0.5) * 0.15
        noise_envelope = math.exp(-progress * 10)
        sample += noise * noise_envelope

        # Clamp and convert to 16-bit integer
        sample = max(-1.0, min(1.0, sample))
        sample_int = int(sample * 32767 * 0.7)  # 70% volume
        audio_data.append(sample_int)

    # Write WAV file
    with wave.open(output_file, 'w') as wav_file:
        wav_file.setnchannels(1)  # Mono
        wav_file.setsampwidth(2)  # 16-bit
        wav_file.setframerate(sample_rate)

        # Pack data as 16-bit signed integers
        packed_data = struct.pack('h' * len(audio_data), *audio_data)
        wav_file.writeframes(packed_data)

    print(f"Generated crisp card flip sound: {output_file}")
    print(f"Duration: {duration}s ({int(duration * 1000)}ms), Sample rate: {sample_rate}Hz")
    print("Features: sharp snap, quick rustle, minimal noise for clarity")

if __name__ == "__main__":
    output_path = "smart-divination/apps/tarot/assets/sounds/card_flip.wav"
    generate_card_flip_sound(output_path)
