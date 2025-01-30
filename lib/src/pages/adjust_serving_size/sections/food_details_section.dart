import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/icons/icon_pencil_alt_widget.dart';
import '../../../common/widgets/passio/food_item_row.dart';
import '../bloc/adjust_serving_size_bloc.dart';
import '../models/adjust_serving_size_navigation_data.dart';

class FoodDetailsSection extends StatelessWidget {
  const FoodDetailsSection({super.key});

  AdjustServingSizeNavigationDataProvider _getNavigationData(BuildContext context) =>
  AdjustServingSizeNavigationDataProvider.of(context);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdjustServingSizeBloc, AdjustServingSizeState>(
      buildWhen: (_, state) => state is RefreshDetailsState,
      builder: (context, state) {
        int? index;
        Uint8List? image;
        String iconId = '';
        String title = '';
        String subtitle = '';
        bool isEditable = false;
        if (state is RefreshDetailsState) {
          index = state.index;
          image = state.image;
          iconId = state.iconId;
          title = state.title;
          subtitle = state.subtitle;
          isEditable = state.isEditable;
        }
        return Row(
          children: [
            Expanded(
              child: FoodItemRow(
                index: index,
                image: image,
                iconId: iconId,
                title: title,
                subtitle: subtitle,
              ),
            ),
            Visibility(
              visible: isEditable,
              child: IconPencilAltWidget(
                onTap: _getNavigationData(context).onTapEditing,
              ),
            ),
          ],
        );
      },
    );
  }
}
