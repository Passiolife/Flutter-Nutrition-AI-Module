import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_colors.dart';
import '../bloc/food_scan_bloc.dart';

class CameraSection extends StatefulWidget {
  const CameraSection({super.key});

  @override
  State<CameraSection> createState() => _CameraSectionState();
}

class _CameraSectionState extends State<CameraSection> {
  // This flag controls the visibility of the Passio preview,
  bool _showPassioPreview = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FoodScanBloc, FoodScanState>(
      listenWhen: (_, state) {
        return state is ScanningState;
      },
      listener: (context, state) {
        if (state is ScanningState) {
          _showPassioPreview = true;
        }
      },
      buildWhen: (_, state) {
        return state is ScanningState;
      },
      builder: (context, state) {
        return _showPassioPreview
            ? const PassioPreview()
            : Container(color: AppColors.black);
      },
    );
  }
}
