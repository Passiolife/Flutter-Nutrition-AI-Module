// class ResultDialog {
//   ResultDialog.show({
//     required BuildContext context,
//     String? foodName,
//     String? foodSize,
//     String? foodCalories,
//     OnFoodLog? onFoodLog,
//     VoidCallback? onClose,
//   }) {
//     // showCupertinoModalPopup(context: context, builder: builder)
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: AppColors.transparent,
//       barrierColor: AppColors.transparent,
//       enableDrag: false,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return ResultWidget(
//           foodName: foodName,
//           foodSize: foodSize,
//           foodCalories: foodCalories,
//           onFoodLog: onFoodLog,
//         );
//       },
//     );
//   }
// }
