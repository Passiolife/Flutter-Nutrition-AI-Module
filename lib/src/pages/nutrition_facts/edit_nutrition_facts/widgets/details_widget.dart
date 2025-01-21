import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/extension/context_extension.dart';
import '../../../../common/extension/string_extensions.dart';
import '../../../../common/widgets/icons/barcode_scan_widget.dart';
import '../../../../common/widgets/passio_image_widget.dart';
import '../../../../common/widgets/text_input/primary_text_input.dart';

class DetailsWidget extends StatefulWidget {
  const DetailsWidget({
    required this.iconId,
    this.barcode,
    this.index,
    this.imageBytes,
    this.onTapBarcode,
    this.initialName,
    this.onNameChanged,
    super.key,
  });

  final int? index;
  final String? iconId;
  final String? barcode;
  final Uint8List? imageBytes;

  // Name Properties
  final String? initialName;
  final ValueChanged<String>? onNameChanged;

  final VoidCallback? onTapBarcode;


  @override
  State<DetailsWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {

  late TextEditingController _nameController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.initialName);
    _nameController.addListener(() {
      widget.onNameChanged?.call(_nameController.text);
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DetailsWidget oldWidget) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if(oldWidget.initialName != widget.initialName) {
        _nameController.text = widget.initialName ?? '';
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PassioImageWidget(
          key: ObjectKey([widget.iconId, widget.imageBytes]),
          iconId: widget.iconId,
          radius: 20.r,
          heroTag: '${widget.iconId}-${widget.index}',
          image: widget.imageBytes,
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
                controller: _nameController,
                // Disable the error text by setting empty error style
                errorStyle: TextStyle(height: 0.01),
                validator: (value) {
                  return value.isNotNullOrEmpty ? null : '';
                },
                autoValidateMode: AutovalidateMode.onUserInteraction,
              ),
              PrimaryTextInput(
                key: ValueKey(widget.barcode),
                isDense: true,
                hintText:
                    context.localization.enterBarcode.toUpperCaseWord ?? '',
                initialValue: widget.barcode,
                readOnly: true,
                suffix: UnconstrainedBox(child: BarcodeScanWidget()),
                onTap: widget.onTapBarcode,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
