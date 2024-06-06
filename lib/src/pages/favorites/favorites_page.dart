import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../common/constant/app_constants.dart';
import '../../common/dialogs/one_button_dialog.dart';
import '../../common/models/food_record/food_record.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/snackbar_extension.dart';
import '../edit_food/edit_food_page.dart';
import 'bloc/favorites_bloc.dart';
import 'widgets/widgets.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  static Future navigate({required BuildContext context}) async {
    return await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const FavoritesPage()));
  }

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> implements RowListener {
  final _bloc = FavoritesBloc();

  List<FoodRecord?> _list = [];

  @override
  void initState() {
    _doFetchFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesBloc, FavoritesState>(
      bloc: _bloc,
      listener: (context, state) {
        _handleStateChanges(context: context, state: state);
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              const FavoriteAppBar(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: SlidableAutoCloseBehavior(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _list.length,
                      padding: EdgeInsets.zero,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = _list.elementAt(index);
                        return RowWidget(
                          index: index,
                          iconId: data?.iconId,
                          foodName: data?.name,
                          additionalDetails: data?.additionalData,
                          listener: this,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          8.verticalSpace,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void onAdd(int index) {
    _bloc.add(DoLogEvent(data: _list.elementAt(index)));
  }

  @override
  Future<void> onEdit(int index) async {
    final data = await EditFoodPage.navigate(
      context: context,
      foodRecord: _list.elementAt(index),
    );
    if (data != null && data is bool && data && mounted) {
      context.showSnackbar(text: context.localization?.addedToLog);
    }
  }

  @override
  void onDelete(int index) {
    final foodRecord = _list.elementAt(index);
    _list.removeAt(index);
    _bloc.add(DoFavoriteDeleteEvent(data: foodRecord));
  }

  void _doFetchFavorites() {
    _bloc.add(const GetAllFavoritesEvent());
  }

  void _handleStateChanges({
    required BuildContext context,
    required FavoritesState state,
  }) {
    if (state is GetAllFavouritesSuccessState) {
      _handleGetAllFavouritesSuccessState(state);
    } else if (state is GetAllFavouritesFailureState) {
      context.showSnackbar(text: state.message);
    }

    // States for [DoFavoriteDeleteEvent]
    else if (state is FavoriteDeleteSuccessState) {
      if (_list.isEmpty) {
        _showNoDataFoundDialog();
      }
    } else if (state is FavoriteDeleteFailureState) {
      context.showSnackbar(text: state.message);
    }
    // States for [DoLogEvent]
    else if (state is FoodRecordLogSuccessState) {
      context.showSnackbar(text: context.localization?.addedToLog);
    } else if (state is FoodRecordLogFailureState) {
      context.showSnackbar(text: state.message);
    }
  }

  void _handleGetAllFavouritesSuccessState(GetAllFavouritesSuccessState state) {
    _list = state.data ?? [];
    if (_list.isEmpty) {
      _showNoDataFoundDialog();
    }
  }

  void _showNoDataFoundDialog() {
    OneButtonDialog.show(
      context: context,
      title: context.localization?.noFavoriteTitle,
      message: context.localization?.noFavoriteDescription,
      buttonText: context.localization?.ok,
      onTap: (c) {
        Navigator.pop(c);
        Navigator.pop(context);
      },
    );
  }
}
