import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/quick_suggestion/quick_suggestion.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/app_loading_button_widget.dart';
import '../../../common/widgets/draggable_bottom_sheet_widget.dart';
import '../../../common/widgets/passio_image_widget.dart';

abstract interface class QuickSuggestionsListener {
  void onTap(QuickSuggestion data);

  void onTapAdd(QuickSuggestion data);

  void onDrag(double draggedSize, double draggedPixels);
}

class QuickSuggestionsWidget extends StatelessWidget {
  const QuickSuggestionsWidget({
    this.data = const [],
    this.isAddLoading = false,
    this.listener,
    super.key,
  });

  final List<QuickSuggestion> data;
  final bool isAddLoading;
  final QuickSuggestionsListener? listener;

  double _getInitialSize(BuildContext context) {
    // Define the pixel value you want to convert to initialSize
    final double initialPixelValue = context.bottomPadding +
        kBottomNavigationBarHeight +
        26.r +
        8.h +
        5.h +
        16.h +
        20.h +
        4.h +
        14.h;

    // Get the screen height
    final double screenHeight = MediaQuery.of(context).size.height;

    // Calculate the fraction of the screen height
    return initialPixelValue / screenHeight;
  }

  double get maxSize => 0.6;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: DraggableBottomSheetWidget(
        initialSize: _getInitialSize(context),
        minSize: _getInitialSize(context),
        maxSize: maxSize,
        builder: (context, dragController, scrollController) {
          return Container(
            decoration: AppShadows.base,
            height: context.height,
            child: Column(
              children: [
                SingleChildScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      8.verticalSpace,
                      Container(
                        width: 48.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: AppColors.gray200,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                      16.verticalSpace,
                      Text(
                        context.localization?.quickSuggestions ?? '',
                        style: AppTextStyle.textXl.addAll([
                          AppTextStyle.textXl.leading7,
                          AppTextStyle.bold
                        ]).copyWith(color: AppColors.gray900),
                      ),
                      4.verticalSpace,
                      Text(
                        context.localization?.quickSuggestionsDescription ?? '',
                        style: AppTextStyle.textSm,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.h,
                      childAspectRatio: (1 / .25),
                    ),
                    itemCount: data.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      top: 32.h,
                      left: 8.w,
                      right: 8.w,
                      bottom:
                          context.bottomPadding + kBottomNavigationBarHeight,
                    ),
                    itemBuilder: (context, index) {
                      final suggestion = data.elementAt(index);
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => listener?.onTap(suggestion),
                        child: Container(
                          color: AppColors.indigo50,
                          child: Row(
                            children: [
                              8.horizontalSpace,
                              PassioImageWidget(
                                key: ValueKey(suggestion.foodRecord?.iconId ??
                                    suggestion.passioFoodDataInfo?.iconID ??
                                    ''),
                                iconId: suggestion.foodRecord?.iconId ??
                                    suggestion.passioFoodDataInfo?.iconID ??
                                    '',
                                radius: 16.r,
                              ),
                              8.horizontalSpace,
                              Expanded(
                                child: Text(
                                  (suggestion.foodRecord?.name ??
                                          suggestion
                                              .passioFoodDataInfo?.foodName ??
                                          '')
                                      .toUpperCaseWord,
                                  style: AppTextStyle.textXs
                                      .addAll([AppTextStyle.semiBold]).copyWith(
                                          color: AppColors.gray900),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              isAddLoading
                                  ? const AppLoadingButtonWidget()
                                  : IconButton(
                                      onPressed: () {
                                        listener?.onTapAdd(suggestion);
                                      },
                                      icon: SvgPicture.asset(
                                        AppImages.icPlusSolid,
                                        width: AppDimens.r24,
                                        height: AppDimens.r24,
                                        colorFilter: const ColorFilter.mode(
                                            AppColors.gray400, BlendMode.srcIn),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        dragListener: listener?.onDrag,
      ),
    );
  }
}
