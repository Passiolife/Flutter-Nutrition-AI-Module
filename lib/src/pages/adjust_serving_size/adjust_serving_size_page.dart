import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/constant/app_constants.dart';
import '../../common/extension/context_extension.dart';
import '../../common/models/food_record/food_record.dart';
import '../../common/util/navigation_utils/core_route.dart';
import 'bloc/adjust_serving_size_bloc.dart';
import 'models/adjust_serving_size_navigation_data.dart';
import 'sections/food_details_section.dart';
import 'sections/serving_size_section.dart';
import 'widgets/action_buttons_widget.dart';

part 'screen/adjust_serving_size_screen.dart';

class AdjustServingSizePage extends StatelessWidget {
  const AdjustServingSizePage({
    required this.foodRecord,
    this.image,
    this.index,
    this.onTapEditing,
    super.key,
  });

  final FoodRecord foodRecord;
  final Uint8List? image;
  final int? index;
  final VoidCallback? onTapEditing;

  static Future<FoodRecord?> navigate({
    required BuildContext context,
    required FoodRecord foodRecord,
    Uint8List? image,
    int? index,
    VoidCallback? onTapEditing,
  }) async {
    return await Navigator.push(
      context,
      HeroDialogRoute(
        child: AdjustServingSizePage(
          foodRecord: foodRecord,
          image: image,
          index: index,
          onTapEditing: onTapEditing,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdjustServingSizeNavigationDataProvider(
      foodRecord: foodRecord,
      index: index,
      image: image,
      onTapEditing: onTapEditing,
      child: BlocProvider(
        create: (context) => AdjustServingSizeBloc(),
        child: const _AdjustServingSizeScreen(),
      ),
    );
  }
}
