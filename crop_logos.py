#!/usr/bin/env python3
"""
Script to crop transparent/white space from PNG images
"""
from PIL import Image
import sys

def crop_image(input_path, output_path=None):
    """Crop image to remove transparent/white borders"""
    if output_path is None:
        output_path = input_path

    # Open image
    img = Image.open(input_path)

    # Convert to RGBA if not already
    if img.mode != 'RGBA':
        img = img.convert('RGBA')

    # Get bounding box of non-transparent pixels
    bbox = img.getbbox()

    if bbox:
        # Crop to bounding box
        cropped = img.crop(bbox)

        # Save
        cropped.save(output_path, 'PNG')
        print(f"Cropped {input_path}")
        print(f"  Original size: {img.size}")
        print(f"  Cropped size: {cropped.size}")
        print(f"  Saved to: {output_path}")
        return True
    else:
        print(f"No content found in {input_path}")
        return False

if __name__ == "__main__":
    # List of images to crop
    images = [
        "docs/store-assets/logo.png",
        "docs/store-assets/icon2.png",
        "docs/store-assets/logo-header-1024x350.png",
        "docs/store-assets/logo-header-512x175.png",
        "docs/store-assets/logo-icon-1024x1024.png",
        "docs/store-assets/logo-icon-512x512.png",
        "smart-divination/apps/tarot/assets/branding/logo-header.png",
        "smart-divination/apps/tarot/assets/branding/logo-icon.png",
    ]

    for img_path in images:
        try:
            crop_image(img_path)
            print()
        except FileNotFoundError:
            print(f"File not found: {img_path}")
            print()
        except Exception as e:
            print(f"Error processing {img_path}: {e}")
            print()
