import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../common/models/food_record/food_record.dart';

part 'edit_nutrition_facts_event.dart';
part 'edit_nutrition_facts_state.dart';

class EditNutritionFactsBloc extends Bloc<EditNutritionFactsEvent, EditNutritionFactsState> {
  EditNutritionFactsBloc() : super(EditNutritionFactsInitial()) {
    on<ProcessEvent>(_handleProcessEvent);
  }

  void _handleProcessEvent(ProcessEvent event, Emitter<EditNutritionFactsState> emit) {
    final foodRecord = event.foodRecord;
    final iconId = foodRecord.iconId;
    final barcode = foodRecord.barcode ?? '';
    emit(UpdateDetailsState(iconId: iconId, barcode: barcode));
  }
}
