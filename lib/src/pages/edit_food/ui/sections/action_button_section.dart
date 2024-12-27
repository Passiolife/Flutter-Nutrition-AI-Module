import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../nutrition_ai_module.dart';
import '../../../../common/constant/app_constants.dart';
import '../../../../common/dialogs/delete_confirmation_dialog.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/widgets/app_button.dart';
import '../../bloc/edit_food_bloc.dart';

class ActionButtonSection extends StatelessWidget {
  const ActionButtonSection({
    this.positiveButtonText,
    this.visibleDelete = false,
    this.isUpdate = false,
    required this.needsReturn,
    this.foodRecord,
    required this.entityTypeName,
    super.key,
  });

  final String? positiveButtonText;
  final bool visibleDelete;
  final bool isUpdate;
  // final ActionButtonsHandler? handler;
  final bool needsReturn;
  final FoodRecord? foodRecord;
  final String entityTypeName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              buttonText: context.localization?.cancel,
              appButtonModel: AppButtonStyles.primaryBordered,
              onTap: () => onCancelTapped(context),
            ),
          ),
          if (visibleDelete)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: AppDimens.w16),
                child: AppButton(
                  buttonText: context.localization?.delete,
                  appButtonModel: AppButtonStyles.delete,
                  onTap: () => onDeleteTapped(context),
                ),
              ),
            ),
          SizedBox(width: AppDimens.w16),
          Expanded(
            child: AppButton(
              buttonText: positiveButtonText ??
                  (isUpdate
                      ? context.localization?.save
                      : context.localization?.log),
              appButtonModel: AppButtonStyles.primary,
              onTap: () => onLogTapped(context),
            ),
          ),
        ],
      ),
    );
  }

  void onCancelTapped(BuildContext context) {
    Navigator.pop(context);
  }

  void onDeleteTapped(BuildContext context) {
    DeleteConfirmationDialog.show(
      context: context,
      onConfirm: () {
        context.read<EditFoodBloc>().add(const DoDeleteLogEvent());
      },
    );
  }

  void onLogTapped(BuildContext context) {
    final bloc = context.read<EditFoodBloc>();
    if (needsReturn) {
      Navigator.pop(context, foodRecord);
    } else {
      bloc.add(DoLogEvent(isUpdate: isUpdate));
    }
  }
}
