#!/bin/bash
# Installation script for the pauta ConTeXt module
# Installs the module to a specified ConTeXt installation directory

set -e

MODULE_NAME="pauta"
MODULE_FILE="tex/context/third/${MODULE_NAME}/t-${MODULE_NAME}.mkxl"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to extract version from module file
extract_version() {
    local file="$1"
    if [ -f "$file" ]; then
        grep -E '^\s*%D\s+version=' "$file" | sed -E 's/.*version=([0-9.]+).*/\1/' | head -1
    fi
}

# Function to compare version strings
# Returns: 0 if versions are equal, 1 if v1 > v2, 2 if v1 < v2
compare_versions() {
    local v1="$1"
    local v2="$2"
    
    if [ "$v1" = "$v2" ]; then
        return 0
    fi
    
    # Convert to comparable format (YYYY.MM.DD or similar)
    # Simple string comparison works for date-based versions
    if [[ "$v1" > "$v2" ]]; then
        return 1
    else
        return 2
    fi
}

# Check if module file exists
if [ ! -f "$MODULE_FILE" ]; then
    echo -e "${RED}Error: Module file not found: ${MODULE_FILE}${NC}"
    exit 1
fi

# Extract current version
CURRENT_VERSION=$(extract_version "$MODULE_FILE")
if [ -z "$CURRENT_VERSION" ]; then
    echo -e "${RED}Error: Could not extract version from module file${NC}"
    exit 1
fi

echo -e "${BLUE}Module: ${MODULE_NAME}${NC}"
echo -e "${BLUE}Current version: ${CURRENT_VERSION}${NC}"
echo ""

# Get ConTeXt installation path
if [ -z "$1" ]; then
    # Try to detect common ConTeXt installation paths
    if [ -n "$LMTX_PATH" ]; then
        CONTEXT_ROOT="$LMTX_PATH"
    elif [ -d "/home/$USER/Apps/lmtx" ]; then
        CONTEXT_ROOT="/home/$USER/Apps/lmtx"
    elif [ -d "$HOME/context" ]; then
        CONTEXT_ROOT="$HOME/context"
    else
        echo -e "${YELLOW}Please specify the ConTeXt installation directory:${NC}"
        echo "Usage: $0 <context-installation-path>"
        echo "Example: $0 /home/user/Apps/lmtx"
        exit 1
    fi
else
    CONTEXT_ROOT="$1"
fi

# Validate ConTeXt installation path
if [ ! -d "$CONTEXT_ROOT" ]; then
    echo -e "${RED}Error: ConTeXt installation directory does not exist: ${CONTEXT_ROOT}${NC}"
    exit 1
fi

# Check for TDS structure
TDS_TEX="${CONTEXT_ROOT}/tex/texmf-modules/tex/context/third/${MODULE_NAME}"
TDS_DOC="${CONTEXT_ROOT}/tex/texmf-modules/doc/context/third/${MODULE_NAME}"
TDS_INTERFACE="${CONTEXT_ROOT}/tex/texmf-modules/tex/context/interface/third"

if [ ! -d "${CONTEXT_ROOT}/tex/texmf-modules" ]; then
    echo -e "${YELLOW}Warning: texmf-modules directory not found. Creating structure...${NC}"
    mkdir -p "${CONTEXT_ROOT}/tex/texmf-modules"
fi

# Check if module is already installed
INSTALLED_VERSION=""
if [ -f "${TDS_TEX}/t-${MODULE_NAME}.mkxl" ]; then
    INSTALLED_VERSION=$(extract_version "${TDS_TEX}/t-${MODULE_NAME}.mkxl")
    echo -e "${YELLOW}Module already installed!${NC}"
    echo -e "  Installed version: ${INSTALLED_VERSION}"
    echo -e "  Current version:   ${CURRENT_VERSION}"
    echo ""
    
    if [ "$INSTALLED_VERSION" = "$CURRENT_VERSION" ]; then
        echo -e "${YELLOW}Versions are identical.${NC}"
        read -p "Overwrite existing installation? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Installation cancelled."
            exit 0
        fi
    else
        # Compare versions (disable set -e temporarily to capture return value)
        set +e
        compare_versions "$CURRENT_VERSION" "$INSTALLED_VERSION"
        COMPARE_RESULT=$?
        set -e
        
        if [ $COMPARE_RESULT -eq 1 ]; then
            echo -e "${GREEN}This is an update (newer version).${NC}"
        elif [ $COMPARE_RESULT -eq 2 ]; then
            echo -e "${RED}Warning: This is a downgrade (older version).${NC}"
        fi
        
        echo ""
        echo "Options:"
        echo "  1) Overwrite with current version"
        echo "  2) Keep existing version"
        echo "  3) Cancel"
        read -p "Choose an option (1-3): " -n 1 -r
        echo
        
        case $REPLY in
            1)
                echo -e "${GREEN}Proceeding with installation...${NC}"
                ;;
            2)
                echo "Keeping existing version. Installation cancelled."
                exit 0
                ;;
            3|*)
                echo "Installation cancelled."
                exit 0
                ;;
        esac
    fi
else
    echo -e "${GREEN}Installing new module...${NC}"
fi

echo ""
echo -e "${BLUE}Installation path: ${CONTEXT_ROOT}${NC}"
echo ""

# Create TDS directories
echo "Creating directory structure..."
mkdir -p "$TDS_TEX"
mkdir -p "$TDS_DOC"
mkdir -p "$TDS_INTERFACE"

# Copy files
echo "Copying module files..."
cp -v "tex/context/third/${MODULE_NAME}/t-${MODULE_NAME}.mkxl" "$TDS_TEX/"

echo "Copying documentation..."
rsync -av --exclude='*.log' --exclude='*.tuc' --exclude='*.tuo' \
  --exclude='README-md-*.tex' \
  "doc/context/third/${MODULE_NAME}/" "$TDS_DOC/"

# Copy interface file if it exists
if [ -f "tex/context/interface/third/t-${MODULE_NAME}.xml" ]; then
    echo "Copying interface file..."
    cp -v "tex/context/interface/third/t-${MODULE_NAME}.xml" "$TDS_INTERFACE/"
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Rebuild the ConTeXt database:"
echo "   context --generate"
echo ""
echo "2. Test the installation:"
echo "   context --path=${CONTEXT_ROOT}/tex/texmf-modules your-test-file.tex"
echo ""
