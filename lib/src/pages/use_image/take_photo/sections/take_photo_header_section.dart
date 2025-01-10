import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/extension/context_extension.dart';
import '../../../../common/widgets/app_bar/custom_app_bar.dart';
import '../../../../common/widgets/icons/help_widget.dart';
import '../bloc/take_photo_bloc.dart';

class TakePhotoHeaderSection extends StatelessWidget {
  const TakePhotoHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: CustomAppBar(
        title: context.localization.photoLogging,
        actions: [
          HelpWidget(
            onTap: () {
              context.read<TakePhotoBloc>().add(const ShowIntroScreenEvent());
            },
          ),
        ],
      ),
    );
  }
}
