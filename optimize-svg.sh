#!/bin/sh

DIRECTORIES=("common" "finance" "insurance" "precisionBreeding" "supervision")

for DIR in "${DIRECTORIES[@]}"; do
  mkdir -p "assets/icon/$DIR/optimized"
  svgo -f "assets/icon/$DIR" -o "assets/icon/$DIR/optimized"
done
