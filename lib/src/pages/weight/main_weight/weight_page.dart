import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/weight_bloc.dart';
import 'sections/weight_app_bar_section.dart';
import 'sections/weight_tab_bar_section.dart';

part 'screen/weight_screen.dart';

class WeightPage extends StatelessWidget {
  const WeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeightBloc(),
      child: _WeightScreen(),
    );
  }
}