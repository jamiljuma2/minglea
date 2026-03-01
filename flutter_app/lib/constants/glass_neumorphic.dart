import 'package:flutter/material.dart';
import 'dart:ui';
import 'app_theme.dart';

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double blur;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final Border? border;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding,
    this.blur = 16,
    this.color,
    this.boxShadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: color ?? Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ?? Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: boxShadow ?? AppShadows.soft,
          ),
          child: child,
        ),
      ),
    );
  }
}

class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool dark;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = dark || Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.background,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isDark ? AppShadows.neumorphismDark : AppShadows.neumorphismLight,
      ),
      child: child,
    );
  }
}
