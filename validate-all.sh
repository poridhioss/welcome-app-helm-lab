#!/bin/bash
set -e

CHART_DIR="."
ENVS=("values-dev.yaml" "values-staging.yaml" "values-prod.yaml")

echo "=== Helm Chart Validation ==="
echo

# Step 1: Lint
echo "1. Running helm lint..."
helm lint $CHART_DIR
echo

# Step 2: Validate each environment
echo "2. Validating environments..."
for env in "${ENVS[@]}"; do
    if [ -f "$env" ]; then
        echo -n "   $env: "
        if helm template test $CHART_DIR -f $env > /dev/null 2>&1; then
            echo "OK"
        else
            echo "FAILED"
            helm template test $CHART_DIR -f $env
            exit 1
        fi
    fi
done
echo

echo "=== All validations passed ==="
