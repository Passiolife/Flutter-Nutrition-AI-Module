import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/models/food_record/food_record.dart';
import '../../common/extension/context_extension.dart';
import '../../common/util/snackbar_extension.dart';
import 'bloc/favorites_bloc.dart';
import 'sections/favorites_list_section.dart';
import 'sections/no_data_section.dart';

part 'screen/favorites_screen.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => FavoritesBloc(),
      child: _FavoritesScreen(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
