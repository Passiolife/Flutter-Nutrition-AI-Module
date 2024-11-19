import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/overlay_widget.dart';
import 'bloc/token_usage_bloc.dart';

class TokenUsageWidget extends StatefulWidget {
  const TokenUsageWidget(this.overlayUtil, {super.key});
  final OverlayUtil overlayUtil;

  @override
  State<TokenUsageWidget> createState() => _TokenUsageWidgetState();
}

class _TokenUsageWidgetState extends State<TokenUsageWidget> {
  final _bloc = TokenUsageBloc.instance;

  PassioTokenBudget? _tokenBudget;
  int _session = 0;

  @override
  void initState() {
    _bloc.add(const GetLastUpdatedEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TokenUsageBloc, TokenUsageState>(
      bloc: _bloc,
      listener: _handleStateChanges,
      builder: (context, state) {
        return Align(
          alignment: Alignment.bottomRight,
          child: FractionallySizedBox(
            widthFactor: 0.3,
            child: Material(
              borderRadius: BorderRadius.circular(6.r),
              color: AppColors.tutorialBackgroundColor,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${context.localization?.session}: $_session',
                      style: AppTextStyle.textXs
                          .copyWith(color: AppColors.white, fontSize: 10.sp),
                    ),
                    Text(
                      '${context.localization?.lastRequest}: ${_tokenBudget?.tokensUsed ?? 0}',
                      style: AppTextStyle.textXs
                          .copyWith(color: AppColors.white, fontSize: 10.sp),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 32.w),
                      child: LinearProgressIndicator(
                        value: (_tokenBudget?.usedPercent() ?? 0),
                        color: AppColors.indigo600Main,
                        backgroundColor: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, TokenUsageState state) {
    if (state is ListenerState) {
      switch (state) {
        case TokenBudgetUpdateListenerState():
          _session = state.session;
          _tokenBudget = state.tokenBudget;
          break;
      }
    }
  }
}
