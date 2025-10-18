import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OpportunityCardWidget extends StatelessWidget {
  final Map<String, dynamic> opportunity;
  final VoidCallback onVolunteer;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onGetDirections;
  final VoidCallback onLongPress;

  const OpportunityCardWidget({
    super.key,
    required this.opportunity,
    required this.onVolunteer,
    required this.onSave,
    required this.onShare,
    required this.onGetDirections,
    required this.onLongPress,
  });

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'critical':
        return AppTheme.lightTheme.colorScheme.error;
      case 'high':
        return const Color(0xFFB8860B); // Warning amber
      case 'medium':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return const Color(0xFF4A6741); // Community green
    }
  }

  IconData _getIncidentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'earthquake':
        return Icons.terrain;
      case 'flood':
        return Icons.water;
      case 'fire':
        return Icons.local_fire_department;
      case 'storm':
        return Icons.thunderstorm;
      case 'medical':
        return Icons.medical_services;
      case 'rescue':
        return Icons.emergency;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final urgencyColor = _getUrgencyColor(opportunity['urgency'] as String);
    final incidentIcon = _getIncidentIcon(opportunity['type'] as String);

    return Slidable(
      key: ValueKey(opportunity['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onSave(),
            backgroundColor: const Color(0xFF4A6741),
            foregroundColor: Colors.white,
            icon: Icons.bookmark,
            label: 'Guardar',
          ),
          SlidableAction(
            onPressed: (_) => onShare(),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Compartir',
          ),
          SlidableAction(
            onPressed: (_) => onGetDirections(),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: Colors.white,
            icon: Icons.directions,
            label: 'Ruta',
          ),
        ],
      ),
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with urgency indicator
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: urgencyColor.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: urgencyColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: incidentIcon.codePoint.toString(),
                        color: urgencyColor,
                        size: 6.w,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opportunity['title'] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'location_on',
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                size: 4.w,
                              ),
                              SizedBox(width: 1.w),
                              Expanded(
                                child: Text(
                                  '${opportunity['location']} • ${opportunity['distance']}',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: urgencyColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        (opportunity['urgency'] as String).toUpperCase(),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Text(
                      opportunity['description'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),

                    // Skills and duration
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Habilidades requeridas:',
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Wrap(
                                spacing: 1.w,
                                runSpacing: 0.5.h,
                                children: (opportunity['skills'] as List)
                                    .map((skill) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppTheme
                                            .lightTheme.colorScheme.secondary
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Text(
                                      skill as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.secondary,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomIconWidget(
                              iconName: 'schedule',
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              size: 5.w,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              opportunity['duration'] as String,
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    // Volunteer button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onVolunteer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: urgencyColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'volunteer_activism',
                              color: Colors.white,
                              size: 5.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Ser Voluntario',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
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
  }
}
