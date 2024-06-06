import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../nutrition_ai_module.dart';

part 'add_water_event.dart';
part 'add_water_state.dart';

class AddWaterBloc extends Bloc<AddWaterEvent, AddWaterState> {
  final _connector = NutritionAIModule.instance.configuration.connector;

  AddWaterBloc() : super(const AddWaterInitial()) {
    on<SaveWaterEvent>(_handleSaveWaterEvent);
  }

  Future<void> _handleSaveWaterEvent(
      SaveWaterEvent event, Emitter<AddWaterState> emit) async {
    WaterRecord record = WaterRecord(
      id: event.id,
      createdAt: event.createdAt.toUtc().millisecondsSinceEpoch,
    );
    record.setWater(double.parse(event.consumedWater), event.unit);
    await _connector.updateWater(waterRecord: record, isNew: event.isNew);
    emit(SaveSuccessState(record: record));
  }
}
