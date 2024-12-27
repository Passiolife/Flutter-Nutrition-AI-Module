import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/constant/app_padding.dart';
import '../../../common/extension/context_extension.dart';
import 'bloc/token_usage_bloc.dart';

class TokenUsageWidget extends StatefulWidget {
  const TokenUsageWidget({super.key});

  @override
  State<TokenUsageWidget> createState() => _TokenUsageWidgetState();
}

class _TokenUsageWidgetState extends State<TokenUsageWidget> {
  final _bloc = TokenUsageBloc();
  PassioTokenBudget? _tokenBudget;
  int _session = 0;

  @override
  void initState() {
    _bloc.add(const GetLastUpdatedEvent());
    _bloc.add(const StartListeningEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TokenUsageBloc, TokenUsageState>(
      bloc: _bloc,
      listener: _handleStateChanges,
      builder: (context, state) {
        return _tokenBudget != null
            ? Align(
                alignment: Alignment.bottomRight,
                child: FractionallySizedBox(
                  widthFactor: 0.3,
                  child: Material(
                    borderRadius: BorderRadius.circular(6.r),
                    color: AppColors.black.withValues(alpha: 0.7),
                    child: Padding(
                      padding: AppPadding.ph4 + AppPadding.pv2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${context.localization?.api}: ${_tokenBudget?.apiName ?? ''}',
                            style: AppTextStyle.text3xs.addAll([AppTextStyle.bold]).copyWith(
                                color: AppColors.white),
                          ),
                          Text(
                            '${context.localization?.session}: $_session',
                            style: AppTextStyle.text3xs.addAll([AppTextStyle.bold]).copyWith(
                                color: AppColors.white),
                          ),
                          Text(
                            '${context.localization?.lastRequest}: ${_tokenBudget?.tokensUsed ?? 0}',
                            style: AppTextStyle.text3xs.addAll([AppTextStyle.bold]).copyWith(
                                color: AppColors.white),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 40.w),
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
              )
            : SizedBox.shrink();
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
