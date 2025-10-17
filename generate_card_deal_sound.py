#!/usr/bin/env python3
"""
Generate a realistic card dealing sound effect - softer swish/slide
For dealing cards face-down onto the table
"""

import numpy as np
import wave
import struct


def generate_card_deal_sound(output_file, duration=0.10, sample_rate=44100):
    """Generate a soft card dealing sound (swish/slide)"""
    t = np.linspace(0, duration, int(sample_rate * duration))

    # Soft swishing sound - quieter than flip
    # Quick frequency sweep for the slide
    freq_start = 400
    freq_end = 200
    freq = np.linspace(freq_start, freq_end, len(t))

    # Generate the swish
    swish = np.sin(2 * np.pi * freq * t)

    # Quick attack, gentle decay envelope
    envelope = np.exp(-t * 25)  # Faster decay
    envelope[:int(len(t) * 0.05)] = np.linspace(0, 1, int(len(t) * 0.05))  # Quick attack

    # Apply envelope
    sound = swish * envelope

    # Add subtle paper texture (filtered noise)
    noise = np.random.uniform(-0.05, 0.05, len(t))  # Much quieter noise
    texture_envelope = np.exp(-t * 30)
    textured_noise = noise * texture_envelope

    # Combine
    sound = sound + textured_noise

    # Normalize and set volume to 50% (quieter than flip at 70%)
    sound = sound / np.max(np.abs(sound)) * 0.5

    # Convert to 16-bit PCM
    sound_int = np.int16(sound * 32767)

    # Write WAV file
    with wave.open(output_file, 'w') as wav_file:
        wav_file.setnchannels(1)  # Mono
        wav_file.setsampwidth(2)  # 16-bit
        wav_file.setframerate(sample_rate)
        wav_file.writeframes(sound_int.tobytes())

    print(f"Generated card deal sound: {output_file}")
    print(f"Duration: {duration*1000:.0f}ms")
    print(f"Volume: 50%")


if __name__ == "__main__":
    output_path = "smart-divination/apps/tarot/assets/sounds/card_deal.wav"
    generate_card_deal_sound(output_path)
