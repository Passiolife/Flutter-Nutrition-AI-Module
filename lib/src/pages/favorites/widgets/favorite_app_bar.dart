import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/custom_app_bar_widget.dart';

class FavoriteAppBar extends StatelessWidget {
  const FavoriteAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBarWidget(
            title: context.localization?.myFavorites,
            isMenuVisible: false,
          ),
        ],
      ),
    );
  }
}