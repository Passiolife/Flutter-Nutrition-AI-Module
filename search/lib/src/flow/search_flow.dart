import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:search/src/view/bloc/search_bloc.dart';
import 'package:search/src/view/screen/search_screen.dart';

class SearchFlow extends StatefulWidget {
  const SearchFlow({super.key});

  @override
  State<SearchFlow> createState() => _SearchFlowState();
}

class _SearchFlowState extends State<SearchFlow> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (_) => GetIt.I.get<SearchBloc>(),
      child: const SearchScreen(),
    );
  }
}
