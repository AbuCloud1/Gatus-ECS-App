#!/bin/bash

echo "Setting up pre-commit hooks"

pip install pre-commit
pre-commit install

echo "Pre-commit setup complete"
