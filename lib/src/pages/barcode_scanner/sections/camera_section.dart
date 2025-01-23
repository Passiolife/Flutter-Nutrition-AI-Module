import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/constant/app_colors.dart';
import '../bloc/barcode_scanner_bloc.dart';

class CameraSection extends StatelessWidget {
  const CameraSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BarcodeScannerBloc, BarcodeScannerState>(
      buildWhen: (_, state) {
        return state is ScanningBuilderState;
      },
      builder: (context, state) {
        return state is ScanningBuilderState
            ? const PassioPreview()
            : ColoredBox(color: AppColors.black);
        return Container();
      },
    );
  }
}
