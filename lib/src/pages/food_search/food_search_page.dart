import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../common/constant/app_constants.dart';
import '../../common/util/debouncer.dart';
import '../edit_food/edit_food_page.dart';
import 'bloc/food_search_bloc.dart';
import 'widgets/alternative_list_widget.dart';
import 'widgets/widgets.dart';

class FoodSearchPage extends StatefulWidget {
  const FoodSearchPage({this.needsReturn = true, super.key});

  final bool needsReturn;

  // Static method to navigate to the FoodSearchPage.
  static Future navigate(BuildContext context, {bool needsReturn = true}) {
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => FoodSearchPage(needsReturn: needsReturn)),
    );
  }

  @override
  State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage>
    implements PassioSearchListener {
  final TextEditingController _searchController = TextEditingController();

  final FoodSearchBloc _bloc = FoodSearchBloc();

  List<PassioFoodDataInfo> _results = [];
  List<String> _alternatives = [];

  /// [_searchDeBouncer] when user stops typing then waits [500] milliseconds and do the search operation.
  final _searchDeBouncer = DeBouncer(milliseconds: 500);

  final FocusNode _searchNode = FocusNode();

  @override
  void onNameSelected(String name) {
    _searchController.text = name;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _searchNode.requestFocus();
      });
    });
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
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50,
          resizeToAvoidBottomInset: false,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FoodSearchAppBarWidget(
                searchController: _searchController,
                focusNode: _searchNode,
              ),
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
                  ? _alternatives.isNotEmpty || _results.isNotEmpty
                      ? ListWidget(
                          results: _results,
                          listener: this,
                        )
                      : NoDataFoundWidget(
                          searchQuery: _searchController.text,
                        )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  @override
  void onFoodItemSelected(PassioFoodDataInfo result) {
    if (widget.needsReturn) {
      Navigator.pop(context, result);
    } else {
      EditFoodPage.navigate(
          context: context,
          passioFoodDataInfo: result,
          visibleSwitch: true,
          redirectToDiaryOnLog: true);
      /* Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditFoodPage(
            searchResult: result,
            visibleSwitch: true,
            redirectToDiaryOnLog: true,
          ),
        ),
      );*/
    }
  }

  void _handleStates(
      {required BuildContext context, required FoodSearchState state}) {
    if (state is SearchForFoodSuccessState) {
      _results = state.results;
      _alternatives = state.alternatives;
    }
  }
}
