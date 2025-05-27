import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/extension/core_extension.dart';
import '../../../common/models/quick_suggestion/quick_suggestion.dart';
import '../../edit_food/ui/edit_food_page.dart';
import '../bloc/quick_suggestion_bloc.dart';
import '../widgets/suggestion_row_widget.dart';

class BodySection extends StatelessWidget {
  const BodySection({this.controller, super.key});

  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuickSuggestionBloc, QuickSuggestionState>(
      buildWhen: (_, state) {
        return state is InitialState || state is FetchSuggestionsSuccessState;
      },
      builder: (context, state) {
        List<QuickSuggestion> data = [];
        bool isAddLoading = false;

        if (state is FetchSuggestionsSuccessState) {
          data = state.data;
        }

        return Expanded(
          child: GridView.builder(
            controller: controller,
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
              bottom: context.bottomPaddingValue + kBottomNavigationBarHeight,
            ),
            itemBuilder: (context, index) {
              final QuickSuggestion suggestion = data.elementAt(index);
              return SuggestionRowWidget(
                suggestion: suggestion,
                isAddLoading: isAddLoading,
                onTap: () => _onTap(context: context, suggestion: suggestion),
                onTapAdd: () => _onTapAdd(
                  context: context,
                  index: index,
                  suggestion: suggestion,
                ),
              );
              // return GestureDetector(
              //   behavior: HitTestBehavior.opaque,
              //   onTap: () =>
              //       _onTapSuggestion(context: context, suggestion: suggestion),
              //   child: Container(
              //     color: AppColors.indigo50,
              //     child: Row(
              //       children: [
              //         8.horizontalSpace,
              //         PassioImageWidget(
              //           key: ValueKey(suggestion.foodRecord?.iconId ??
              //               suggestion.passioFoodDataInfo?.iconID ??
              //               ''),
              //           iconId: suggestion.foodRecord?.iconId ??
              //               suggestion.passioFoodDataInfo?.iconID ??
              //               '',
              //           radius: 16.r,
              //           foodRecord: suggestion.foodRecord,
              //         ),
              //         8.horizontalSpace,
              //         Expanded(
              //           child: Text(
              //             (suggestion.foodRecord?.name ??
              //                     suggestion.passioFoodDataInfo?.foodName ??
              //                     '')
              //                 .toUpperCaseWord,
              //             style: AppTextStyle.textXs
              //                 .addAll([AppTextStyle.semiBold]).copyWith(
              //                     color: AppColors.gray900),
              //             maxLines: 3,
              //             overflow: TextOverflow.ellipsis,
              //           ),
              //         ),
              //         isAddLoading
              //             ? const AppLoadingButtonWidget()
              //             : PlusIconWidget(
              //                 color: AppColors.brandIconLight,
              //                 width: 16.r,
              //                 height: 16.r,
              //                 onTap: () => _onTapAdd(
              //                   context: context,
              //                   suggestion: suggestion,
              //                 ),
              //               ),
              //       ],
              //     ),
              //   ),
              // );
            },
          ),
        );
      },
    );
  }

  Future<void> _onTap({
    required BuildContext context,
    required QuickSuggestion suggestion,
  }) async {
    bool? isLogged = await EditFoodPage.navigate(
      context: context,
      params: EditFoodPageParams(
        passioFoodDataInfo: suggestion.passioFoodDataInfo,
        foodRecord: suggestion.foodRecord,
        visibleFoodCreator: true,
        visibleRecipeCreator: true,
        message: context.localization.itemAddedToDiary,
      ),
    );
    if (isLogged != null && isLogged && context.mounted) {
      context.read<QuickSuggestionBloc>().add(const FetchSuggestionsEvent());
    }
  }

  void _onTapAdd({
    required BuildContext context,
    required int index,
    required QuickSuggestion suggestion,
  }) {
    context
        .read<QuickSuggestionBloc>()
        .add(DoLogEvent(index: index, suggestion: suggestion));

    // context
    //     .read<QuickSuggestionBloc>()
    //     .add(QuickSuggestionEvent.onTapAdd(suggestion));
  }
}
