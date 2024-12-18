part of '../food_search_page.dart';

class FoodSearchScreen extends StatelessWidget {
  const FoodSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const SearchAppBarSection(),
          const KeepTypingSection(),
          Expanded(
            child: SingleChildScrollView(
              padding: AppPadding.pv16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AlternativeSection(),
                  const MyFoodsSection(),
                  SizedBox(height: AppDimens.h16),
                  const SearchResultSection(),

                  /*FoodSearchAppBarWidget(
                    searchController: _searchController,
                    focusNode: _searchNode,
                  ),
                  state is KeepTypingState
                      ? const KeepTypingWidget()
                      : const SizedBox.shrink(),
                  SizedBox(height: AppDimens.h12),
                  (state is SearchForFoodSuccessState &&
                      state.alternatives.isNotEmpty)
                      ? AlternativeListWidget(
                    alternatives: _alternatives,
                    listener: this,
                  )
                      : const SizedBox.shrink(),
                  state is SearchForFoodSuccessState
                      ? _alternatives.isNotEmpty || _results.isNotEmpty
                      ? ListWidget(
                    results: _results,
                    listener: this,
                  )
                      : NoDataFoundWidget(
                    searchQuery: _searchController.text,
                  )
                      : const SizedBox.shrink(),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
