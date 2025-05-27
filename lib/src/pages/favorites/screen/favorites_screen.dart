part of '../favorites_page.dart';

class _FavoritesScreen extends StatefulWidget {
  const _FavoritesScreen();

  @override
  State<_FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<_FavoritesScreen> {
  late final FavoritesBloc _bloc = context.read<FavoritesBloc>();

  List<FoodRecord?> _list = [];

  @override
  void initState() {
    _doFetchFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        _handleStateChanges(context: context, state: state);
      },
      builder: (context, state) {
        if(_list.isEmpty) {
          return const NoDataSection();
        }
        return FavoritesListSection(list: _list);
      },
    );
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
    else if (state is FavoriteDeleteFailureState) {
      context.showSnackbar(text: state.message);
    }
    // States for [DoLogEvent]
    else if (state is FoodRecordLogSuccessState) {
      context.showSnackbar(text: context.localization?.itemAddedToDiary);
    } else if (state is FoodRecordLogFailureState) {
      context.showSnackbar(text: state.message);
    }

    // States for Update
    else if (state is FavoriteUpdateSuccessState) {
      context.showSnackbar(text: context.localization?.favoriteUpdatedSuccessfully);
    } else if (state is FavoriteUpdateFailureState) {
      context.showSnackbar(text: state.message);
    }
  }

  void _handleGetAllFavouritesSuccessState(GetAllFavouritesSuccessState state) {
    _list = state.data ?? [];
  }
}
