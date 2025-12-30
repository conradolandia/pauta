#!/bin/bash
# Task manager script for creating ConTeXt module releases
# Based on guidelines from: https://wiki.contextgarden.net/ConTeXt_and_Lua_programming/Module_writing

set -e

MODULE_NAME="pauta"
VERSION=$(cat VERSION | tr -d '\n')
RELEASE_NAME="${MODULE_NAME}-${VERSION}"
TEMP_DIR=$(mktemp -d)
RELEASE_DIR="${TEMP_DIR}/${RELEASE_NAME}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Creating release: ${RELEASE_NAME}${NC}"

# Create release directory structure
mkdir -p "${RELEASE_DIR}"

# Copy top-level files
echo "Copying top-level files..."
cp VERSION "${RELEASE_DIR}/"
cp README.md "${RELEASE_DIR}/"
cp LICENSE "${RELEASE_DIR}/"

# Copy TDS structure
echo "Copying TDS structure..."
mkdir -p "${RELEASE_DIR}/doc/context/third/${MODULE_NAME}"
mkdir -p "${RELEASE_DIR}/tex/context/third/${MODULE_NAME}"
mkdir -p "${RELEASE_DIR}/tex/context/interface/third"

# Copy documentation (exclude build artifacts, but keep PDFs for documentation)
echo "Copying documentation..."
rsync -av --exclude='*.log' --exclude='*.tuc' --exclude='*.tuo' \
  --exclude='README-md-*.tex' \
  "doc/context/third/${MODULE_NAME}/" "${RELEASE_DIR}/doc/context/third/${MODULE_NAME}/"

# Copy code files
echo "Copying code files..."
rsync -av --exclude='*.log' --exclude='*.tuc' --exclude='*.tuo' \
  "tex/context/third/${MODULE_NAME}/" "${RELEASE_DIR}/tex/context/third/${MODULE_NAME}/"

# Copy interface file if it exists
if [ -f "tex/context/interface/third/t-${MODULE_NAME}.xml" ]; then
  echo "Copying interface file..."
  cp "tex/context/interface/third/t-${MODULE_NAME}.xml" "${RELEASE_DIR}/tex/context/interface/third/"
fi

# Create ZIP archive
echo "Creating ZIP archive..."
cd "${TEMP_DIR}"
zip -r "${RELEASE_NAME}.zip" "${RELEASE_NAME}" > /dev/null
cd - > /dev/null

# Move ZIP to current directory
mv "${TEMP_DIR}/${RELEASE_NAME}.zip" .

# Cleanup
rm -rf "${TEMP_DIR}"

echo -e "${GREEN}Release created: ${RELEASE_NAME}.zip${NC}"
echo ""
echo "Release structure:"
unzip -l "${RELEASE_NAME}.zip" | head -20
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Test the release by extracting and installing it"
echo "2. Upload to https://modules.contextgarden.net"
echo "3. Or install locally with: mtxrun --install ${RELEASE_NAME}.zip"
