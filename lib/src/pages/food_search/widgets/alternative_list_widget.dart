import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import 'alternative_row_skeleton_widget.dart';
import 'alternative_row_widget.dart';
import 'interfaces.dart';

class AlternativeListWidget extends StatelessWidget {
  const AlternativeListWidget({
    required this.alternatives,
    this.listener,
    super.key,
  });

  final List<String> alternatives;

  final PassioSearchListener? listener;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.h56 + AppDimens.h8,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: alternatives.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.w16,
          vertical: AppDimens.h4,
        ),
        itemBuilder: (BuildContext context, int index) {
          final data = alternatives.elementAt(index);
          if (data != '-1') {
            return AlternativeRowWidget(
              data: data,
              listener: listener,
            );
          } else {
            return const AlternativeRowSkeletonWidget();
          }
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: AppDimens.w8);
        },
      ),
    );
  }
}
