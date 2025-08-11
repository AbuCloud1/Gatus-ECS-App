#!/bin/bash

echo "Setting up pre-commit hooks..."

# Install pre-commit if not already installed
if ! command -v pre-commit &> /dev/null; then
    echo "Installing pre-commit..."
    pip install pre-commit
else
    echo "pre-commit already installed"
fi

# Install the git hooks
pre-commit install

echo "Pre-commit setup complete!"
echo "Your commits will now automatically run quality checks"
