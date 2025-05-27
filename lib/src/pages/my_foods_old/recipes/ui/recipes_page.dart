import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/util/snackbar_extension.dart';
import '../bloc/recipes_bloc.dart';
import 'section/action_buttons_section.dart';
import 'section/recipe_list_section.dart';

part 'screen/recipes_screen.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecipesBloc(),
      child: _RecipesScreen(),
    );
  }
}
