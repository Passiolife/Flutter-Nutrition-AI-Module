import 'package:flutter/material.dart';

class RecipeListSection extends StatelessWidget {
  const RecipeListSection({super.key});

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(),
    );
    // final list = context.watch<RecipesBloc>().userRecipes;
    // return SlidableAutoCloseBehavior(
    //   child: ListView.separated(
    //     shrinkWrap: true,
    //     padding: EdgeInsets.symmetric(vertical: 16.h),
    //     itemCount: list?.length ?? 0,
    //     physics: const ClampingScrollPhysics(),
    //     itemBuilder: (context, index) {
    //       final data = list?.elementAt(index);
    //       if (data == null) return const SizedBox.shrink();
    //       return FoodItemRowWidget(
    //         data: FoodItemRowData(
    //           rippleColor: AppColors.white,
    //           padding: AppPadding.pa8,
    //           index: index,
    //           foodRecord: data,
    //           title: data.name,
    //           iconId: data.iconId,
    //           subtitle: data.additionalData,
    //           onTap: () => _doOpenRecord(context: context, foodRecord: data),
    //           onTapAdd: () => _doLogRecord(context: context, foodRecord: data),
    //           onTapEdit: () =>
    //               _doEditRecord(context: context, foodRecord: data),
    //           onTapDelete: (forced) => _doDeleteRecord(
    //             context: context,
    //             foodRecord: data,
    //             forced: forced,
    //           ),
    //         ),
    //       );
    //     },
    //     separatorBuilder: (BuildContext context, int index) {
    //       return 8.verticalSpace;
    //     },
    //   ),
    // );
  }

// Future<void> _doOpenRecord(
//     {required BuildContext context, required FoodRecord foodRecord}) async {
//   final record = foodRecord.clone();
//   record.refCode = '${FoodRecord.userRecipePrefix}${record.id}';
//   EditFoodPage.navigate(
//     context: context,
//     params: EditFoodPageParams(
//       foodRecord: record,
//       message: context.localization?.itemAddedToDiary,
//       source: AppCommonConstants.userRecipe,
//       visibleRecipeCreator: true,
//       redirectToDiaryOnLog: true,
//     ),
//   );
// }
//
// Future<void> _doLogRecord(
//     {required BuildContext context, required FoodRecord foodRecord}) async {
//   context.read<RecipesBloc>().add(DoFoodLogEvent(foodRecord: foodRecord));
// }
//
// Future<void> _doEditRecord({
//   required BuildContext context,
//   required FoodRecord foodRecord,
// }) async {
//   await RecipeCreatorPage.navigate(
//     context: context,
//     params: RecipeCreatorNavigationData(recipeFoodRecord: foodRecord),
//   );
// }
//
// void _doDeleteRecord({
//   required BuildContext context,
//   required FoodRecord foodRecord,
//   required bool forced,
// }) {
//   if (forced) {
//     context
//         .read<RecipesBloc>()
//         .add(DoDeleteUserRecipeEvent(foodRecord: foodRecord));
//     return;
//   }
//   DeleteConfirmationDialog.show(
//     context: context,
//     onConfirm: () => context
//         .read<RecipesBloc>()
//         .add(DoDeleteUserRecipeEvent(foodRecord: foodRecord)),
//   );
// }
}
