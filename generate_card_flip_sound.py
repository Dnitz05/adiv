#!/usr/bin/env python3
"""Generate a realistic card flip sound effect using pure Python (no dependencies)"""

import math
import struct
import wave
import random

def generate_card_flip_sound(output_file, duration=0.2, sample_rate=44100):
    """Generate a realistic paper card flip sound"""

    num_samples = int(duration * sample_rate)

    # Generate sound data
    audio_data = []

    for i in range(num_samples):
        t = i / sample_rate
        progress = i / num_samples

        sample = 0.0

        # Paper snap/pop at the beginning (short burst)
        if progress < 0.15:
            snap_progress = progress / 0.15
            # Quick attack with harmonic content
            snap = 0.0
            for harmonic in range(1, 6):
                freq = 800 * harmonic + random.uniform(-50, 50)
                snap += math.sin(2 * math.pi * freq * t) * (1.0 / harmonic)

            # Sharp envelope for snap
            snap_envelope = math.exp(-snap_progress * 15) * (1 - snap_progress)
            sample += snap * snap_envelope * 0.25

        # Paper flutter (rustling texture throughout)
        flutter_freq = 150 + 200 * progress
        flutter = 0.0
        for j in range(3):
            noise_freq = flutter_freq * (1 + j * 0.3)
            phase = random.uniform(0, 2 * math.pi)
            flutter += math.sin(2 * math.pi * noise_freq * t + phase) * (1.0 / (j + 1))

        # Flutter envelope - gradual fade
        flutter_envelope = math.exp(-progress * 4) * math.sin(math.pi * progress)
        sample += flutter * flutter_envelope * 0.15

        # Add paper texture noise (filtered white noise)
        noise_amount = 0.0
        for k in range(5):
            noise_amount += (random.random() - 0.5) * (1.0 / (k + 1))

        # Noise envelope
        noise_envelope = math.exp(-progress * 5) * (0.5 + 0.5 * math.sin(math.pi * progress))
        sample += noise_amount * noise_envelope * 0.08

        # Final gentle swish (air displacement)
        if progress > 0.3:
            swish_progress = (progress - 0.3) / 0.7
            swish_freq = 400 * (1 - swish_progress * 0.7)
            swish = math.sin(2 * math.pi * swish_freq * t)
            swish_envelope = math.sin(math.pi * swish_progress) * (1 - swish_progress)
            sample += swish * swish_envelope * 0.12

        # Clamp and convert to 16-bit integer
        sample = max(-1.0, min(1.0, sample))
        sample_int = int(sample * 32767 * 0.6)  # 60% volume
        audio_data.append(sample_int)

    # Write WAV file
    with wave.open(output_file, 'w') as wav_file:
        wav_file.setnchannels(1)  # Mono
        wav_file.setsampwidth(2)  # 16-bit
        wav_file.setframerate(sample_rate)

        # Pack data as 16-bit signed integers
        packed_data = struct.pack('h' * len(audio_data), *audio_data)
        wav_file.writeframes(packed_data)

    print(f"Generated realistic card flip sound: {output_file}")
    print(f"Duration: {duration}s, Sample rate: {sample_rate}Hz")
    print("Features: paper snap, flutter, texture noise, air swish")

if __name__ == "__main__":
    output_path = "smart-divination/apps/tarot/assets/sounds/card_flip.wav"
    generate_card_flip_sound(output_path)
