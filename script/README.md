# Icon Generation Script

This directory contains the automated script for generating Flutter Lucide icons from the official Lucide icon set.

## Overview

The script processes icon metadata and generates a comprehensive Dart file containing all available Lucide icons with proper documentation, categories, and contributor information.

## Prerequisites

- Dart SDK (>=3.4.1)
- Access to [Lucide Icons releases](https://github.com/lucide-icons/lucide/releases)

## Update Process

### 1. Download Latest Release

Visit the [Lucide Icons releases page](https://github.com/lucide-icons/lucide/releases/tag/${version}) and download:

- `lucide-font-${version}.zip` - Contains font files and metadata
- `lucide-icons-${version}.zip` - Contains icon definitions and SVG files

### 2. Extract and Replace Files

Extract both packages and replace the following files:

**From `lucide-icons-${version}/`:**
- Replace `script/icons/` directory with the extracted icons directory

**From `lucide-font-${version}/`:**
- Replace `script/info.json` with the extracted info.json file
- Replace `lib/fonts/lucide.ttf` with the extracted font file

### 3. Generate Icons

Navigate to the script directory and run the generation script:

```bash
cd script/
dart lib/script.dart
```

### 4. Update Main Library

Move the generated file to replace the main library:

```bash
mv flutter_lucide_update.txt ../lib/src/flutter_lucide.dart
```

## What the Script Does

- Processes JSON metadata for each icon
- Generates comprehensive Dart documentation
- Creates static IconData constants with proper Unicode mappings
- Includes contributor acknowledgments and category information
- Ensures consistent naming conventions (kebab-case → snake_case)
- Maintains tree-shaking compatibility

## Output

The script generates a complete `flutter_lucide.dart` file containing:
- 1,666+ icon constants
- Rich documentation for each icon
- Proper font family and package references
- Category and tag information
- Contributor acknowledgments

## Troubleshooting

- Ensure all required files are properly replaced before running the script
- Check that the Dart SDK version meets the requirements
- Verify that the generated file is properly formatted and compiles
