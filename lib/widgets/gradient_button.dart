import 'package:flutter/material.dart';
import 'package:keepit/app_colors.dart';

class GradientOutlineButton extends StatelessWidget {
  final String text; 
  final VoidCallback onPressed;
  final double radius; 
  final double borderWidth; 
  final Gradient borderGradient; 
  final EdgeInsetsGeometry? margin; 
  final EdgeInsetsGeometry? contentPadding; 

  const GradientOutlineButton({
    required this.text,
    required this.onPressed,
    required this.borderGradient,
    super.key,
    this.radius = 0.0,
    this.borderWidth = 1.0,
    this.margin,
    this.contentPadding,
  });
  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: margin, 
        padding: const EdgeInsets.all(1), 
        decoration: BoxDecoration(
          gradient: borderGradient, 
          borderRadius: _getBorderRadius(), 
        ),
        child: Container(
          padding:
              contentPadding, 
          decoration: BoxDecoration(
            color: AppColors.transparentColor,
            borderRadius:
                _getBorderRadius(),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }


  BorderRadius _getBorderRadius() {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
    );
  }
}
