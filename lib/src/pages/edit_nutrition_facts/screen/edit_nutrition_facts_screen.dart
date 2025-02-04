part of '../edit_nutrition_facts_page.dart';

class _EditNutritionFactsScreen extends StatefulWidget {
  const _EditNutritionFactsScreen();

  @override
  State<_EditNutritionFactsScreen> createState() =>
      _EditNutritionFactsScreenState();
}

class _EditNutritionFactsScreenState extends State<_EditNutritionFactsScreen> {
  final _formKey = GlobalKey<FormState>();

  late final _bloc = context.read<EditNutritionFactsBloc>();

  late final _navigationData =
      EditNutritionFactsNavigationDataProvider.of(context);

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _bloc.add(ProcessEvent(
        foodRecord: _navigationData.foodRecord,
        imageBytes: _navigationData.imageBytes,
        barcode: _navigationData.barcode,
      ));
      if(_navigationData.initialValidate) {
        _formKey.currentState?.validate();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditNutritionFactsBloc, EditNutritionFactsState>(
      listener: _handleStateChanges,
      child: Center(
        child: Material(
          color: AppColors.transparent,
          child: Wrap(
            children: [
              Container(
                decoration: AppShadows.base,
                padding: AppPadding.pa16,
                margin: AppPadding.pa16 + context.keyboardHeight,
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 16.h,
                    children: [
                      const HeaderSection(),
                      const DetailsSection(),
                      const NutritionFactsSection(),
                      const PortionSection(),
                      ActionButtonsSection(
                        onNegativeTap: _navigationData.onNegativeButtonTap,
                        positiveButtonText: _navigationData.positiveButtonText,
                        onPositiveTap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            context
                                .read<EditNutritionFactsBloc>()
                                .add(SaveEvent(shouldLog: _navigationData.shouldLog));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleStateChanges(
      BuildContext context, EditNutritionFactsState state) {
    if (state is SaveSuccessState) {
      _handleSaveSuccessState(context: context, foodRecord: state.foodRecord);
    }
  }

  void _handleSaveSuccessState({required BuildContext context, FoodRecord? foodRecord}) {
    Navigator.pop(context, foodRecord);

    /*if(_navigationData.shouldReturnOnSave){
      Navigator.pop(context, foodRecord);
      return;
    }
    _showItemAddedToDiary(context);*/
  }

  // void _showItemAddedToDiary(BuildContext context) {
  //   ShowWidgetUtil.showCustomGeneralDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (dContext) {
  //       return ItemAddedToDiaryWidget(
  //         positiveText: context.localization.addMore.toUpperCaseWord,
  //         onTapNegative: () {
  //           Navigator.pushNamedAndRemoveUntil(
  //             context,
  //             Routes.dashboard,
  //             (route) => route.isFirst,
  //             arguments: 1,
  //           );
  //         },
  //         onTapPositive: () {
  //           Navigator.popUntil(
  //               context, (route) => route.settings.name == Routes.foodScan);
  //         },
  //       );
  //     },
  //   );
  // }
}
