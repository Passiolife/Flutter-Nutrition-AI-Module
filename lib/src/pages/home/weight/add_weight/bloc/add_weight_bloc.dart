import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../nutrition_ai_module.dart';

part 'add_weight_event.dart';

part 'add_weight_state.dart';

class AddWeightBloc extends Bloc<AddWeightEvent, AddWeightState> {
  final _connector = NutritionAIModule.instance.configuration.connector;

  AddWeightBloc() : super(const AddWaterInitial()) {
    on<SaveWaterEvent>(_handleSaveWaterEvent);
  }

  Future<void> _handleSaveWaterEvent(
      SaveWaterEvent event, Emitter<AddWeightState> emit) async {
    final record = WeightRecord(
      id: event.id,
      createdAt: event.createdAt.toUtc().millisecondsSinceEpoch,
    );
    record.setWeight(double.parse(event.weightMeasurement), unit: event.unit);
    await _connector.updateWeight(record: record, isNew: event.isNew);
    emit(SaveSuccessState(record: record));
  }
}
