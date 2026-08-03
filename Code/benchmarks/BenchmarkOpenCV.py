import cv2
import time
import os
import tkinter as tk
from tkinter import filedialog

# ─────────────────────────────────────────────
# Load image
# ─────────────────────────────────────────────

root = tk.Tk()
root.withdraw()

image_path = filedialog.askopenfilename(
    title="Select an image to benchmark",
    filetypes=[("Image files", "*.jpg *.jpeg *.png *.bmp *.tiff *.webp")]
)

if not image_path:
    print("No file selected. Exiting.")
    exit()

image = cv2.imread(image_path)

if image is None:
    print(f"Error: Could not load image from '{image_path}'")
    exit()

height, width, channels = image.shape
print(f"\nImage loaded: {width} x {height} pixels, {channels} channels")
print(f"File: {image_path}\n")

NUM_RUNS = 100

input_dir  = os.path.dirname(image_path)
input_name = os.path.splitext(os.path.basename(image_path))[0]

# ─────────────────────────────────────────────
# Sobel benchmark (runs once as a fixed reference)
# ─────────────────────────────────────────────

gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

t0 = time.perf_counter()
sobel_x = cv2.Sobel(gray, cv2.CV_64F, 1, 0, ksize=3)
sobel_y = cv2.Sobel(gray, cv2.CV_64F, 0, 1, ksize=3)
sobel_first_ms = (time.perf_counter() - t0) * 1000

t0 = time.perf_counter()
for _ in range(NUM_RUNS):
    sobel_x = cv2.Sobel(gray, cv2.CV_64F, 1, 0, ksize=3)
    sobel_y = cv2.Sobel(gray, cv2.CV_64F, 0, 1, ksize=3)
sobel_avg_ms = ((time.perf_counter() - t0) / NUM_RUNS) * 1000

# ─────────────────────────────────────────────
# Gaussian benchmark across kernel sizes
# ─────────────────────────────────────────────

kernel_sizes = [1, 5, 7, 9, 15, 29, 43, 57, 71, 85, 101]

results_path = os.path.join(input_dir, f"{input_name}_gaussian_benchmark.txt")

with open(results_path, "w") as results_file:
    for k in kernel_sizes:
        # First run
        # OpenCV's fully optimized path: separable 1D passes, fixed-point arithmetic,
        # SIMD vectorization, and hardware-specific HAL optimizations (e.g., Apple AMX on M-series)
        t0 = time.perf_counter()
        blurred = cv2.GaussianBlur(image, (k, k), 0)
        gaussian_first_ms = (time.perf_counter() - t0) * 1000

        # Averaged runs
        t0 = time.perf_counter()
        for _ in range(NUM_RUNS):
            # OpenCV's fully optimized path: separable 1D passes, fixed-point arithmetic,
            # SIMD vectorization, and hardware-specific HAL optimizations (e.g., Apple AMX on M-series)
            blurred = cv2.GaussianBlur(image, (k, k), 0)
        gaussian_avg_ms = ((time.perf_counter() - t0) / NUM_RUNS) * 1000

        # Save blurred image for this kernel size
        blur_path = os.path.join(input_dir, f"{input_name}_gaussian_k{k:03d}.jpg")
        cv2.imwrite(blur_path, blurred)

        summary = f"""
--- Summary (Kernel Size: {k} x {k}) ---
Image size:              {width} x {height}
Convolution method: cv2.GaussianBlur() — OpenCV optimized separable path

Gaussian Blur first run: {gaussian_first_ms:>8.3f} ms
Gaussian Blur average:   {gaussian_avg_ms:>8.3f} ms
First-run overhead:      {gaussian_first_ms - gaussian_avg_ms:>+8.3f} ms

Sobel Filter  first run: {sobel_first_ms:>8.3f} ms
Sobel Filter  average:   {sobel_avg_ms:>8.3f} ms

--- Reference Numbers ---
Gaussian Kernel Size: {k} x {k} pixels
Sobel Kernel Size:    3 x 3 pixels
# Of Runs:            {NUM_RUNS}

Saved: {blur_path}
"""
        print(summary)
        results_file.write(summary)

# ─────────────────────────────────────────────
# Save Sobel edge image
# ─────────────────────────────────────────────

sobel_magnitude = cv2.magnitude(sobel_x, sobel_y)
sobel_magnitude = cv2.normalize(sobel_magnitude, None, 0, 255, cv2.NORM_MINMAX).astype("uint8")

sobel_path = os.path.join(input_dir, f"{input_name}_sobel_edges.jpg")
cv2.imwrite(sobel_path, sobel_magnitude)
print(f"Saved Sobel: {sobel_path}")

print(f"\nBenchmark results saved to: {results_path}")
