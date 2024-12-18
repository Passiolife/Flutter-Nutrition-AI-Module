import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/voice_logging_bloc.dart';
import '../widgets/generating_results_widget.dart';
import '../widgets/listening_wave_widget.dart';
import '../widgets/tutorial_widget.dart';

class VoiceProcessingSection extends StatelessWidget {
  const VoiceProcessingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceLoggingBloc, VoiceLoggingState>(
      buildWhen: (_, state) {
        return state is VoiceLoggingInitial || state is ListeningUpdateBuilderState ||
            state is ProcessingUpdateBuilderState ||
            state is RecognizeVoiceLogsSuccessState ||
            state is VoiceLogsRecognitionErrorListenerState;
      },
      builder: (context, state) {
        if(state is VoiceLogsRecognitionErrorListenerState){
          return Expanded(child: SizedBox.shrink());
        }

        bool isListening =
            (state is ListeningUpdateBuilderState) ? state.isListening : false;
        bool isProcessing = (state is ProcessingUpdateBuilderState)
            ? state.isProcessing
            : false;
        bool visibleTutorial = (state is RecognizeVoiceLogsSuccessState)
            ? state.data?.isEmpty ?? true
            : true;
        if (isListening) {
          return Expanded(child: const ListeningWaveWidget());
        } else if (isProcessing) {
          return Expanded(child: const GeneratingResultsWidget());
        } else if (visibleTutorial) {
          return Expanded(child: const TutorialWidget());
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
