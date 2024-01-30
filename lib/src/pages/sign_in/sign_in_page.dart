import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../common/constant/app_colors.dart';
import '../../common/constant/dimens.dart';
import '../../common/constant/styles.dart';
import '../../common/util/alert_dialog.dart';
import '../../common/util/context_extension.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_button_loading_widget.dart';
import '../../common/widgets/app_textfield.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../common/widgets/image_background_widget.dart';
import 'bloc/sign_in_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static void navigate(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SignInPage()));
  }

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  /// [_emailController] is use to get the value of email text field.
  final TextEditingController _emailController = TextEditingController(text: kDebugMode ? '' : '');

  /// [_passwordController] is use to get the value of password text field.
  final TextEditingController _passwordController = TextEditingController(text: kDebugMode ? '' : '');

  /// [_bloc] is use to fire the appropriate event and bloc will emit the state.
  /// So, based on that we will display the widget.
  final _bloc = SignInBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _bloc,
      listener: (context, state) {
        if (state is SignInValidEmailErrorState) {
          showDialogBox(context, context.localization?.enterValidEmailAddress ?? '');
        } else if (state is SignInValidPasswordErrorState) {
          showDialogBox(context, context.localization?.enterValidPassword ?? '');
        }
      },
      builder: (context, state) {
        return IgnorePointer(
          ignoring: state is SignInLoadingState || state is ForgotPasswordLoadingState,
          child: ImageBackgroundWidget(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: CustomAppBar(
                title: context.localization?.signIn ?? '',
                isBackVisible: true,
                backPageName: context.localization?.welcome ?? '',
                onBackTap: () {
                  Navigator.pop(context);
                },
                leadingWidth: Dimens.w92,
              ),
              body: SingleChildScrollView(
                child: SizedBox(
                  height: context.height - context.safeAreaPadding - 56,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Dimens.h140.verticalSpace,
                          Text(
                            context.localization?.signIn ?? '',
                            style: AppStyles.style18.copyWith(
                              color: AppColors.whiteColor,
                              fontSize: Dimens.fontSize28,
                            ),
                          ),
                          Dimens.h16.verticalSpace,
                          AppTextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            hintText: context.localization?.email ?? '',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              _bloc.add(ValidateEmailAddressEvent(email: _emailController.text));
                            },
                          ),
                          Dimens.h32.verticalSpace,
                          AppTextField(
                            obscureText: true,
                            controller: _passwordController,
                            hintText: context.localization?.password ?? '',
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) {
                              _bloc.add(DoSignInEvent(_emailController.text, _passwordController.text));
                            },
                          ),
                          const Spacer(),
                          state is ForgotPasswordLoadingState
                              ? const SizedBox(
                                  width: 40,
                                  height: 14,
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.ballPulse,
                                    colors: [AppColors.passioInset],
                                  ),
                                )
                              : GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    _bloc.add(DoForgotPasswordEvent(_emailController.text));
                                  },
                                  child: Text(
                                    context.localization?.forgotPassword ?? "",
                                    style: AppStyles.style14
                                        .copyWith(fontSize: Dimens.fontSize18, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                          Dimens.h56.verticalSpace,
                          state is SignInLoadingState
                              ? const AppButtonLoadingWidget()
                              : AppButton(
                                  buttonName: context.localization?.signIn ?? '',
                                  onTap: () {
                                    _bloc.add(DoSignInEvent(_emailController.text, _passwordController.text));
                                  },
                                ),
                          Dimens.h40.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
