import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/src/view/bloc/search_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
    /*return BlocListener<SearchBloc, SearchState>(
      // listener: _handleStateChanges,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: ,
        // body: Column(
        //   children: [
        //     const SearchAppBarSection(),
        //     const KeepTypingSection(),
        //     Expanded(
        //       child: SingleChildScrollView(
        //         padding: AppPadding.pv16,
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             // const AlternativeSection(),
        //             // const MyFoodsSection(),
        //             // SizedBox(height: AppDimens.h16),
        //             // const SearchResultSection(),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );*/
  }

  // void _handleStateChanges(BuildContext context, FoodSearchState state) {
  //   if (state is FoodLogSuccessState) {
  //     context.showSnackbar(text: context.localization?.itemAddedToDiary);
  //   }
  // }
}
