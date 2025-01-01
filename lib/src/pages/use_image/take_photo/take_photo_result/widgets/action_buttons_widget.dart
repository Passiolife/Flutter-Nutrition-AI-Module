import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/widgets/button/primary_button.dart';
import '../../../../../common/widgets/button/secondary_button.dart';
import '../bloc/take_photo_result_bloc.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({
    this.onTapCreateRecipe,
    this.onTapLogSelected,
    super.key,
  });

  final VoidCallback? onTapCreateRecipe;
  final VoidCallback? onTapLogSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakePhotoResultBloc, TakePhotoResultState>(
        buildWhen: (_, state) {
      return state is TakePhotoResultInitial || state is ResultsSuccessState;
    }, builder: (context, state) {
      if (state is! ResultsSuccessState) return const SizedBox.shrink();
      return Padding(
        padding: AppPadding.pa16,
        child: Row(
          spacing: 16.w,
          children: [
            Expanded(
              child: SecondaryButton(
                padding: AppPadding.pv12,
                onTap: () {},
                text: context.localization.createRecipe,
              ),
            ),
            Expanded(
              child: PrimaryButton(
                padding: AppPadding.pv12,
                onTap: () {},
                text: context.localization.logSelected,
              ),
            ),
          ],
        ),
      );
    });
  }
}
