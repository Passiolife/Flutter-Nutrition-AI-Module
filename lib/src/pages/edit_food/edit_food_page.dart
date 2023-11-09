import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../common/constant/app_colors.dart';
import '../../common/constant/app_constants.dart';
import '../../common/constant/dimens.dart';
import '../../common/models/food_record/food_record.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/double_extensions.dart';
import '../../common/util/snackbar_extension.dart';
import '../../common/util/string_extensions.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../common/widgets/custom_button.dart';
import '../../common/widgets/food_details/dialogs/rename_food_dialogs.dart';
import '../../common/widgets/food_details/food_details_widget.dart';
import 'bloc/edit_food_bloc.dart';

class EditFoodPage extends StatefulWidget {
  final FoodRecord? foodRecord;

  /// [index] is item index from list of previous screen.
  final int index;

  /// [dateTime] contains the selected date in the dashboard.
  final DateTime dateTime;

  final bool isFromEdit;
  final bool isFromFavorite;

  const EditFoodPage({
    this.foodRecord,
    required this.dateTime,
    this.index = 0,
    this.isFromEdit = false,
    this.isFromFavorite = false,
    super.key,
  });

  static Future navigate(
    BuildContext context, {
    DateTime? dateTime,
    FoodRecord? foodRecord,
    int index = 0,
    bool isFromEdit = false,
    bool isFromFavorite = false,
  }) async {
    dateTime ??= DateTime.now();
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditFoodPage(
          foodRecord: foodRecord,
          dateTime: dateTime!,
          index: index,
          isFromEdit: isFromEdit,
          isFromFavorite: isFromFavorite,
        ),
      ),
    );
  }

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  /// [_updatedFoodRecord] is clone of [_updatedFoodRecord],
  /// but this object contains the updated changes.
  FoodRecord? _updatedFoodRecord;

  /// below are the tags for the [Hero] widget.
  PassioID get tagPassioId => '${_updatedFoodRecord?.passioID}${widget.index}';

  String get tagName => '${_updatedFoodRecord?.name}${widget.index}';

  String get tagSubtitle => '${AppConstants.subtitle}${widget.index}';

  String get tagCalories => '${context.localization?.calories}${widget.index}';

  String get tagCaloriesData => '${AppConstants.calories}${widget.index}';

  /// Getting food name from the food record.
  String get title => _updatedFoodRecord?.name?.toUpperCaseWord ?? '';

  /// Getting nutrition from the food record.
  String get subTitle => "${(_updatedFoodRecord?.selectedQuantity ?? 1).removeDecimalZeroFormat} ${_updatedFoodRecord?.selectedUnit ?? ""} "
      "(${_updatedFoodRecord?.computedWeight.value.removeDecimalZeroFormat ?? ""} ${_updatedFoodRecord?.computedWeight.symbol ?? ""})";

  /// [_quantityController] is use to update and get the value from quantity text field.
  final TextEditingController _quantityController = TextEditingController();

  /// [_bloc] is use to call the events and emitting the states.
  final _bloc = EditFoodBloc();

  // [isAmountEditable] use in FoodDetailHeader to show the "Edit Amount" button.
  bool isAmountEditable = false;

  // [visibleCloseButton] use in [ServingSizeViewWidget] to show the "Close" button.
  bool visibleCloseButton = false;

  final _foodDetailsKey = GlobalKey<FoodDetailsWidgetState>();

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _bloc,
      listener: (context, state) {
        // states for [DoFavouriteEvent]
        if (state is FavoriteSuccessState) {
          /// Showing success message for saving favorite in DB.
          context.showSnackbar(text: context.localization?.favoriteSuccessMessage);
        } else if (state is FavoriteFailureState) {
          context.showSnackbar(text: state.message);
        } else if (state is FoodUpdateSuccessState) {
          Navigator.pop(context, true);
        } else if (state is FoodUpdateFailureState) {
          context.showSnackbar(text: state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.passioBackgroundWhite,
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
            title: title,
            isBackVisible: true,
            leadingWidth: Dimens.w58,
            backPageName: context.localization?.back ?? '',
            onBackTap: () {
              Navigator.pop(context);
            },
            foregroundColor: AppColors.blackColor,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  key: UniqueKey(),
                  padding: EdgeInsets.zero,
                  children: [
                    FoodDetailsWidget(
                      foodRecord: _updatedFoodRecord,
                      isMealTimeVisible: (!widget.isFromEdit && !widget.isFromFavorite),
                      isIngredientsVisible: (!widget.isFromEdit),
                      key: _foodDetailsKey,
                    ),
                  ],
                ),
              ),
              Dimens.h12.verticalSpace,
              Row(
                children: [
                  Dimens.w4.horizontalSpace,
                  Expanded(
                    child: CustomElevatedButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      text: context.localization?.cancel ?? '',
                    ),
                  ),
                  Dimens.w8.horizontalSpace,
                  (!widget.isFromEdit && !widget.isFromFavorite)
                      ? Expanded(
                          child: CustomElevatedButton(
                            onTap: () {
                              _showFavoriteDialog();
                            },
                            text: context.localization?.favorites ?? '',
                          ),
                        )
                      : const SizedBox.shrink(),
                  Dimens.w8.horizontalSpace,
                  Expanded(
                    child: CustomElevatedButton(
                      onTap: () {
                        _saveFoodRecord();
                      },
                      text: context.localization?.save ?? '',
                    ),
                  ),
                  Dimens.w4.horizontalSpace,
                ],
              ),
              Dimens.h24.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  void _initialize() {
    _updatedFoodRecord = FoodRecord.fromJson(widget.foodRecord?.toJson());
  }

  void _showFavoriteDialog() {
    RenameFoodDialogs.show(
      context: context,
      title: context.localization?.favoriteDialogTitle,
      text: '',
      placeHolder: '${context.localization?.my} ${_updatedFoodRecord?.name}'.toUpperCaseWord,
      onRenameFood: (value) {
        _updatedFoodRecord?.name = value;

        _bloc.add(DoFavouriteEvent(data: _updatedFoodRecord, dateTime: widget.dateTime));
      },
    );
  }

  void _saveFoodRecord() {
    _updatedFoodRecord = _foodDetailsKey.currentState?.updatedFoodRecord;
    // Updating id because [editFoodPage] converts [data] to new object so model class have include false so id will be null.
    _updatedFoodRecord?.id = widget.foodRecord?.id;

    if (widget.isFromEdit) {
      return Navigator.pop(context, _updatedFoodRecord);
    }
    // Firing bloc event to update the food record in local DB.
    _bloc.add(DoFoodUpdateEvent(data: _updatedFoodRecord, isFavorite: widget.isFromFavorite));
  }
}
