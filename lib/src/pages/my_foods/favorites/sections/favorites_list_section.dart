import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../common/constant/app_colors.dart';
import '../../../../common/constant/app_padding.dart';
import '../../../../common/dialogs/delete_confirmation_dialog.dart';
import '../../../../common/models/food_record/food_record.dart';
import '../../../../common/util/context_extension.dart';
import '../../../../common/util/snackbar_extension.dart';
import '../../../../common/widgets/food_item_row_widget.dart';
import '../../../edit_food/ui/edit_food_page.dart';
import '../bloc/favorites_bloc.dart';

class FavoritesListSection extends StatelessWidget {
  const FavoritesListSection({required this.list, super.key});

  final List<FoodRecord?> list;

  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: list.length,
        padding: AppPadding.pa16,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final data = list.elementAt(index);
          return FoodItemRowWidget(
            data: FoodItemRowData(
              rippleColor: AppColors.white,
              padding: AppPadding.pa8,
              index: index,
              title: data?.name,
              iconId: data?.iconId,
              subtitle: data?.additionalData,
              onTap: () => _onTap(context: context, foodRecord: data),
              onTapAdd: () => _onTapAdd(context: context, foodRecord: data),
              onTapEdit: () => _onTap(context: context, foodRecord: data),
              onTapDelete: (forced) => _onTapDelete(
                  context: context, foodRecord: data, forced: forced),
            ),
          );
          /* return RowWidget(
                index: index,
                iconId: data?.iconId,
                foodName: data?.name,
                additionalDetails: data?.additionalData,
                listener: this,
              );*/
        },
        separatorBuilder: (BuildContext context, int index) => 8.verticalSpace,
      ),
    );
  }

  void _onTapAdd({required BuildContext context, FoodRecord? foodRecord}) {
    context.read<FavoritesBloc>().add(DoLogEvent(data: foodRecord));
  }

  void _onTap({
    required BuildContext context,
    FoodRecord? foodRecord,
  }) async {
    final data = await EditFoodPage.navigate(
      context: context,
      params: EditFoodPageParams(foodRecord: foodRecord),
    );
    if (data != null && data is bool && data && context.mounted) {
      context.showSnackbar(text: context.localization?.addedToLog);
    }
    context.read<FavoritesBloc>().add(const GetAllFavoritesEvent());
  }

  void _onTapDelete(
      {required BuildContext context,
      required bool forced,
      FoodRecord? foodRecord}) {
    if (forced) {
      _performDelete(context: context, foodRecord: foodRecord);
    } else {
      _showDeleteConfirmationDialog(context: context, foodRecord: foodRecord);
    }
  }

  void _showDeleteConfirmationDialog(
      {required BuildContext context, FoodRecord? foodRecord}) {
    DeleteConfirmationDialog.show(
      context: context,
      onConfirm: () {
        _performDelete(context: context, foodRecord: foodRecord);
      },
    );
  }

  void _performDelete({required BuildContext context, FoodRecord? foodRecord}) {
    // _list.remove(foodRecord);
    context.read<FavoritesBloc>().add(DoFavoriteDeleteEvent(data: foodRecord));
  }
}
