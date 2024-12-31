import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_button_styles.dart';
import '../../../../common/constant/app_padding.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/widgets/app_button.dart';
import '../widgets/generating_result_widget.dart';
import '../widgets/result_top_widget.dart';

class ResultSection extends StatelessWidget {
  const ResultSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      children: [
        ResultTopWidget(),
        _GeneratingResultSection(
          onCancel: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class _GeneratingResultSection extends StatelessWidget {
  const _GeneratingResultSection({this.onCancel});
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Center(child: GeneratingResultWidget()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                buttonText: context.localization?.cancel,
                appButtonModel: AppButtonStyles.primary.copyWith(
                  padding: AppPadding.ph40 + AppPadding.pv12
                ),
                onTap: onCancel,
              ),
            ],
          ),
          (context.bottomPadding + 16).verticalSpace,
        ],
      ),
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
