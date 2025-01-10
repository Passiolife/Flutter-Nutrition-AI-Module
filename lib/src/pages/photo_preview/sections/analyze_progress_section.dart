import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/widgets/passio/analyzing_progress_widget.dart';
import '../bloc/photo_preview_bloc.dart';

class AnalyzeProgressSection extends StatelessWidget {
  const AnalyzeProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoPreviewBloc, PhotoPreviewState>(
      buildWhen: (_, state) {
        return state is AnalyzeCompletedState;
      },
      builder: (context, state) {
        return Expanded(
          child: Center(
            child: Padding(
              padding: AppPadding.ph32,
              child: AnalyzingProgressWidget(
                text: context.localization.analyzingPhoto,
                shouldFinish: state is AnalyzeCompletedState,
              ),
            ),
          ),
        );
      },
    );
  }
}
