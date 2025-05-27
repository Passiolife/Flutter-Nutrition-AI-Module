part of '../food_search_page.dart';

class FoodSearchScreen extends StatelessWidget {
  const FoodSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FoodSearchBloc, FoodSearchState>(
      listener: _handleStateChanges,
      child: Scaffold(
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, FoodSearchState state) {
    if (state is FoodLogSuccessState) {
      context.showSnackbar(text: context.localization.itemAddedToDiary);
    }
  }
}
