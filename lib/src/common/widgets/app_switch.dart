import 'package:flutter/cupertino.dart';
import '../constant/app_colors.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    this.value = false,
    this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      applyTheme: true,
      activeColor: AppColors.indigo600Main,
      value: value,
      onChanged: onChanged,
    );
  }
}
