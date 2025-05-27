import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc_/home_bloc.dart';
import '../widgetss/home_app_bar_widget_new.dart';

class HomeAppBarSection extends StatelessWidget {
  const HomeAppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (_, state) {
        return state is HomeInitial || state is UpdateHeaderState;
      },
      builder: (context, state) {
        String userName = '';
        DateTime selectedDate = DateTime.now();
        if (state is UpdateHeaderState) {
          userName = state.userName;
          selectedDate = state.selectedDate;
        }
        return HomeAppBarWidget(
          userName: userName,
          selectedDate: selectedDate,
          onDateChanged: (date) {
            context.read<HomeBloc>().add(UpdateDateEvent(date));
          },
        );
      },
    );
  }
}
