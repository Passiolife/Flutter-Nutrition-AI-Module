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

  late final _navigationData = EditNutritionFactsNavigationDataProvider.of(context);

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _bloc.add(ProcessEvent(
        foodRecord: _navigationData.foodRecord,
        imageBytes: _navigationData.imageBytes,
        barcode: _navigationData.barcode,
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                    Text(
                      context.localization.editNutritionFacts ?? '',
                      style: AppTextStyle.textXl.addAll([
                        AppTextStyle.textXl.leading7,
                        AppTextStyle.bold,
                      ]),
                    ),
                    const DetailsSection(),
                    const NutritionFactsSection(),
                    const PortionSection(),
                    ActionButtonsWidget(
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onSave: () {
                        if(_formKey.currentState?.validate() ?? false) {
                          context.read<EditNutritionFactsBloc>().add(const SaveEvent());
                        }
                      },
                    ),
                    /*_DetailsWidget(
                      index: widget.index,
                      foodRecord: _foodRecord,
                      onChange: (name, barcode) {
                        _name = name;
                        _barcode = barcode;
                      },
                    ),*/
                    /*_NutritionFactsWidget(
                      index: widget.index,
                      foodRecord: _foodRecord,
                      onChange: (calories, carbs, protein, fat) {
                        _calories = calories;
                        _carbs = carbs;
                        _protein = protein;
                        _fat = fat;
                      },
                    ),
                    _PortionsWidget(
                      foodRecord: _foodRecord,
                      onChange: (serving, weight, unit) {
                        _quantity = serving;
                        _weight = weight;
                        _unit = unit;
                      },
                    ),
                    _ActionButtons(
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onNext: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          Navigator.pop(context, toFoodRecord());
                          // Navigator.pop(context, toFoodRecord(_name, quantity, unit, weight, calories, carbs, protein, fat, barcode));
                        }
                      },
                    ),*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
