import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VolunteerStatsCard extends StatelessWidget {
  final int nearbyVolunteers;
  final int activeIncidents;
  final VoidCallback onTap;

  const VolunteerStatsCard({
    super.key,
    required this.nearbyVolunteers,
    required this.activeIncidents,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 40.w,
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'volunteer_activism',
                    color: AppTheme.communityLight,
                    size: 5.w,
                  ),
                  const Spacer(),
                  CustomIconWidget(
                    iconName: 'chevron_right',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 4.w,
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                'Voluntarios Cercanos',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                nearbyVolunteers.toString(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.communityLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: activeIncidents > 0
                      ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                      : AppTheme.successLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$activeIncidents incidentes activos',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: activeIncidents > 0
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.successLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
