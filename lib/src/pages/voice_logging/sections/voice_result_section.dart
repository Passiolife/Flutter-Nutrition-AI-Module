import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/models/voice_log/voice_log.dart';
import '../../../common/util/context_extension.dart';
import '../../food_search/food_search_page.dart';
import '../bloc/voice_logging_bloc.dart';
import '../widgets/result_widget.dart';

class VoiceResultSection extends StatelessWidget {
  const VoiceResultSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceLoggingBloc, VoiceLoggingState>(
      buildWhen: (_, state) {
        return state is VoiceLoggingInitial ||
            state is RecognizeVoiceLogsSuccessState ||
            state is FoodLogLoadingBuilderState ||
            state is UpdateRecognizeVoiceLogsState;
      },
      builder: (context, state) {
        List<VoiceLog>? voiceLogs;
        if (state is RecognizeVoiceLogsSuccessState) {
          voiceLogs = state.data;
        } else if (state is UpdateRecognizeVoiceLogsState) {
          voiceLogs = state.data;
        } else if (state is FoodLogLoadingBuilderState) {
          voiceLogs = state.data;
        }

        final visibleLoadingForLog =
            (state is FoodLogLoadingBuilderState) ? state.isLogLoading : false;

        if (voiceLogs?.isEmpty ?? true) {
          return SizedBox.shrink();
        }

        return Expanded(
          child: ResultWidget(
            title: context.localization?.result ?? '',
            subtitle: context.localization?.resultDescription ?? '',
            voiceLogs: voiceLogs,
            onChangeSelection: (index, voiceLog) => _onChangeSelection(
                context: context, index: index, data: voiceLog),
            clearVisible: voiceLogs?.hasSelectedItems() ?? false,
            onClear: () => _onClear(context: context),
            onTapSearch: () => _onTapSearch(context: context),
            onTryAgain: () => _onTryAgain(context: context),
            logButtonEnabled: voiceLogs?.hasSelectedItems() ?? false,
            visibleLoadingForLog: visibleLoadingForLog,
            onLogSelected: () => _onLogSelected(context: context),
          ),
        );
      },
    );
  }

  void _onChangeSelection({
    required BuildContext context,
    required int index,
    required VoiceLog data,
  }) {
    context
        .read<VoiceLoggingBloc>()
        .add(UpdateSelectionEvent(index: index, voiceLog: data));
  }

  void _onClear({required BuildContext context}) {
    context.read<VoiceLoggingBloc>().add(const ClearSelectionEvent());
  }

  void _onTapSearch({required BuildContext context}) {
    FoodSearchPage.navigate(context, needsReturn: false);
  }

  void _onTryAgain({required BuildContext context}) {
    context.read<VoiceLoggingBloc>().add(const TryAgainEvent());
  }

  void _onLogSelected({required BuildContext context}) {
    context.read<VoiceLoggingBloc>().add(const DoFoodLogEvent());
  }
}
