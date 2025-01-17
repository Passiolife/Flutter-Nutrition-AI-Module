import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/extension/context_extension.dart';
import '../../../../common/extension/string_extensions.dart';
import '../../../../common/widgets/icons/barcode_scan_widget.dart';
import '../../../../common/widgets/passio_image_widget.dart';
import '../../../../common/widgets/text_input/primary_text_input.dart';

class DetailsWidget extends StatelessWidget {
  const DetailsWidget({
    required this.iconId,
    this.barcode,
    this.nameController,
    this.index,
    super.key,
  });

  final int? index;
  final String iconId;
  final String? barcode;

  final TextEditingController? nameController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PassioImageWidget(
          key: ValueKey(iconId),
          iconId: iconId,
          radius: 20.r,
          heroTag: '$iconId-$index',
        ),
        8.horizontalSpace,
        Expanded(
          child: Column(
            spacing: 8.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryTextInput(
                isDense: true,
                hintText: context.localization.enterName.toUpperCaseWord,
                controller: nameController,
                // Disable the error text by setting empty error style
                errorStyle: TextStyle(height: 0.01),
                validator: (value) {
                  return value.isNotNullOrEmpty ? null : '';
                },
                autoValidateMode: AutovalidateMode.onUserInteraction,
              ),
              PrimaryTextInput(
                key: ValueKey(barcode),
                isDense: true,
                hintText:
                    context.localization.enterBarcode.toUpperCaseWord ?? '',
                initialValue: barcode,
                readOnly: true,
                suffix: UnconstrainedBox(child: BarcodeScanWidget()),
                onTap: () async {
                  /*String? barcode =
                      await BarcodeScannerPage.navigate(context: context);
                  if (barcode?.isNotEmpty ?? false) {
                    setState(() {
                      _barcode = barcode;
                    });
                    widget.onChange?.call(_nameController.text, _barcode);
                  }*/
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
