import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/passio_image_widget.dart';

abstract interface class RowListener {
  void onAdd(int index);

  void onEdit(int index);

  void onDelete(int index);
}

class RowWidget extends StatelessWidget {
  const RowWidget({
    this.index = 0,
    this.iconId,
    this.foodName,
    this.additionalDetails,
    this.listener,
    super.key,
  });

  final int index;
  final String? iconId;
  final String? foodName;
  final String? additionalDetails;
  final RowListener? listener;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        extentRatio: 0.6,
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => listener?.onDelete(index),
        ),
        children: [
          SlidableAction(
            onPressed: (context) => listener?.onEdit(index),
            backgroundColor: AppColors.indigo600Main,
            foregroundColor: Colors.white,
            label: context.localization?.edit ?? '',
          ),
          SlidableAction(
            onPressed: (context) => listener?.onDelete(index),
            backgroundColor: AppColors.red500,
            foregroundColor: Colors.white,
            label: context.localization?.delete ?? '',
          ),
        ],
      ),
      child: Container(
        decoration: AppShadows.customShadow,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: AppColors.blue50,
            highlightColor: AppColors.blue50,
            onTap: () => listener?.onEdit(index),
            child: Padding(
              padding: EdgeInsets.all(AppDimens.r8),
              child: Row(
                children: [
                  PassioImageWidget(
                    iconId: iconId ?? '',
                    radius: AppDimens.r20,
                    heroTag: '$iconId$index',
                  ),
                  SizedBox(width: AppDimens.w8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: '$foodName$index',
                          child: Text(
                            foodName ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.textSm.addAll([
                              AppTextStyle.textSm.leading5,
                              AppTextStyle.semiBold
                            ]).copyWith(color: AppColors.gray900),
                          ),
                        ),
                        additionalDetails?.isNotEmpty ?? false
                            ? Text(
                                additionalDetails ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.textSm
                                    .copyWith(color: AppColors.gray500),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      AppImages.icPlusSolid,
                      width: AppDimens.r24,
                      height: AppDimens.r24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.gray400,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () => listener?.onAdd(index),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
