from PIL import Image
import sys

# Open the image
img = Image.open('docs/store-assets/logo.png')

# Get the bounding box of the non-transparent area
bbox = img.getbbox()

if bbox:
    # Crop to the bounding box
    img_cropped = img.crop(bbox)

    # Save the cropped image
    img_cropped.save('docs/store-assets/logo_cropped.png')
    print(f"Image cropped from {img.size} to {img_cropped.size}")
    print(f"Saved to logo_cropped.png")
else:
    print("No bounding box found")
    sys.exit(1)
