# Underwater Garbage Detection — YOLOv10

Detect and classify **15 categories of underwater marine waste** using [YOLOv10](https://github.com/THU-MIG/yolov10), a state-of-the-art real-time object detector.

---
## Project Structure

```
underwater-garbage-detection/
├── yolov10_underwater_garbage.ipynb   # Full pipeline notebook
├── requirements_test.txt              # Python dependencies (inference)
├── setup_test_env.ps1                 # One-click venv setup (Windows)
├── dataset_config/
│   ├── data.yaml                      # Dataset paths & class names
│   └── data_balanced.yaml             # Balanced split variant
└── sample_test/                       # 5 sample images for quick testing
```

---

## Detected Classes (15)

| ID | Class | ID | Class |
|----|-------|----|-------|
| 0 | bottle | 8 | other-colors |
| 1 | can | 9 | peel |
| 2 | cap | 10 | plastic-bag |
| 3 | cigarette | 11 | plastic-box |
| 4 | cup | 12 | plastic-jar |
| 5 | fishing-line | 13 | plastic-gloves |
| 6 | glove | 14 | unknown |
| 7 | mask | | |

---

## Dataset

~5 000 annotated underwater images across three splits:

| Split | Images |
|-------|--------|
| train | 3 628 |
| valid | 1 001 |
| test  | 478 |

Labels are in **YOLO format** (`class_id x_center y_center width height`, normalised 0–1).

> The dataset images are **not included** in this repo due to size. Update the `path:` field in `dataset_config/data.yaml` to match your local dataset location.

---

## Quick Start — Inference Only

> No training required. Use a pre-trained checkpoint.

**1. Set up the environment (Windows, run once):**
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\setup_test_env.ps1
```

**2. Select the `Python (venv_test)` kernel in VS Code** (bottom-right corner).

**3. Run only these notebook sections in order:**
- Section 0 — set dataset paths
- Section 2 — import libraries & resolve device
- Section 11 — single-image inference with bounding-box overlay

Set `TEST_IMAGE_PATH` in Section 11 to the full path of your image, or use any file from `sample_test/`.

**4. (Optional) Gradio web UI:**
- Run Section 12 — opens a browser tab where you can drag-and-drop any image.

---

## Full Training Pipeline

1. Place the dataset at `d:/Project/Underwater_garbage/` (or edit `LOCAL_DATASET_ROOT` in Section 0).
2. Run **Section 1** to auto-install missing packages.
3. Run all sections top-to-bottom.
4. Best weights are saved to `runs/` and timestamped backups to `checkpoints/` after each epoch.

---

## Requirements

Install via:
```bash
pip install -r requirements_test.txt
```

Key packages:
- `torch >= 2.0`
- `ultralytics >= 8.2`
- `opencv-python >= 4.8`
- `gradio` (for the web UI in Section 12)

---

## Model Weights

The best pre-trained checkpoint is included in this repository:

```
checkpoints/yolov10m_underwater_garbage_v2_best.pt   (~32 MB)
```

To use it, point `TEST_WEIGHTS_PATH` in Section 11 (or Section 12) to this file, or simply run Sections 0 → 2 → 11 — the notebook loads it automatically.

If you retrain the model, new epoch checkpoints will be saved to `checkpoints/` locally but are excluded from git (only the best model is tracked).

---

## Notebook Sections at a Glance

| Section | Description |
|---------|-------------|
| 0 | Set dataset paths & patch `data.yaml` |
| 0b | Intel CPU optimisations (IPEX / thread tuning) |
| 1 | Verify & auto-install packages |
| 2 | Imports & device detection |
| 3 | Load `data.yaml`, class counts & dataset stats |
| 4 | Visualise 12 random training images with GT boxes |
| 5 | Validate YOLO format; plot class-frequency bar chart |
| 5b | Build oversampled training list (class balance) |
| 5c | Wipe previous run before fresh training |
| 6 | Configure hyper-parameters; resume vs. fresh start |
| 7 | Launch training with per-epoch checkpoint saves |
| 7b | Manually save a timestamped snapshot of `best.pt` |
| 8 | Evaluate `best.pt` on test split (mAP, P, R, F1) |
| 9 | Plot loss curves & confusion matrix |
| 10 | Batch inference on all test images |
| 11 | Single-image inference + annotated result |
| 12 | Gradio web interface for live detections |

---

## License

This project is released for research and educational purposes.
