import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/extension/context_extension.dart';
import '../../../common/widgets/core_widgets.dart';
import '../bloc/nutrition_facts_bloc.dart';
import '../widgets/analyze_progress_widget.dart';
import '../widgets/image_preview_widget.dart';

class PreviewSection extends StatelessWidget {
  const PreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NutritionFactsBloc, NutritionFactsState>(
      buildWhen: (_, state) {
        return state is PreviewBuilderState;
      },
      builder: (context, state) {
        final image = (state is PreviewBuilderState) ? state.image : null;
        final analyzedCompleted =
            state is PreviewBuilderState ? state.analyzedCompleted : false;
        return Column(
          children: [
            Expanded(
              flex: 2,
              child: image == null
                  ? SizedBox.shrink()
                  : ImagePreviewWidget(image: image),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  AnalyzeProgressWidget(
                    shouldFinish: analyzedCompleted,
                  ),
                  IntrinsicWidth(
                    child: PrimaryButton(
                      text: context.localization.cancel,
                      onTap: () {
                        context
                            .read<NutritionFactsBloc>()
                            .add(const UpdateSectionEvent(section: 0));
                      },
                    ),
                  ),
                  (context.bottomPaddingValue + 16).verticalSpace,
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
