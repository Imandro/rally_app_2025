import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DisasterTypeHeader extends StatelessWidget {
  final String disasterType;
  final String threatLevel;
  final Color threatColor;

  const DisasterTypeHeader({
    super.key,
    required this.disasterType,
    required this.threatLevel,
    required this.threatColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            threatColor.withValues(alpha: 0.1),
            threatColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: threatColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Disaster Icon
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: threatColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: _getDisasterIcon(disasterType),
              color: threatColor,
              size: 10.w,
            ),
          ),
          SizedBox(height: 2.h),

          // Disaster Type Title
          Text(
            disasterType,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),

          // Threat Level Indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: threatColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: Colors.white,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Nivel de Amenaza: $threatLevel',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDisasterIcon(String type) {
    switch (type.toLowerCase()) {
      case 'terremoto':
        return 'vibration';
      case 'incendio':
        return 'local_fire_department';
      case 'inundación':
        return 'water_damage';
      case 'tormenta':
        return 'thunderstorm';
      case 'huracán':
        return 'cyclone';
      default:
        return 'emergency';
    }
  }
}
