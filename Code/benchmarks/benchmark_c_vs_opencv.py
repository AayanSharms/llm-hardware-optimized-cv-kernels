import cv2
import numpy as np
import subprocess
import os
import time
import tkinter as tk
from tkinter import filedialog

MAKE_DIR = os.path.expanduser("~/Documents/CMU/Research Project/Code/c_implementations")
subprocess.run(["make"], cwd=MAKE_DIR, check=True)

C_BINARY = os.path.expanduser(
    "~/Documents/CMU/Research Project/Code/c_implementations/build/gaussianbluroptimizationwithcompilerflags"
)

# ---------------------------------------------------------
KERNEL_SIZES = [1, 5, 7, 9, 15, 29, 43, 57, 71, 85, 101]
NUM_RUNS = 100

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
# -----------------------------------------------------------
image_bgr = cv2.imread(IMAGE_PATH)
height, width = image_bgr.shape[:2]
raw_bytes = image_bgr.tobytes()  # full 3-channel BGR, matches what the C binary now reads

output_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "blur_outputs")
os.makedirs(output_dir, exist_ok=True)
print(f"Saving verification images to: {output_dir}\n")

print(f"Image: {width}x{height}  |  Runs per kernel: {NUM_RUNS}\n")
print(f"{'Kernel':>8}  {'OpenCV (ms)':>12}  {'C impl (ms)':>12}  {'Ratio':>8}")
print("-" * 48)

for k in KERNEL_SIZES:
    opencv_blurred = cv2.GaussianBlur(image_bgr, (k, k), 0)  # warmup, result reused for export

    t0 = time.perf_counter()
    for _ in range(NUM_RUNS):
        cv2.GaussianBlur(image_bgr, (k, k), 0)
    t1 = time.perf_counter()
    opencv_ms = (t1 - t0) / NUM_RUNS * 1000

    opencv_path = os.path.join(output_dir, f"opencv_k{k}.jpg")
    if not cv2.imwrite(opencv_path, opencv_blurred):
        print(f"  k={k}: WARNING — failed to save OpenCV image to {opencv_path}")

    result = subprocess.run(
        [C_BINARY, str(width), str(height), str(k), str(NUM_RUNS)],
        input=raw_bytes,
        capture_output=True
    )

    if result.returncode != 0:
        print(f"  k={k}: C error — {result.stderr.decode().strip()}")
        continue

    expected_bytes = height * width * 3
    if len(result.stdout) != expected_bytes:
        print(f"  k={k}: C output size mismatch — got {len(result.stdout)} bytes, expected {expected_bytes}")
        continue

    c_output = np.frombuffer(result.stdout, dtype=np.uint8).reshape(height, width, 3)
    c_path = os.path.join(output_dir, f"gaussian_c_implementation_k{k}.jpg")
    if not cv2.imwrite(c_path, c_output):
        print(f"  k={k}: WARNING — failed to save C image to {c_path}")

    c_ms  = float(result.stderr.decode().strip())
    ratio = c_ms / opencv_ms

    print(f"{k:>6}x{k:<2}  {opencv_ms:>12.3f}  {c_ms:>12.3f}  {ratio:>7.2f}x")

print("\nRatio > 1.0 means C is slower than OpenCV. Goal: drive ratio toward 1.0.")
