#!/usr/bin/env bash

set -e  # stop on error

echo "=============================="
echo "Setting up project environment"
echo "=============================="

# -----------------------------
# Config
# -----------------------------
VENV_NAME="venv"
KERNEL_NAME="genai-env"
PYTHON_BIN="python3"

# -----------------------------
# 1. Create virtual environment
# -----------------------------
if [ ! -d "$VENV_NAME" ]; then
    echo "[1/6] Creating virtual environment..."
    $PYTHON_BIN -m venv $VENV_NAME
else
    echo "[1/6] Virtual environment already exists"
fi

# -----------------------------
# 2. Activate environment
# -----------------------------
echo "[2/6] Activating virtual environment..."
source $VENV_NAME/bin/activate

# -----------------------------
# 3. Upgrade pip
# -----------------------------
echo "[3/6] Upgrading pip..."
pip install --upgrade pip

# -----------------------------
# 4. Install PyTorch (GPU if possible)
# -----------------------------
echo "[4/6] Installing PyTorch..."

read -p "Do you want CUDA-enabled PyTorch? (y/n): " use_cuda

if [ "$use_cuda" = "y" ]; then
    pip install --pre torch torchvision torchaudio \
  --index-url https://download.pytorch.org/whl/nightly/cu128
    pip install torch torchvision
fi

# -----------------------------
# 5. Install project requirements
# -----------------------------
echo "[5/6] Installing requirements..."
pip install -r requirements.txt

# -----------------------------
# 6. Setup Jupyter kernel
# -----------------------------
echo "[6/6] Setting up Jupyter kernel..."
pip install ipykernel

python -m ipykernel install --user \
    --name=$KERNEL_NAME \
    --display-name "Python ($KERNEL_NAME)"

# -----------------------------
# Done
# -----------------------------
echo "=============================="
echo "Setup complete!"
echo ""
echo "To activate later:"
echo "source $VENV_NAME/bin/activate"
echo ""
echo "In Jupyter, select kernel:"
echo "Python ($KERNEL_NAME)"
echo "=============================="
