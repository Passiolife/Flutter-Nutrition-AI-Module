import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../common/constant/app_colors.dart';
import '../../common/constant/dimens.dart';
import '../../common/models/food_record/food_record.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/snackbar_extension.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../edit_food/edit_food_page.dart';
import 'bloc/favourite_bloc.dart';
import 'dialogs/no_favorites_data_dialog.dart';
import 'widgets/favorite_list_row.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  static Future navigate(BuildContext context) async {
    return Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritePage()));
  }

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final _bloc = FavouriteBloc();

  List<FoodRecord?>? _foodRecordList = [];

  // [_hasFoodLogged] flag will update when any food is added to the log. so based on this we will update the log screen.
  bool _hasFoodLogged = false;

  @override
  void initState() {
    super.initState();
    _doFetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _hasFoodLogged);
        return false;
      },
      child: BlocConsumer(
        bloc: _bloc,
        listener: (context, state) {
          if (state is GetAllFavouritesSuccessState) {
            _handleGetAllFavouritesSuccessState(state: state);
          }
          // States for [DoFavoriteDeleteEvent]
          else if (state is FavoriteDeleteFailureState) {
            _handleFavoriteDeleteFailureState(state: state);
          }
          // States for [DoLogEvent]
          else if (state is FoodRecordLogSuccessState) {
            _handleFoodRecordLogSuccessState(state: state);
          } else if (state is FoodRecordLogFailureState) {
            _handleFoodRecordLogFailureState(state: state);
          }

          //
          else if (state is FavoriteDeleteSuccessState) {
            _doFetchFavorites();
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.passioBackgroundWhite,
            appBar: CustomAppBar(
              title: context.localization?.myFavorites ?? '',
              titleColor: AppColors.blackColor,
              isBackVisible: true,
              backPageName: context.localization?.back ?? '',
              backPageNameColor: AppColors.blackColor,
              onBackTap: () {
                Navigator.pop(context, _hasFoodLogged);
              },
              leadingWidth: Dimens.w92,
            ),
            body: SlidableAutoCloseBehavior(
              child: ListView.builder(
                itemCount: _foodRecordList?.length ?? 0,
                itemBuilder: (context, index) {
                  final data = _foodRecordList?.elementAt(index);
                  return FavoriteListRow(
                    key: ValueKey(data?.passioID),
                    index: index,
                    data: data,
                    isAddToLogLoading: (state is FoodRecordLogLoadingState) && state.index == index,
                    onEditItem: _handleOnEditItem,
                    onDeleteItem: _handleOnDeleteItem,
                    onAddToLog: _handleOnAddToLog,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _doFetchFavorites() {
    _bloc.add(GetAllFavoritesEvent());
  }

  void _handleGetAllFavouritesSuccessState({required GetAllFavouritesSuccessState state}) {
    _foodRecordList = state.data;
    if (_foodRecordList?.isEmpty ?? true) {
      _showNoDataFoundDialog();
    }
  }

  Future<void> _handleOnEditItem(int index, FoodRecord? data) async {
    // Opening edit food page and awaiting for the result from edit page based on user action if action is save or favourite then perform action.
    bool? result = await EditFoodPage.navigate(context, foodRecord: data, isFromFavorite: true);

    // Checking result is null or not.
    if (result != null && result) {
      _doFetchFavorites();
    }
  }

  /// Favorite Delete Flow.
  void _handleOnDeleteItem(int index, FoodRecord? data) {
    _foodRecordList?.removeAt(index);
    _bloc.add(DoFavoriteDeleteEvent(data: data));
  }

  void _handleFavoriteDeleteFailureState({required FavoriteDeleteFailureState state}) {
    context.showSnackbar(text: state.message);
  }

  /// END: Favorite Delete Flow.

  void _showNoDataFoundDialog() {
    // Here if no any data in screen then pop then show the dialog
    NoFavoritesDataDialog.show(
      context: context,
      onTapPositive: () {
        Navigator.pop(context);
      },
    );
  }

  /// Add Log Flow.
  void _handleOnAddToLog(int index, FoodRecord? data) {
    _hasFoodLogged = true;
    _bloc.add(DoLogEvent(data: data, index: index));
  }

  void _handleFoodRecordLogFailureState({required FoodRecordLogFailureState state}) {
    context.showSnackbar(text: state.message);
  }

  void _handleFoodRecordLogSuccessState({required FoodRecordLogSuccessState state}) {
    context.showSnackbar(text: context.localization?.logSuccessMessage);
  }
}
