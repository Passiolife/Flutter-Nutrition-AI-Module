import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/router/routes.dart';
import 'bloc/food_scan_bloc.dart';
import 'screen/food_scan_screen.dart';

class FoodScanPage extends StatelessWidget {
  const FoodScanPage({required this.selectedDateTime, super.key});

  final DateTime selectedDateTime;

  static MaterialPageRoute route({required DateTime selectedDateTime}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: Routes.foodScan),
      builder: (_) => FoodScanPage(selectedDateTime: selectedDateTime),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodScanBloc(),
      child: FoodScanScreen(),
    );
  }
}
