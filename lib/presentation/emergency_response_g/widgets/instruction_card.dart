import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InstructionCard extends StatefulWidget {
  final int stepNumber;
  final String instruction;
  final String iconName;
  final String duration;
  final bool isCompleted;
  final VoidCallback onToggleComplete;
  final VoidCallback onAudioPlay;

  const InstructionCard({
    super.key,
    required this.stepNumber,
    required this.instruction,
    required this.iconName,
    required this.duration,
    required this.isCompleted,
    required this.onToggleComplete,
    required this.onAudioPlay,
  });

  @override
  State<InstructionCard> createState() => _InstructionCardState();
}

class _InstructionCardState extends State<InstructionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
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
    HapticFeedback.lightImpact();
    widget.onToggleComplete();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: widget.isCompleted
                  ? AppTheme.getSuccessColor(!isDarkMode).withValues(alpha: 0.1)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isCompleted
                    ? AppTheme.getSuccessColor(!isDarkMode)
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: widget.isCompleted ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    children: [
                      // Step Number Circle
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: widget.isCompleted
                              ? AppTheme.getSuccessColor(!isDarkMode)
                              : theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: widget.isCompleted
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: Colors.white,
                                  size: 6.w,
                                )
                              : Text(
                                  '${widget.stepNumber}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(width: 3.w),

                      // Instruction Icon
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: widget.iconName,
                          color: theme.colorScheme.primary,
                          size: 6.w,
                        ),
                      ),

                      const Spacer(),

                      // Duration Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.getWarningColor(!isDarkMode)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.duration,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.getWarningColor(!isDarkMode),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      SizedBox(width: 2.w),

                      // Audio Play Button
                      GestureDetector(
                        onTap: widget.onAudioPlay,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'volume_up',
                            color: theme.colorScheme.secondary,
                            size: 5.w,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Instruction Text
                  Text(
                    widget.instruction,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Complete Checkbox
                  GestureDetector(
                    onTap: _handleTap,
                    child: Row(
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: widget.isCompleted
                                ? AppTheme.getSuccessColor(!isDarkMode)
                                : Colors.transparent,
                            border: Border.all(
                              color: widget.isCompleted
                                  ? AppTheme.getSuccessColor(!isDarkMode)
                                  : theme.colorScheme.outline,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: widget.isCompleted
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: Colors.white,
                                  size: 4.w,
                                )
                              : null,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          widget.isCompleted
                              ? 'Completado'
                              : 'Marcar como completado',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: widget.isCompleted
                                ? AppTheme.getSuccessColor(!isDarkMode)
                                : theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
