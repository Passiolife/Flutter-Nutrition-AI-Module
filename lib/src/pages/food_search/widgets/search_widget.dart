import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/debouncer.dart';
import '../../../common/util/keyboard_extension.dart';

typedef OnChange = Function(String term);

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    this.initialText,
    this.onChange,
    super.key,
  });

  final String? initialText;
  final OnChange? onChange;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();

  IconThemeData _clearIconTheme(BuildContext context) =>
      IconThemeData(
        color: CupertinoDynamicColor.resolve(AppColors.gray700, context),
        size: MediaQuery.textScalerOf(context).scale(AppDimens.font18),
      );

  /// [_deBouncer] when user stops typing then waits [500] milliseconds and do the search operation.
  final _deBouncer = DeBouncer();

  @override
  void initState() {
    if(widget.initialText!=null) {
      _controller.text = widget.initialText!;
    }
    _controller.addListener(() {
      /// Here managing the debounce so it will wait until user stops the typing.
      _deBouncer.run(() {
        widget.onChange?.call(_controller.text.trim());
      });
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SearchWidget oldWidget) {
    if(widget.initialText!=null && widget.initialText != oldWidget.initialText) {
      _controller.text = widget.initialText!;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    _deBouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundBlueGray,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppDimens.h8,
          top: AppDimens.h57,
          bottom: AppDimens.h12,
        ),
        child: Row(
          children: [
            Expanded(
              child: CupertinoTextField(
                autofocus: true,
                // focusNode: focusNode,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppDimens.r10),
                ),
                textCapitalization: TextCapitalization.sentences,
                controller: _controller,
                textInputAction: TextInputAction.search,
                prefix: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppDimens.w16,
                    AppDimens.h2,
                    AppDimens.w4,
                    AppDimens.h2,
                  ),
                  child: SvgPicture.asset(
                    AppImages.icSearch,
                    width: AppDimens.r24,
                    height: AppDimens.r24,
                    fit: BoxFit.contain,
                  ),
                ),
                suffix: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                  child: CupertinoButton(
                    onPressed: () => _controller.clear(),
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    child: IconTheme(
                      data: _clearIconTheme(context),
                      child: const Icon(CupertinoIcons.xmark_circle_fill),
                    ),
                  ),
                ),
                suffixMode: OverlayVisibilityMode.editing,
                onTapOutside: (_) {
                  context.hideKeyboard();
                },
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.w8,
                  vertical: AppDimens.h8,
                ),
                child: Text(
                  context.localization?.cancel ?? '',
                  style: AppTextStyle.textBase.addAll(
                      [AppTextStyle.medium]).copyWith(color: AppColors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
