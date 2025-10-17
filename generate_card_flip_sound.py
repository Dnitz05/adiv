#!/usr/bin/env python3
"""Generate a simple card flip sound effect using pure Python (no dependencies)"""

import math
import struct
import wave

def generate_card_flip_sound(output_file, duration=0.15, sample_rate=44100):
    """Generate a whoosh/flip sound for card turning"""

    num_samples = int(duration * sample_rate)

    # Generate sound data
    audio_data = []

    for i in range(num_samples):
        t = i / sample_rate
        progress = i / num_samples

        # Create a frequency sweep from high to low (whoosh effect)
        start_freq = 1200
        end_freq = 200
        freq = start_freq + (end_freq - start_freq) * progress

        # Generate sine wave
        sample = math.sin(2 * math.pi * freq * t)

        # Apply envelope (fade in and out)
        envelope = math.sin(math.pi * progress)
        sample *= envelope * 0.3  # Reduce volume to 30%

        # Add slight noise for texture
        noise = (hash(i) % 1000 / 1000.0 - 0.5) * 0.05
        sample += noise * envelope

        # Clamp and convert to 16-bit integer
        sample = max(-1.0, min(1.0, sample))
        sample_int = int(sample * 32767)
        audio_data.append(sample_int)

    # Write WAV file
    with wave.open(output_file, 'w') as wav_file:
        wav_file.setnchannels(1)  # Mono
        wav_file.setsampwidth(2)  # 16-bit
        wav_file.setframerate(sample_rate)

        # Pack data as 16-bit signed integers
        packed_data = struct.pack('h' * len(audio_data), *audio_data)
        wav_file.writeframes(packed_data)

    print(f"Generated card flip sound: {output_file}")
    print(f"Duration: {duration}s, Sample rate: {sample_rate}Hz")

if __name__ == "__main__":
    output_path = "smart-divination/apps/tarot/assets/sounds/card_flip.wav"
    generate_card_flip_sound(output_path)
