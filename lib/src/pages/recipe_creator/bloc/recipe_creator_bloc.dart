import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/models/food_record/food_record.dart';

part 'recipe_creator_event.dart';
part 'recipe_creator_state.dart';

class RecipeCreatorBloc extends Bloc<RecipeCreatorEvent, RecipeCreatorState> {
  RecipeCreatorBloc() : super(const InitialState()) {
    // on<RecipeCreatorEvent>(_handleRecipeCreatorEvent);
  }
}