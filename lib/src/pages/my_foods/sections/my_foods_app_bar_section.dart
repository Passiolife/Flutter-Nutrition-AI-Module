import 'package:flutter/material.dart';

import '../../../common/extension/core_extension.dart';
import '../../../common/widgets/app_bar/custom_app_bar.dart';

class MyFoodsAppBarSection extends StatelessWidget {
  const MyFoodsAppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(title: context.localization.myFoods);
  }
}
