import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/widgets/button/primary_button.dart';
import '../bloc/take_photo_result_bloc.dart';
import '../widgets/generating_result_widget.dart';

class GeneratingResultsSection extends StatelessWidget {
  const GeneratingResultsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakePhotoResultBloc, TakePhotoResultState>(
      buildWhen: (_, state) {
        return state is TakePhotoResultInitial || state is FinishGeneratingResultsState || state is ResultsSuccessState;
      },
      builder: (context, state) {
        if(state is! FinishGeneratingResultsState && state is! TakePhotoResultInitial) return const SizedBox.shrink();
        bool finishGeneratingResults = state is FinishGeneratingResultsState;
        return Expanded(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: GeneratingResultWidget(
                      shouldFinish: finishGeneratingResults),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryButton(
                    text: context.localization.cancel,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              // (context.bottomPadding + 16).verticalSpace,
            ],
          ),
        );
      },
    );
  }
}
