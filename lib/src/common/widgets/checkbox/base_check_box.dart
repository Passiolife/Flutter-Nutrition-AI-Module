import 'package:flutter/material.dart';

import '../../constant/app_colors.dart';

class BaseCheckBox extends StatefulWidget {
  const BaseCheckBox({
    required this.size,
    required this.selectedColor,
    required this.unselectedColor,
    this.isSelected = false,
    this.duration = const Duration(milliseconds: 250),
    this.onChanged,
    super.key,
  });

  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final double size;
  final Duration duration;
  final ValueChanged<bool>? onChanged;

  @override
  State<BaseCheckBox> createState() => _BaseCheckBoxState();
}

class _BaseCheckBoxState extends State<BaseCheckBox> {
  late bool _isSelected;

  @override
  void initState() {
    _isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.onChanged?.call(_isSelected);
      },
      icon: AnimatedContainer(
        key: ValueKey<bool>(_isSelected),
        duration: widget.duration,
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: _isSelected ? widget.selectedColor : widget.unselectedColor,
          shape: BoxShape.circle,
          border:
          _isSelected ? null : Border.all(color: AppColors.brandBorders),
        ),
      ),
    );
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.onChanged?.call(_isSelected);
      },
      child: AnimatedContainer(
        key: ValueKey<bool>(_isSelected),
        duration: widget.duration,
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: _isSelected ? widget.selectedColor : widget.unselectedColor,
          shape: BoxShape.circle,
          border:
              _isSelected ? null : Border.all(color: AppColors.brandBorders),
        ),
      ),
    );
  }
}
