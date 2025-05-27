import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/food_creator_bloc.dart';
import '../widgets/action_buttons_widget.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({this.doValidate, super.key});
  final bool Function()? doValidate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodCreatorBloc, FoodCreatorState>(
      buildWhen: (_, state) {
        return state is SaveLoadingState || state is SaveSuccessState || state is SaveErrorState;
      },
      builder: (context, state) {
        return ActionButtonsWidget(
          onCancel: () => _onCancel(context: context),
          onSave: () => _onSave(context: context),
          saveLoading: state is SaveLoadingState,
        );
      },
    );
  }

  void _onCancel({required BuildContext context}) {
    Navigator.pop(context);
  }

  void _onSave({required BuildContext context}) {
    bool validate = doValidate?.call() ?? false;
    if (validate) {
      context.read<FoodCreatorBloc>().add(const SubmitUserCreatedFoodEvent());
    }
  }

}
