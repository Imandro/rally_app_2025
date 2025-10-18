import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyActionCard extends StatelessWidget {
  final String title;
  final String iconName;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool isEmergency;

  const EmergencyActionCard({
    super.key,
    required this.title,
    required this.iconName,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.isEmergency = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor = backgroundColor ??
        (isEmergency ? AppTheme.lightTheme.primaryColor : colorScheme.surface);
    final effectiveIconColor =
        iconColor ?? (isEmergency ? Colors.white : colorScheme.primary);
    final textColor = isEmergency ? Colors.white : colorScheme.onSurface;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 12.h),
      child: Card(
        elevation: isEmergency ? 4.0 : 2.0,
        color: effectiveBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: effectiveIconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: effectiveIconColor,
                      size: 6.w,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight:
                          isEmergency ? FontWeight.w700 : FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: textColor.withValues(alpha: 0.6),
                  size: 5.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
