import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/widgets/passio/analyzing_progress_widget.dart';

class AnalyzeProgressWidget extends StatelessWidget {
  const AnalyzeProgressWidget({
    required this.shouldFinish,
    super.key,
  });

  final bool shouldFinish;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: AppPadding.ph32,
          child: AnalyzingProgressWidget(
            text: context.localization.analyzingPhoto,
            shouldFinish: shouldFinish,
          ),
        ),
      ),
    );
  }
}
