import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';
import '../../../common/util/context_extension.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({this.searchController, this.onTapCancel, super.key});

  final TextEditingController? searchController;
  final VoidCallback? onTapCancel;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  /// Sets the base icon size for the suffix and prefix icons.
  ///
  /// Cannot be null. The size of the icon is scaled using the accessibility
  /// font scale settings. Defaults to `20.0`.
  final itemSize = 20.0;

  // The icon size will be scaled by a factor of the accessibility text scale,
  // to follow the behavior of `UISearchTextField`.
  double get scaledIconSize => MediaQuery.textScalerOf(context).scale(itemSize);

  IconThemeData iconThemeData({Color color = CupertinoColors.secondaryLabel}) =>
      IconThemeData(
        color: CupertinoDynamicColor.resolve(color, context),
        size: scaledIconSize,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.passioMedContrast,
      padding: EdgeInsets.symmetric(vertical: Dimens.h8),
      child: Row(
        children: [
          Dimens.w8.horizontalSpace,
          Expanded(
            child: CupertinoTextField(
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              controller: widget.searchController,
              textInputAction: TextInputAction.search,
              prefix: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                child: IconTheme(
                  data: iconThemeData(color: CupertinoColors.label),
                  child: const Icon(CupertinoIcons.search),
                ),
              ),
              suffix: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                child: CupertinoButton(
                  onPressed: _defaultOnSuffixTap,
                  minSize: 0,
                  padding: EdgeInsets.zero,
                  child: IconTheme(
                    data: iconThemeData(),
                    child: const Icon(CupertinoIcons.xmark_circle_fill),
                  ),
                ),
              ),
              suffixMode: OverlayVisibilityMode.editing,
            ),
          ),
          Dimens.w8.horizontalSpace,
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: widget.onTapCancel,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.h8),
              child: Text(
                context.localization?.cancel ?? '',
                style: AppStyles.style18,
              ),
            ),
          ),
          Dimens.w8.horizontalSpace,
        ],
      ),
    );
  }

  void _defaultOnSuffixTap() {
    widget.searchController?.clear();
  }
}
