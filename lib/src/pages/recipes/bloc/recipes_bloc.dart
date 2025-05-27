import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/domain/use_cases/passio_connector/fetch_user_recipes_use_case.dart';
import '../../../common/domain/use_cases/use_case.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/util/command.dart';
import '../../../common/util/result.dart';

part 'recipes_event.dart';
part 'recipes_state.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final FetchUserRecipesUseCase _fetchUserRecipesUseCase;

  List<FoodRecord> _userRecipes = [];

  List<FoodRecord> get userRecipes => List.unmodifiable(_userRecipes);

  RecipesBloc({required FetchUserRecipesUseCase fetchUserRecipesUseCase})
      : _fetchUserRecipesUseCase = fetchUserRecipesUseCase,
        super(const InitialState()) {
    on<FetchUserRecipeEvent>(_handleFetchUserRecipeEvent);
    on<FetchUserRecipesSuccessEvent>(_handleFetchUserRecipesSuccessEvent);
    on<FetchUserRecipesErrorEvent>(_handleFetchUserRecipesErrorEvent);

    _loadCommand = Command0(_fetchUserRecipes);
    add(const FetchUserRecipeEvent());
  }

  late Command0 _loadCommand;

  Future<void> _handleFetchUserRecipeEvent(
      FetchUserRecipeEvent event, Emitter<RecipesState> emit) async {
    await _loadCommand.execute();
  }

  Future<Result<List>> _fetchUserRecipes() async {
    try {
      final Result<List<FoodRecord>> result =
          await _fetchUserRecipesUseCase.call(const NoParams());
      switch (result) {
        case Error<List<FoodRecord>>():
          add(FetchUserRecipesErrorEvent(error: result.error.toString()));
          return result;
        case Success<List<FoodRecord>>():
      }
      _userRecipes = result.value;
      add(FetchUserRecipesSuccessEvent(data: userRecipes));
      return result;
    } finally {
      _loadCommand.clearResult();
    }
  }

  Future<void> _handleFetchUserRecipesSuccessEvent(
      FetchUserRecipesSuccessEvent event, Emitter<RecipesState> emit) async {
    emit(FetchUserRecipesSuccessState(recipes: event.data));
  }

  Future<void> _handleFetchUserRecipesErrorEvent(
      FetchUserRecipesErrorEvent event, Emitter<RecipesState> emit) async {
    emit(FetchUserRecipesErrorState(error: event.error));
  }
}
