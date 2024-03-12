import 'package:flutter/material.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import 'interfaces.dart';
import 'row_skeleton_widget.dart';
import 'row_widget.dart';

class ListWidget extends StatelessWidget {
  const ListWidget({
    required this.results,
    this.listener,
    super.key,
  });

  final List<PassioSearchResult> results;
  final PassioSearchListener? listener;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: results.length,
          padding: EdgeInsets.only(bottom: AppDimens.h24, top: AppDimens.h16),
          itemBuilder: (BuildContext context, int index) {
            final data = results.elementAt(index);
            if (data.resultId != '-1') {
              return RowWidget(
                index: index,
                data: data,
                listener: listener,
                key: ValueKey(data.iconID),
              );
            } else {
              return const RowSkeletonWidget();
            }
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: AppDimens.h8);
          },
        ),
      ),
    );
  }
}
