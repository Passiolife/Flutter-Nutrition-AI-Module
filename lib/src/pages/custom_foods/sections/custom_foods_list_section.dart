import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../common/dialogs/delete_confirmation_dialog.dart';
import '../../../common/extension/core_extension.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/router/routes.dart';
import '../../../common/widgets/passio/food_item_row/primary_food_item_row.dart';
import '../bloc/custom_foods_bloc.dart';
import '../widgets/custom_foods_row_widget.dart';

class CustomFoodsSection extends StatelessWidget {
  const CustomFoodsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomFoodsBloc, CustomFoodsState>(
      buildWhen: (_, state) {
        return state is FetchSuccessState;
      },
      builder: (context, state) {
        final List<FoodRecord> customFoods =
            context.read<CustomFoodsBloc>().customFoods;
        return SlidableAutoCloseBehavior(
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            itemCount: customFoods.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final data = customFoods.elementAt(index);
              return PrimaryFoodItemRow(
                iconId: data.iconId,
                title: data.name,
                subtitle: data.additionalData ?? '',
                index: index,
                onTap: () => _handleOnTap(context: context, index: index, data: data),
                onTapAdd: () => _handleOnTapAdd(context: context, data: data),
                onTapEdit: () => _handleOnEdit(context: context, index: index, data: data),
                onTapDelete: (forced) => _handleOnDelete(
                  context: context,
                  data: data,
                  forced: forced,
                  index: index,
                ),
              );
              return CustomFoodsRowWidget(
                index: index,
                name: data.name,
                additionalData: data.additionalData,
                iconId: data.iconId,
                onTap: () => _handleOnTap(context: context, index: index, data: data),
                onTapAdd: () => _handleOnTapAdd(context: context, data: data),
                onEdit: () => _handleOnEdit(context: context, index: index, data: data),
                onDelete: (forced) => _handleOnDelete(
                  context: context,
                  data: data,
                  forced: forced,
                  index: index,
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return 8.verticalSpace;
            },
          ),
        );
      },
    );
  }

  void _handleOnTap({
    required BuildContext context,
    required int index,
    required FoodRecord data,
  }) {
    _handleOnEdit(
      context: context,
      index: index,
      data: data,
    );
  }

  void _handleOnTapAdd({
    required BuildContext context,
    required FoodRecord data,
  }) {

  }

  Future<void> _handleOnEdit({
    required BuildContext context,
    required int index,
    required FoodRecord data,
  }) async {
    final bool? update = await Navigator.pushNamed(
      context,
      Routes.foodCreator,
      arguments: [index, data],
    );
    update.let((value) {
      if (value) {
        context.read<CustomFoodsBloc>().add(const FetchUserFoodsEvent());
      }
    });
  }

  void _handleOnDelete({
    required BuildContext context,
    required int index,
    required FoodRecord data,
    required bool forced,
  }) {
    if (forced) {
      _doDelete(context: context, data: data, index: index);
    } else {
      DeleteConfirmationDialog.show(
        context: context,
        onConfirm: () {
          _doDelete(context: context, data: data, index: index);
        },
      );
    }
  }

  void _doDelete({
    required BuildContext context,
    required FoodRecord data,
    required int index,
  }) {
    context.read<CustomFoodsBloc>().add(DeleteFoodEvent(index: index));
  }
}
