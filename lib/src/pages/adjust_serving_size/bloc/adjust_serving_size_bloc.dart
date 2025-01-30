import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/models/food_record/food_record.dart';
import '../../../common/util/double_extensions.dart';

part 'adjust_serving_size_event.dart';
part 'adjust_serving_size_state.dart';

class AdjustServingSizeBloc
    extends Bloc<AdjustServingSizeEvent, AdjustServingSizeState> {
  FoodRecord? foodRecord;
  int? _index;
  Uint8List? _image;
  String _iconId = '';
  String _title = '';
  String _subtitle = '';
  bool _isEditable = false;
  double _quantity = 1;
  String _unit = '';
  List<String> _units = [];

  AdjustServingSizeBloc() : super(AdjustServingSizeInitial()) {
    on<ProcessEvent>(_handleProcessEvent);
    on<RefreshDetailsEvent>(_handleRefreshDetailsEvent);
    on<UpdateServingSizeEvent>(_handleUpdateServingSizeEvent);
    on<RefreshServingSizeEvent>(_handleRefreshServingSizeEvent);
  }

  FutureOr<void> _handleProcessEvent(
      ProcessEvent event, Emitter<AdjustServingSizeState> emit) async {
    foodRecord = event.foodRecord?.clone();

    // Details
    _index = event.index;
    _image = event.image;
    _iconId = foodRecord!.iconId;
    _title = foodRecord!.name;
    _subtitle =
        '${foodRecord?.getSelectedQuantity().format()} ${foodRecord?.getSelectedUnit()} (${foodRecord?.computedWeight.value.format()} ${foodRecord?.computedWeight.symbol})';
    _isEditable = foodRecord?.resultType != PassioFoodResultType.foodItem;

    // Serving Size
    _quantity = foodRecord?.getSelectedQuantity() ?? 1;
    _unit = foodRecord?.getSelectedUnit() ?? '';
    _units = foodRecord?.servingUnits.map((e) => e.unitName).toList() ?? [];

    add(const RefreshDetailsEvent());
    add(const RefreshServingSizeEvent());
  }

  FutureOr<void> _handleRefreshDetailsEvent(
      RefreshDetailsEvent event, Emitter<AdjustServingSizeState> emit) async {
    emit(RefreshDetailsState(
      index: _index,
      image: _image,
      iconId: _iconId,
      title: _title,
      subtitle: _subtitle,
      isEditable: _isEditable,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  FutureOr<void> _handleUpdateServingSizeEvent(UpdateServingSizeEvent event,
      Emitter<AdjustServingSizeState> emit) async {
    _quantity = event.quantity;
    _unit = event.unit;

    foodRecord?.setSelectedQuantity(_quantity);
    foodRecord?.setUnitWithQuantityAdjustment(_unit);



    _subtitle =
        '${foodRecord?.getSelectedQuantity().format()} ${foodRecord?.getSelectedUnit()} (${foodRecord?.computedWeight.value.format()} ${foodRecord?.computedWeight.symbol})';

    add(const RefreshDetailsEvent());
  }

  FutureOr<void> _handleRefreshServingSizeEvent(RefreshServingSizeEvent event,
      Emitter<AdjustServingSizeState> emit) async {
    emit(RefreshServingSizeState(
      quantity: _quantity,
      unit: _unit,
      units: _units,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }
}
