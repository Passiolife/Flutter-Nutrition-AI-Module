import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/food_record/food_record_ingredient.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/passio_image_widget.dart';
import 'interfaces.dart';

class IngredientWidget extends StatefulWidget {
  const IngredientWidget({
    this.ingredients = const [],
    this.listener,
    super.key,
  });

  final List<FoodRecordIngredient> ingredients;
  final EditFoodListener? listener;

  @override
  State<IngredientWidget> createState() => _IngredientWidgetState();
}

class _IngredientWidgetState extends State<IngredientWidget> {
  final TextEditingController _controller = TextEditingController();
  List<String> list = ['', '', ''];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: AppShadows.base,
          child: Column(
            children: [
              // Add Ingredient View
              InkWell(
                onTap: () => widget.listener?.onAddIngredient(),
                splashColor: AppColors.blue50,
                highlightColor: AppColors.blue50,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimens.r16,
                    horizontal: AppDimens.w8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.localization?.addIngredient ?? '',
                          style: AppTextStyle.textBase.addAll([
                            AppTextStyle.textBase.leading6,
                            AppTextStyle.semiBold
                          ]).copyWith(color: AppColors.gray900),
                        ),
                      ),
                      SvgPicture.asset(
                        AppImages.icPlusSolid,
                        width: AppDimens.r24,
                        height: AppDimens.r24,
                        colorFilter: const ColorFilter.mode(
                          AppColors.gray400,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Ingredients List
              if (widget.ingredients.length > 1)
                Column(
                  children: [
                    const Divider(color: AppColors.gray200),
                    SlidableAutoCloseBehavior(
                      child: ListView.builder(
                        itemCount: widget.ingredients.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          bottom:
                              widget.ingredients.isNotEmpty ? AppDimens.h8 : 0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final data = widget.ingredients.elementAt(index);
                          return _IngredientRow(
                            ingredient: data,
                            onTap: () => widget.listener?.onTapIngredient(data),
                            onTapDelete: () => widget.listener?.onDeleteIngredient(data),
                          );
                        },
                      ),
                    ),
                  ],
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.ingredient,
    this.onTap,
    this.onTapDelete,
  });

  final FoodRecordIngredient ingredient;
  final VoidCallback? onTap;
  final VoidCallback? onTapDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        extentRatio: 0.6,
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => onTapDelete?.call(),
        ),
        children: [
          SlidableAction(
            onPressed: (context) => onTap?.call(),
            backgroundColor: AppColors.indigo600Main,
            foregroundColor: Colors.white,
            label: context.localization?.edit ?? '',
          ),
          SlidableAction(
            onPressed: (context) => onTapDelete?.call(),
            backgroundColor: AppColors.red500,
            foregroundColor: Colors.white,
            label: context.localization?.delete ?? '',
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.symmetric(
          vertical: AppDimens.h8,
          horizontal: AppDimens.w8,
        ),
        leading: PassioImageWidget(
          iconId: ingredient.iconId,
          radius: AppDimens.r20,
        ),
        title: Text(
          ingredient.name.toUpperCaseWord,
          style: AppTextStyle.textSm
              .addAll([AppTextStyle.textSm.leading5, AppTextStyle.semiBold]),
        ),
        subtitle: Text(
          '${ingredient.selectedQuantity} ${ingredient.selectedUnit.toUpperCaseWord} (${ingredient.computedWeight.value.formatNumber(places: 0)} ${ingredient.computedWeight.symbol})',
          style: AppTextStyle.textSm.addAll([AppTextStyle.textSm.leading5]),
        ),
        trailing: Text(
          '${ingredient.nutrientsSelectedSize().calories?.value.round()} cal',
          style: AppTextStyle.textSm.addAll([AppTextStyle.textSm.leading5]),
        ),
      ),
    );
  }
}
