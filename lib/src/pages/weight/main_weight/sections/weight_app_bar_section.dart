import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/core_extension.dart';
import '../../../../common/router/routes.dart';
import '../../../../common/util/snackbar_extension.dart';
import '../../../../common/widgets/app_bar/custom_app_bar.dart';
import '../../../../common/widgets/icons/plus_icon_widget.dart';
import '../bloc/weight_bloc.dart';

class WeightAppBarSection extends StatelessWidget {
  const WeightAppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: context.localization.water,
      actions: [
        PlusIconWidget(
          color: AppColors.gray400,
          width: 16.r,
          height: 16.r,
          onTap: () => _onTapAdd(context: context),
        ),
      ],
    );
  }

  Future<void> _onTapAdd({required BuildContext context}) async {
    Navigator.pushNamed(context, Routes.addWaterPage).then((value) {
      if (value == true && context.mounted) {
        context.showSnackbar(
            text: context.localization.waterRecordUpdateMessage);
        // context.read<WaterBloc>().add(const FetchRecordsEvent());
      }
    });
  }
}
