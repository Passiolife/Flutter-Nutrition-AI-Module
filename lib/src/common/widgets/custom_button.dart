import 'package:flutter/material.dart';

import '../constant/app_colors.dart';
import '../constant/styles.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;

  const CustomElevatedButton({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: AppStyles.style14.copyWith(color: Colors.white),
      ),
    );
  }
}
