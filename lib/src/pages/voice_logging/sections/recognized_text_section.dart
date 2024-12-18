import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/voice_logging_bloc.dart';
import '../widgets/recognized_text_widget.dart';

class RecognizedTextSection extends StatelessWidget {
  const RecognizedTextSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceLoggingBloc, VoiceLoggingState>(
      buildWhen: (_, state) {
        return state is VoiceLoggingInitial || state is RecognizeBuilderState;
      },
      builder: (context, state) {
        final recognizedWords =
            (state is RecognizeBuilderState) ? state.recognizeWords : '';

        return recognizedWords.isNotEmpty
            ? RecognizedTextWidget(text: recognizedWords)
            : SizedBox.shrink();
      },
    );
  }
}
