import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'typedefs.dart';

import '../constant/app_constants.dart';
import '../util/date_time_utility.dart';

abstract interface class RangeDateListener {
  void onPreviousTapped();

  void onNextTapped();
}

class RangeDateNavigatorWidget extends StatelessWidget {
  const RangeDateNavigatorWidget({
    required this.startDateTime,
    required this.endDateTime,
    this.listener,
    this.previousEnabled = true,
    this.nextEnabled = true,
    this.isMonthRange = false,
    super.key,
  });

  final DateTime startDateTime;
  final DateTime endDateTime;
  final bool previousEnabled;
  final bool nextEnabled;
  final RangeDateListener? listener;
  final bool isMonthRange;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: AppDimens.r12,
          visualDensity: VisualDensity.compact,
          onPressed: previousEnabled
              ? () {
                  listener?.onPreviousTapped();
                }
              : null,
          icon: SvgPicture.asset(
            AppImages.icChevronLeft,
            width: AppDimens.r24,
            height: AppDimens.r24,
            colorFilter:
                const ColorFilter.mode(AppColors.gray400, BlendMode.srcIn),
          ),
          disabledColor: AppColors.gray200,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
          child: Text(
            startDateTime.rangeString(isMonthRange: isMonthRange, endDateTime: endDateTime),
            style: AppTextStyle.textSm.addAll(
              [AppTextStyle.textSm.leading5, AppTextStyle.semiBold],
            ),
          ),
        ),
        IconButton(
          iconSize: AppDimens.r12,
          visualDensity: VisualDensity.compact,
          onPressed: nextEnabled
              ? () {
                  listener?.onNextTapped();
                }
              : null,
          icon: SvgPicture.asset(
            AppImages.icChevronRight,
            width: AppDimens.r24,
            height: AppDimens.r24,
            colorFilter:
                const ColorFilter.mode(AppColors.gray400, BlendMode.srcIn),
          ),
          disabledColor: AppColors.gray200,
        ),
      ],
    );
  }
}

// class RangeDateNavigatorWidgetNew extends StatelessWidget {
//   RangeDateNavigatorWidgetNew({
//     required this.startDateTime,
//     required this.endDateTime,
//     this.listener,
//     this.previousEnabled = true,
//     this.nextEnabled = true,
//     this.isMonthRange = false,
//     super.key,
//   });
//
//   final DateTime startDateTime;
//   final DateTime endDateTime;
//   final bool previousEnabled;
//   final bool nextEnabled;
//   final RangeDateListener? listener;
//   final bool isMonthRange;
//
//   final ValueNotifier<RangeDates?> _notifier = ValueNotifier(null);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           iconSize: AppDimens.r12,
//           visualDensity: VisualDensity.compact,
//           onPressed: previousEnabled
//               ? () {
//             listener?.onPreviousTapped();
//           }
//               : null,
//           icon: SvgPicture.asset(
//             AppImages.icChevronLeft,
//             width: AppDimens.r24,
//             height: AppDimens.r24,
//             colorFilter:
//             const ColorFilter.mode(AppColors.gray400, BlendMode.srcIn),
//           ),
//           disabledColor: AppColors.gray200,
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
//           child: ValueListenableBuilder(
//             valueListenable: _notifier,
//             builder: (context, value, child) {
//               return Text(
//                 startDateTime.rangeString(isMonthRange: isMonthRange, endDateTime: endDateTime),
//                 style: AppTextStyle.textSm.addAll(
//                   [AppTextStyle.textSm.leading5, AppTextStyle.semiBold],
//                 ),
//               );
//             }
//           ),
//         ),
//         IconButton(
//           iconSize: AppDimens.r12,
//           visualDensity: VisualDensity.compact,
//           onPressed: nextEnabled
//               ? () {
//             listener?.onNextTapped();
//           }
//               : null,
//           icon: SvgPicture.asset(
//             AppImages.icChevronRight,
//             width: AppDimens.r24,
//             height: AppDimens.r24,
//             colorFilter:
//             const ColorFilter.mode(AppColors.gray400, BlendMode.srcIn),
//           ),
//           disabledColor: AppColors.gray200,
//         ),
//       ],
//     );
//   }
//
// }