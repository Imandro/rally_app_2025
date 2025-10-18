import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SensorStatusCard extends StatelessWidget {
  final String sensorType;
  final String status;
  final String? value;
  final String lastUpdate;
  final bool isOnline;

  const SensorStatusCard({
    super.key,
    required this.sensorType,
    required this.status,
    this.value,
    required this.lastUpdate,
    required this.isOnline,
  });

  String _getSensorIcon() {
    switch (sensorType.toLowerCase()) {
      case 'earthquake':
      case 'sismo':
        return 'vibration';
      case 'flood':
      case 'inundación':
        return 'water_drop';
      case 'fire':
      case 'incendio':
        return 'local_fire_department';
      case 'storm':
      case 'tormenta':
        return 'thunderstorm';
      case 'temperature':
      case 'temperatura':
        return 'thermostat';
      default:
        return 'sensors';
    }
  }

  Color _getStatusColor() {
    if (!isOnline) return AppTheme.neutralLight;

    switch (status.toLowerCase()) {
      case 'critical':
      case 'crítico':
      case 'danger':
      case 'peligro':
        return AppTheme.lightTheme.primaryColor;
      case 'warning':
      case 'advertencia':
      case 'caution':
      case 'precaución':
        return AppTheme.warningLight;
      case 'normal':
      case 'safe':
      case 'seguro':
        return AppTheme.successLight;
      default:
        return AppTheme.neutralLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor();

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 42.w,
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: _getSensorIcon(),
                    color: statusColor,
                    size: 5.w,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 2.5.w,
                  height: 2.5.w,
                  decoration: BoxDecoration(
                    color: isOnline
                        ? AppTheme.successLight
                        : AppTheme.neutralLight,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.5.h),
            Text(
              sensorType,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 9.sp,
                ),
              ),
            ),
            if (value != null) ...[
              SizedBox(height: 1.h),
              Text(
                value!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ],
            SizedBox(height: 1.h),
            Text(
              'Actualizado: $lastUpdate',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 8.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
