import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../constant/app_constants.dart';

class PrimaryTabFilledBar extends StatefulWidget {
  const PrimaryTabFilledBar({
    this.initialTab = 0,
    required this.tabs,
    this.onTabChange,
    this.margin,
    super.key,
  });

  final int initialTab;
  final List<String?> tabs;
  final ValueChanged<int>? onTabChange;
  final EdgeInsets? margin;

  @override
  State<PrimaryTabFilledBar> createState() => _PrimaryTabFilledBarState();
}

class _PrimaryTabFilledBarState extends State<PrimaryTabFilledBar> {

  int? _selectedTab;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _onTabChange(widget.initialTab);
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PrimaryTabFilledBar oldWidget) {
    if(oldWidget.initialTab != widget.initialTab) {
      setState(() {
        _selectedTab = widget.initialTab;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      height: AppDimens.h42,
      margin: widget.margin,
      child: Row(
        children: widget.tabs.asMap()
            .map(
              (index, e) => MapEntry(index, _TabRow(
                isActive: index == _selectedTab,
                text: e,
                onTap: () => _onTabChange(index),
              ),)
            ).values.toList(),
      ),
    );
  }

  void _onTabChange(int tab) {
    setState(() {
      _selectedTab = tab;
    });
    widget.onTabChange?.call(tab);
  }
}

class _TabRow extends StatelessWidget {
  const _TabRow({
    this.isActive = false,
    this.text,
    this.onTap,
  });

  final bool isActive;
  final String? text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        splashColor: AppColors.blue50,
        highlightColor: AppColors.blue50,
        onTap: onTap,
        child: Container(
          decoration: isActive
              ? BoxDecoration(
                  color: AppColors.indigo600Main,
                  borderRadius: BorderRadius.circular(AppDimens.r6),
                )
              : null,
          child: Center(
            child: Text(
              text ?? '',
              style: AppTextStyle.textSm.addAll([
                AppTextStyle.textSm.leading5,
                AppTextStyle.medium
              ]).copyWith(
                  color: isActive ? AppColors.white : AppColors.gray700),
            ),
          ),
        ),
      ),
    );
  }
}
