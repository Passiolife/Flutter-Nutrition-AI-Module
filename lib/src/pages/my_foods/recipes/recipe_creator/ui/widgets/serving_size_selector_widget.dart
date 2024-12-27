import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/constant/app_dimens.dart';
import '../../../../../../common/dialogs/ok_button_with_keyboard.dart';
import '../../../../../../common/models/food_record/food_record.dart';
import '../../../../../../common/util/double_extensions.dart';
import '../../../../../../common/util/keyboard_extension.dart';
import '../../../../../../common/extension/string_extensions.dart';
import '../../../../../../common/widgets/app_drop_down_menu.dart';
import '../../../../../../common/widgets/app_slider.dart';
import '../../../../../../common/widgets/app_text_field.dart';
import '../../bloc/recipe_creator_bloc.dart';
import '../model/recipe_creator_view_model.dart';

class ServingSizeSelectorWidget extends StatefulWidget {
  const ServingSizeSelectorWidget({super.key});

  @override
  State<ServingSizeSelectorWidget> createState() =>
      _ServingSizeSelectorWidgetState();
}

class _ServingSizeSelectorWidgetState extends State<ServingSizeSelectorWidget> {
  final TextEditingController _quantityController = TextEditingController();
  final FocusNode _quantityFocusNode = FocusNode();

  late final RecipeCreatorBloc _bloc = context.read<RecipeCreatorBloc>();

  double? _selectedQuantity;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      OkButtonWithKeyboard.setup(
        context: context,
        focusNode: _quantityFocusNode,
        onTap: _handleOkButtonTap,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RecipeCreatorBloc>().viewModel;

    SliderData sliderData = viewModel.sliderData ?? SliderData();

    FoodRecord? foodRecord = viewModel.foodRecord;
    _selectedQuantity = foodRecord?.getSelectedQuantity();

    List<DropdownMenuEntry<String>> unitEntries = foodRecord?.servingUnits
            .map((e) => DropdownMenuEntry(value: e.unitName, label: e.unitName.toUpperCaseWord))
            .toList() ??
        [];
    final selectedUnit = foodRecord?.getSelectedUnit();

    _quantityController.text = _selectedQuantity?.format(places: 2) ?? '';
    return Column(
      children: [
        Row(
          children: [
            AppTextField(
              width: AppDimens.r64,
              height: AppDimens.h42,
              controller: _quantityController,
              textAlign: TextAlign.center,
              focusNode: _quantityFocusNode,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            8.horizontalSpace,
            Expanded(
              child: AppDropDownMenu<String>(
                dropdownMenuEntries: unitEntries,
                initialSelection: selectedUnit,
                onSelected: _onChangeUnit,
              ),
            ),
          ],
        ),
        16.verticalSpace,
        AppSlider(
          value: _selectedQuantity ?? 1,
          min: sliderData.minSlider,
          max: sliderData.maxSlider,
          divisions: sliderData.divisions,
          onChanged: (value) {
            _bloc.add(DoUpdateQuantityEvent(quantity: value, fromSlider: true));
          },
        ),
      ],
    );
  }

  void _handleOkButtonTap() {
    context.hideKeyboard();
    if (_quantityController.text.isNotEmpty) {
      double quantity = double.parse(_quantityController.text);
      _bloc.add(DoUpdateQuantityEvent(quantity: quantity));
    } else {
      // Restore previous quantity if text field is empty after OK is tapped
      _quantityController.text = _selectedQuantity.format(places: 2);
    }
  }

  void _onChangeUnit(String? value) {
    _bloc.add(DoUpdateUnitEvent(unit: value));
  }
}
