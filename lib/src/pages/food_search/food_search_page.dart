import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../common/constant/app_constants.dart';
import '../../common/router/routes.dart';
import '../../common/util/debouncer.dart';
import '../../common/util/snackbar_extension.dart';
import 'bloc/food_search_bloc.dart';
import 'widgets/alternative_list_widget.dart';
import 'widgets/widgets.dart';

class FoodSearchPage extends StatefulWidget {
  const FoodSearchPage({this.needsReturn = true, super.key});

  final bool needsReturn;

  @override
  State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage>
    implements PassioSearchListener {
  final TextEditingController _searchController = TextEditingController();

  final FoodSearchBloc _bloc = FoodSearchBloc();

  List<PassioSearchResult> _results = [];
  List<String> _alternatives = [];

  /// [_searchDeBouncer] when user stops typing then waits [500] milliseconds and do the search operation.
  final _searchDeBouncer = DeBouncer(milliseconds: 500);

  @override
  void initState() {
    _searchController.addListener(() {
      /// Here managing the debounce so it will wait until user stops the typing.
      _searchDeBouncer.run(() {
        _bloc.add(DoFoodSearchEvent(searchText: _searchController.text.trim()));
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FoodSearchBloc, FoodSearchState>(
      bloc: _bloc,
      listener: (context, state) {
        _handleStates(context: context, state: state);
      },
      buildWhen: (_, state) {
        return state is! FetchSearchResultSuccessState &&
            state is! FetchSearchResultFailureState;
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50,
          resizeToAvoidBottomInset: false,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FoodSearchAppBarWidget(searchController: _searchController),
              state is KeepTypingState
                  ? const KeepTypingWidget()
                  : const SizedBox.shrink(),
              SizedBox(height: AppDimens.h12),
              (state is SearchForFoodSuccessState &&
                      state.alternatives.isNotEmpty)
                  ? AlternativeListWidget(
                      alternatives: _alternatives,
                      listener: this,
                    )
                  : const SizedBox.shrink(),
              state is SearchForFoodSuccessState
                  ? ListWidget(
                      results: _results,
                      listener: this,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  @override
  void onFoodItemSelected(PassioSearchResult result) {
    _bloc.add(DoFetchSearchResultEvent(result: result));
  }

  @override
  void onNameSelected(String name) {
    _searchController.text = name;
  }

  void _handleStates(
      {required BuildContext context, required FoodSearchState state}) {
    if (state is SearchForFoodSuccessState) {
      _results = state.results;
      _alternatives = state.alternatives;
    } else if (state is FetchSearchResultSuccessState) {
      final data = state.foodItem;
      if (widget.needsReturn) {
        Navigator.pop(context, data);
      } else {
        Navigator.pushNamed(
          context,
          Routes.editFoodPage,
          arguments: {
            AppCommonConstants.data: state.foodItem,
            AppCommonConstants.iconHeroTag:
                '${state.foodItem.iconId}${state.index}',
            AppCommonConstants.titleHeroTag:
            '${state.foodItem.name}${state.index}',
            AppCommonConstants.subtitleHeroTag:
            '${state.foodItem.details}${state.index}',
          },
        );
      }
    } else if (state is FetchSearchResultFailureState) {
      context.showSnackbar(text: state.message);
    }
  }
}
