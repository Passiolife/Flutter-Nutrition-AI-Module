import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/take_photo_result_bloc.dart';
import '../widgets/no_results_found_widget.dart';

class NoResultsFoundSection extends StatelessWidget {
  const NoResultsFoundSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakePhotoResultBloc, TakePhotoResultState>(
      buildWhen: (_, state) {
        return state is ResultFailureState;
      },
      builder: (context, state) {
        if (state is! ResultFailureState) return const SizedBox.shrink();
        return NoResultsFoundWidget();
      },
    );
  }
}
