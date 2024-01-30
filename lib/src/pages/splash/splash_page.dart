import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constant/app_colors.dart';
import '../../common/constant/app_images.dart';
import '../../common/constant/dimens.dart';
import '../../common/constant/styles.dart';
import '../../common/util/context_extension.dart';
import '../dashboard/dashboard_page.dart';
import 'bloc/splash_bloc.dart';
import 'widgets/loading_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static void navigate(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const SplashPage()));
  }

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  /// [_bloc] is use to call the events.
  final _bloc = SplashBloc();

  @override
  void initState() {
    _bloc.add(DoConfigureSdkEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is ConfigureSuccessState) {
          _setInitialRoute();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.passioBackgroundWhite,
          resizeToAvoidBottomInset: false,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                AppImages.imgLaunch,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: context.bottomPadding + Dimens.h16,
                left: 0,
                right: 0,
                child: (state is ConfigureLoadingState)
                    ? const LoadingWidget()
                    : (state is ConfigureFailureState)
                        ? Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: AppStyles.style18
                                .copyWith(color: AppColors.errorColor),
                          )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _setInitialRoute() {
    DashboardPage.navigate(context);
  }
}
