import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/constant/app_colors.dart';
import '../../common/constant/dimens.dart';
import '../../common/constant/styles.dart';
import '../../common/util/context_extension.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../common/widgets/image_background_widget.dart';
import '../sign_in/sign_in_page.dart';
import '../sign_up/sign_up_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  static void navigate(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_) => const WelcomePage()));
  }

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return ImageBackgroundWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: context.localization?.welcome ?? '',
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Dimens.h140.verticalSpace,
              Text(
                context.localization?.welcome ?? "",
                style: AppStyles.style18.copyWith(fontSize: Dimens.fontSize28, color: AppColors.whiteColor),
              ),
              const Spacer(),
              Hero(
                tag: context.localization?.signIn ?? '',
                child: AppButton(
                  buttonName: context.localization?.signIn ?? '',
                  onTap: _handleSignInTap,
                  color: Colors.black12,
                ),
              ),
              Dimens.h24.verticalSpace,
              Hero(
                tag: context.localization?.signUp ?? '',
                child: AppButton(
                  buttonName: context.localization?.signUp ?? '',
                  onTap: _handleSignUpTap,
                ),
              ),
              Dimens.h32.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  void _handleSignInTap() {
    SignInPage.navigate(context);
  }

  void _handleSignUpTap() {
    SignUpPage.navigate(context);
  }
}
