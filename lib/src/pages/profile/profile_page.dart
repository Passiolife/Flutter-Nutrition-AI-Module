import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/constant/app_colors.dart';
import '../../common/constant/app_images.dart';
import '../../common/constant/dimens.dart';
import '../../common/constant/styles.dart';
import '../../common/models/macro/macros_model.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/string_extensions.dart';
import '../../common/util/user_session.dart';
import '../../common/widgets/custom_app_bar.dart';
import 'bloc/profile_bloc.dart';
import 'dialogs/daily_macro_dialog.dart';
import 'dialogs/height_dialog.dart';
import 'enums/profile_enums.dart';
import 'widgets/edit_macros_widget.dart';
import 'widgets/edit_picker_widget.dart';
import 'widgets/edit_switch_widget.dart';
import 'widgets/edit_text_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static Future navigate(BuildContext context) async {
    return Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
  }

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // [ProfileBloc] for [ProfilePage].
  final _bloc = ProfileBloc();

  final _userProfile = UserSession.instance.userProfile;

  /// [_weightController] is use to get/set the value of weight.
  final _weightController = TextEditingController();

  // [_selectedHeightUnit] contains the value of [m] or [ft] based on selected unit
  String get _selectedHeightUnit => (_userProfile?.units.name == Units.metric.name) ? context.localization?.m ?? '' : context.localization?.ft ?? '';

  String get _selectedWeightUnit =>
      '${context.localization?.weight} (${(_userProfile?.units.name == Units.metric.name) ? context.localization?.kg : context.localization?.lb})';

  /// [_dailyCaloriesController] is use to get/set the value of calories.
  final _dailyCaloriesController = TextEditingController();

  // [_feetController] is use to set the initialItem in feet [CupertinoPicker] for the height.
  FixedExtentScrollController get _meterController => FixedExtentScrollController(
      initialItem: (_userProfile?.units.name.toLowerCase() == Units.metric.name.toLowerCase()
              ? _userProfile?.heightInitialValueForPicker.meter
              : _userProfile?.heightInitialValueForPicker.feet) ??
          0);

  // [inchController] is use to set the initialItem in inch [CupertinoPicker] for the height.
  FixedExtentScrollController get _centimeterController => FixedExtentScrollController(
      initialItem: (_userProfile?.units.name.toLowerCase() == Units.metric.name.toLowerCase()
              ? _userProfile?.heightInitialValueForPicker.centimeter
              : _userProfile?.heightInitialValueForPicker.inches) ??
          0);

  final macroData = List.generate(101, (index) => index);

  // [_carbsController] is use to set the initialItem in carbs [CupertinoPicker] for the Macro Targets.
  FixedExtentScrollController get _carbsController =>
      FixedExtentScrollController(initialItem: macroData.indexWhere((element) => element == _userProfile?.carbsPercent));

  FixedExtentScrollController get _proteinController =>
      FixedExtentScrollController(initialItem: macroData.indexWhere((element) => element == _userProfile?.proteinPercent));

  FixedExtentScrollController get _fatController =>
      FixedExtentScrollController(initialItem: macroData.indexWhere((element) => element == _userProfile?.fatPercent));

  /// [_gender] contains the list of gender data.
  List<String> get _gender => [
        context.localization?.female.toUpperCaseWord ?? '',
        context.localization?.male.toUpperCaseWord ?? '',
        context.localization?.other.toUpperCaseWord ?? '',
      ];

  /// [_units] contains the list of unit data.
  List<String> get _units => [
        context.localization?.imperial.toUpperCaseWord ?? '',
        context.localization?.metric.toUpperCaseWord ?? '',
      ];

  @override
  void didChangeDependencies() {
    _handleUnitsUpdateSuccessState();
    _dailyCaloriesController.text = _userProfile?.caloriesTarget.toString() ?? context.localization?.typeIn ?? '';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _bloc.add(DoSaveProfileEvent(userProfile: _userProfile));
        return true;
      },
      child: BlocConsumer(
        bloc: _bloc,
        listener: (context, state) {
          // State for [DoWeightUpdateEvent].
          if (state is WeightUpdateSuccessState) {
            _handleWeightUpdateSuccessState();
          }
          // State for [DoCaloriesUpdateEvent]
          else if (state is CaloriesUpdateSuccessState) {
            _handleCaloriesUpdateSuccessState();
          }
          // State for [DoUnitsUpdateEvent]
          else if (state is UnitsUpdateSuccessState) {
            _handleUnitsUpdateSuccessState();
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.passioBackgroundWhite,
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
              leading: FittedBox(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _bloc.add(DoSaveProfileEvent(userProfile: _userProfile));
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(Dimens.r8),
                    child: Image.asset(
                      AppImages.icCancelCircle,
                      width: Dimens.r16,
                      height: Dimens.r16,
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Dimens.h28.verticalSpace,
                  Center(
                    child: Text(
                      context.localization?.yourProfile ?? '',
                      style: AppStyles.style22,
                    ),
                  ),
                  Dimens.h20.verticalSpace,
                  const Divider(),
                  EditTextWidget(
                    title: _selectedWeightUnit,
                    controller: _weightController,
                    onChangeCalories: _onChangeWeight,
                  ),
                  const Divider(),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _showHeightDialog,
                    child: EditPickerWidget(
                      title: '${context.localization?.height} ($_selectedHeightUnit) ',
                      selectedValue: _userProfile?.heightDescription ?? context.localization?.select,
                    ),
                  ),
                  const Divider(),
                  EditTextWidget(
                    title: context.localization?.dailyCalories,
                    controller: _dailyCaloriesController,
                    removeValueOnFocus: false,
                    onChangeCalories: _onChangeCalories,
                  ),
                  const Divider(),
                  EditMacrosWidget(
                    onTapDailyMacro: _showDailyMacroDialog,
                    userProfileModel: _userProfile,
                  ),
                  const Divider(),
                  EditSwitchWidget(
                    items: _gender,
                    title: context.localization?.gender.toUpperCaseWord,
                    selected: _userProfile?.gender?.name,
                    onChangeSegment: _onChangeGender,
                  ),
                  const Divider(),
                  EditSwitchWidget(
                    items: _units,
                    title: context.localization?.units.toUpperCaseWord,
                    selected: _userProfile?.units.name,
                    onChangeSegment: _onChangeUnit,
                  ),
                  const Divider(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Weight related functions.
  void _onChangeWeight(double value) {
    _bloc.add(DoWeightUpdateEvent(data: value));
  }

  void _handleWeightUpdateSuccessState() {
    _weightController.text = _userProfile?.weightDescription ?? '';
  }

  // END: Weight

  // Height related functions
  void _showHeightDialog() {
    HeightDialog.show(
      context: context,
      title: '${context.localization?.height ?? ''} $_selectedHeightUnit',
      meterController: _meterController,
      centimeterController: _centimeterController,
      meter: _userProfile?.units.name.toLowerCase() == Units.metric.name.toLowerCase()
          ? _userProfile?.heightArrayForPicker.meter
          : _userProfile?.heightArrayForPicker.feet,
      centimeter: _userProfile?.units.name.toLowerCase() == Units.metric.name.toLowerCase()
          ? _userProfile?.heightArrayForPicker.centimeter
          : _userProfile?.heightArrayForPicker.inches,
      onSaveHeight: (meter, centimeter) {
        _bloc.add(DoHeightUpdateEvent(valueOne: meter, valueTwo: centimeter));
      },
    );
  }

  // END: Height

  // Calories related functions
  void _onChangeCalories(double calories) {
    _bloc.add(DoCaloriesUpdateEvent(data: calories));
  }

  void _handleCaloriesUpdateSuccessState() {
    _dailyCaloriesController.text = _userProfile?.caloriesTarget.toString() ?? '';
  }

  // END: Calories

  // Macros related functions
  void _showDailyMacroDialog() {
    final macros = Macros(
      caloriesTarget: _userProfile?.caloriesTarget ?? 0,
      carbsPercent: _userProfile?.carbsPercent ?? 0,
      proteinPercent: _userProfile?.proteinPercent ?? 0,
      fatPercent: _userProfile?.fatPercent ?? 0,
    );
    DailyMacroDialog.show(
      context: context,
      carbs: macroData,
      proteins: List.generate(101, (index) => index),
      fats: List.generate(101, (index) => index),
      macros: macros,
      carbsController: _carbsController,
      proteinsController: _proteinController,
      fatsController: _fatController,
      onSaveMacroTarget: () {
        _bloc.add(DoMacroUpdateEvent(carbsPercent: macros.carbsPercent, proteinPercent: macros.proteinPercent, fatPercent: macros.fatPercent));
      },
    );
  }

  // END: Macros

  // Gender related functions
  void _onChangeGender(String? gender) {
    _bloc.add(DoGenderUpdateEvent(data: gender));
  }

  // END: Gender

  // Gender related functions
  void _onChangeUnit(String? unit) {
    _bloc.add(DoUnitsUpdateEvent(data: unit));
  }

  void _handleUnitsUpdateSuccessState() {
    _weightController.text = _userProfile?.weightDescription ?? context.localization?.typeIn ?? '';
  }

// END: Gender
}
