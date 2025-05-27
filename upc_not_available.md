# UPC Not Available Flow

This document outlines the flow for handling scenarios where a barcode scanned in the food scanner is not found in the database. The proposed implementation ensures users can still proceed by scanning nutrition facts and creating custom food entries.

## Steps to Test the Flow
1. Clone the project repository from the following link:
   [Flutter-Nutrition-AI-Module (v3.0.0)](https://github.com/Passiolife/Flutter-Nutrition-AI-Module/tree/3.0.0)

2. Locate the following import in the file `nutrition_ai_page.dart`:
   ```dart
   import 'pages/scan_a_barcode/food_scan_page.dart';
   ```
3. Replace it with:
    ```dart
    import 'pages/food_scan/food_scan_page.dart';
    ```
4. Run the project to activate the food scanner flow. In the dashboard, tap the floating action button and select the **Scan a Barcode** menu option. This will redirect you to the food scanner screen, where you can test the UPC not available flow.

## Current Implementation Overview

When users access the food scanner screen, they have three scanning modes:
1. **Visual Scanner**: Uses the camera for visual recognition of food items.
2. **Barcode Scanner**: Scans barcodes of food items.
3. **Nutrition Facts Scanner**: Scans nutrition facts labels to extract data.

### Barcode Not Recognized Flow
1. **Barcode Scan Attempt**:
    - If a user selects the **Barcode Scanner** mode and scans a barcode that is not available in our database, a popup appears with the message: “Barcode not recognized.”
    - The popup offers two actions:
        - **Cancel**: Dismisses the popup and keeps the user in the Barcode Scanner mode.
        - **Scan Nutrition Facts**: Updates the scanner mode to **Nutrition Facts Scanner**.

2. **Switch to Nutrition Facts Scanner**:
    - When in **Nutrition Facts Scanner** mode, users can scan the nutrition label on the product.
    - Real-time macro values (calories, carbs, protein, fat, etc.) are updated and displayed in the result view.

3. **Proceed to Custom Food Creation**:
    - After reviewing the scanned values, users can click the **Next** button.
    - The **Next** button navigates to the **Custom Food Creation** flow, where users can:
        - Review and modify the extracted nutrition values if needed.
        - Add any missing data.
        - Save the entry as a custom food item in the database.

## Benefits
- Enhanced user experience by providing an alternate flow.
- Allows users to create and store custom food data, improving app utility.
- Ensures no dead ends, even if a barcode is not in the database.