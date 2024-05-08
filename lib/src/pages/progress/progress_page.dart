import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/constant/app_constants.dart';
import '../../common/util/context_extension.dart';
import '../../common/widgets/app_tab_bar.dart';
import 'bloc/progress_bloc.dart';
import 'macros/macros_page.dart';
import 'micros/micros_page.dart';
import 'widgets/widgets.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with SingleTickerProviderStateMixin {
  final _bloc = ProgressBloc();

  TabController? _tabController;
  PageController? _pageController;

  List<Tab> get _tabs => [
        Tab(
          text: context.localization?.macros ?? '',
        ),
        Tab(
          text: context.localization?.micros ?? '',
        ),
      ];

  List<Widget> get _tabsWidget => [
        const MacrosPage(),
        const MicrosPage(),
      ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();

    _tabController?.addListener(() {
      _pageController?.animateToPage(
        _tabController?.index ?? 0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.linear,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProgressBloc, ProgressState>(
      bloc: _bloc,
      listener: (context, state) {
        _handleStateChanges(context: context, state: state);
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              CustomAppBarWidget(
                title: context.localization?.progress,
              ),
              AppTabBar(
                controller: _tabController,
                tabs: _tabs,
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: _tabsWidget,
                  onPageChanged: (page) {
                    _tabController?.animateTo(
                      page,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.linear,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleStateChanges(
      {required BuildContext context, required ProgressState state}) {}
}
