import 'package:flutter/material.dart';
import '../../core/utils/colors.dart';
import '../../core/constants/app_constants.dart';

class RomanticCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const RomanticCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.largeRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
        child: child,
      ),
    );
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  const GradientCard({
    super.key,
    required this.child,
    required this.gradient,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.largeRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
        child: child,
      ),
    );
  }
}

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Duration animationDuration;
  final bool enableHover;

  const AnimatedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.backgroundColor,
    this.borderRadius,
    this.animationDuration = AppConstants.mediumAnimation,
    this.enableHover = true,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: widget.margin ?? const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.white,
              borderRadius: widget.borderRadius ?? 
                  BorderRadius.circular(AppConstants.largeRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: _elevationAnimation.value * 2,
                  offset: Offset(0, _elevationAnimation.value),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.enableHover ? () {} : null,
                onTapDown: widget.enableHover 
                    ? (_) => _animationController.forward()
                    : null,
                onTapUp: widget.enableHover 
                    ? (_) => _animationController.reverse()
                    : null,
                onTapCancel: widget.enableHover 
                    ? () => _animationController.reverse()
                    : null,
                borderRadius: widget.borderRadius ?? 
                    BorderRadius.circular(AppConstants.largeRadius),
                child: Padding(
                  padding: widget.padding ?? 
                      const EdgeInsets.all(AppConstants.defaultPadding),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
