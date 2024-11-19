import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'recipe_creator_event.dart';
part 'recipe_creator_state.dart';

class RecipeCreatorBloc extends Bloc<RecipeCreatorEvent, RecipeCreatorState> {
  RecipeCreatorBloc() : super(RecipeCreatorInitial()) {
    on<RecipeCreatorEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
