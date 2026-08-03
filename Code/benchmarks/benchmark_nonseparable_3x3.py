import cv2
import numpy as np
import subprocess
import os
import tkinter as tk
from tkinter import filedialog

MAKE_DIR = os.path.expanduser("~/Documents/CMU/Research Project/Code/c_implementations")
C_BINARY = os.path.expanduser(
    "~/Documents/CMU/Research Project/Code/c_implementations/build/gaussian_blur_nonseparable_3x3"
)
NUM_RUNS = 100000

subprocess.run(["make", "gaussian_blur_nonseparable_3x3"], cwd=MAKE_DIR, check=True)

# File picker
root = tk.Tk()
root.withdraw()
IMAGE_PATH = filedialog.askopenfilename(
    title="Select a benchmark image",
    filetypes=[("Image files", "*.jpg *.jpeg *.png *.bmp *.tiff *.webp")]
)
if not IMAGE_PATH:
    print("No file selected. Exiting.")
    exit()

image_bgr = cv2.imread(IMAGE_PATH)
if image_bgr is None:
    print(f"Failed to load image: {IMAGE_PATH}")
    exit(1)

height, width = image_bgr.shape[:2]
raw_bytes = image_bgr.tobytes()  # full 3-channel BGR, matches what the C binary reads

print(f"Image: {width}x{height}  |  Runs: {NUM_RUNS}")

result = subprocess.run(
    [C_BINARY, str(width), str(height), str(NUM_RUNS)],
    input=raw_bytes,
    capture_output=True
)

if result.returncode != 0:
    print(f"C binary error:\n{result.stderr.decode().strip()}")
    exit(1)

expected_bytes = height * width * 3
if len(result.stdout) != expected_bytes:
    print(f"Output size mismatch: got {len(result.stdout)} bytes, expected {expected_bytes}")
    exit(1)

c_output = np.frombuffer(result.stdout, dtype=np.uint8).reshape(height, width, 3)

output_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "blur_outputs")
os.makedirs(output_dir, exist_ok=True)

input_stem = os.path.splitext(os.path.basename(IMAGE_PATH))[0]
out_path = os.path.join(output_dir, f"nonseparable_3x3_{input_stem}.jpg")
cv2.imwrite(out_path, c_output)
print(f"Saved blurred image to: {out_path}")

avg_ms = float(result.stderr.decode().strip())
print(f"Average interior blur time ({NUM_RUNS} runs): {avg_ms:.4f} ms")
