import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionButtons extends StatelessWidget {
  final VoidCallback onCallEmergency;
  final VoidCallback onShareLocation;
  final VoidCallback onReportStatus;

  const QuickActionButtons({
    super.key,
    required this.onCallEmergency,
    required this.onShareLocation,
    required this.onReportStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          // Emergency Call Button
          Expanded(
            child: _QuickActionButton(
              icon: 'phone',
              label: 'Llamar\nEmergencias',
              color: AppTheme.lightTheme.primaryColor,
              onTap: () {
                HapticFeedback.heavyImpact();
                onCallEmergency();
              },
            ),
          ),

          SizedBox(width: 3.w),

          // Share Location Button
          Expanded(
            child: _QuickActionButton(
              icon: 'location_on',
              label: 'Compartir\nUbicación',
              color: theme.colorScheme.secondary,
              onTap: () {
                HapticFeedback.lightImpact();
                onShareLocation();
              },
            ),
          ),

          SizedBox(width: 3.w),

          // Report Status Button
          Expanded(
            child: _QuickActionButton(
              icon: 'report',
              label: 'Reportar\nEstado',
              color: AppTheme.getWarningColor(
                  theme.brightness == Brightness.light),
              onTap: () {
                HapticFeedback.lightImpact();
                onReportStatus();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatefulWidget {
  final String icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _handleTap,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: widget.icon,
                    color: Colors.white,
                    size: 7.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
