import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/core_extension.dart';
import '../../../common/router/routes.dart';
import '../../../common/widgets/button/primary_button.dart';
import '../bloc/custom_foods_bloc.dart';

class CustomFoodsCreateNewSection extends StatelessWidget {
  const CustomFoodsCreateNewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: context.localization.createNewFood,
      onTap: () => _doCreateNewFood(context: context),
      margin: AppPadding.ph16,
    );
  }

  Future<void> _doCreateNewFood({required BuildContext context}) async {
    bool? hasChanges = await Navigator.pushNamed<bool>(context, Routes.foodCreator);
    if(hasChanges == true && context.mounted) {
      context.read<CustomFoodsBloc>().add(const FetchUserFoodsEvent());
    }
  }
}
