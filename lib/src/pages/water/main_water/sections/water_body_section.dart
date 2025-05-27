import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/core_extension.dart';
import '../bloc/water_bloc.dart';
import 'water_date_range_section.dart';
import 'water_quick_add_section.dart';
import 'water_records_section.dart';
import 'water_trend_section.dart';

class WaterBodySection extends StatefulWidget {
  const WaterBodySection({super.key});

  @override
  State<WaterBodySection> createState() => _WaterBodySectionState();
}

class _WaterBodySectionState extends State<WaterBodySection> {
  final PageController _pageController = PageController();

  final List<Widget> _tabs = [_BodyContentWidget(), _BodyContentWidget()];

  @override
  void initState() {
    _setListener();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WaterBloc, WaterState>(
      listenWhen: (_, state) {
        return state is UpdateTabState;
      },
      listener: (context, state) {
        _handleTabChange(state as UpdateTabState);
      },
      child: Expanded(
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _tabs,
        ),
      ),
    );
  }

  void _onPageChanged(int page) {
    context.read<WaterBloc>().add(UpdatePageEvent(page));
  }

  void _handleTabChange(UpdateTabState state) {
    _removeListener();
    _pageController.animateToPage(state.tab, duration: Duration(milliseconds: 250), curve: Curves.linear).then((_) {
      _setListener();
    });
  }

  void _setListener() {
    _pageController.addListener(_onPageChange);
  }

  void _removeListener() {
    _pageController.removeListener(_onPageChange);
  }

  void _onPageChange() {
    if(_pageController.page == null) return;
    context.read<WaterBloc>().add(UpdatePageEvent(_pageController.page!.round()));
  }
}

class _BodyContentWidget extends StatefulWidget {
  const _BodyContentWidget();

  @override
  State<_BodyContentWidget> createState() => _BodyContentWidgetState();
}

class _BodyContentWidgetState extends State<_BodyContentWidget> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        40.verticalSpace,
        const WaterDateRangeSection(),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            padding: AppPadding.pt32 + context.bottomPadding + AppPadding.pb16,
            children: [
              const WaterTrendSection(),
              16.verticalSpace,
              const WaterQuickAddSection(),
              16.verticalSpace,
              const WaterRecordsSection(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
