import 'package:flutter/material.dart';

import '../../../common/constant/dimens.dart';
import '../../../common/util/context_extension.dart';

class NoFoodRecordsWidget extends StatelessWidget {
  const NoFoodRecordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimens.h56,
      ),
      child: Text(
        context.localization?.noFoodInLog ?? '',
        textAlign: TextAlign.center,
      ),
    );
  }
}
