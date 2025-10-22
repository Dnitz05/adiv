#!/usr/bin/env python3
"""
Script to crop logo-header.png removing dark background
"""
from PIL import Image
import numpy as np

def crop_logo_header(input_path, output_path):
    """Crop logo by detecting non-background content"""
    # Open image
    img = Image.open(input_path)

    # Convert to RGBA
    if img.mode != 'RGBA':
        img = img.convert('RGBA')

    # Convert to numpy array
    data = np.array(img)

    # Get the background color from corner (assume corners are background)
    bg_color = data[0, 0]

    # Create mask of pixels that are significantly different from background
    # Calculate difference in RGB channels
    diff = np.abs(data[:, :, :3].astype(int) - bg_color[:3].astype(int))
    # Sum differences across channels
    total_diff = np.sum(diff, axis=2)
    # Pixels with difference > threshold are considered content
    threshold = 30
    content_mask = total_diff > threshold

    # Find bounding box of content
    rows = np.any(content_mask, axis=1)
    cols = np.any(content_mask, axis=0)

    if rows.any() and cols.any():
        ymin, ymax = np.where(rows)[0][[0, -1]]
        xmin, xmax = np.where(cols)[0][[0, -1]]

        # Add small padding
        padding = 5
        ymin = max(0, ymin - padding)
        ymax = min(data.shape[0] - 1, ymax + padding)
        xmin = max(0, xmin - padding)
        xmax = min(data.shape[1] - 1, xmax + padding)

        # Crop
        cropped = img.crop((xmin, ymin, xmax + 1, ymax + 1))

        # Convert to RGBA with transparent background
        cropped_data = np.array(cropped)
        # Make background transparent
        bg_mask = np.all(np.abs(cropped_data[:, :, :3].astype(int) - bg_color[:3].astype(int)) <= threshold, axis=2)
        cropped_data[bg_mask, 3] = 0

        # Save
        result = Image.fromarray(cropped_data, 'RGBA')
        result.save(output_path, 'PNG')

        print(f"Cropped {input_path}")
        print(f"  Original size: {img.size}")
        print(f"  Cropped size: {result.size}")
        print(f"  Saved to: {output_path}")
        return True
    else:
        print(f"No content found in {input_path}")
        return False

if __name__ == "__main__":
    crop_logo_header(
        "smart-divination/apps/tarot/assets/branding/logo-header.png",
        "smart-divination/apps/tarot/assets/branding/logo-header.png"
    )
