import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationCard extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final double? accuracy;
  final VoidCallback? onLocationTap;
  final bool isLoading;

  const LocationCard({
    super.key,
    this.latitude,
    this.longitude,
    this.accuracy,
    this.onLocationTap,
    this.isLoading = false,
  });

  String get _locationText {
    if (latitude != null && longitude != null) {
      return '${latitude!.toStringAsFixed(6)}, ${longitude!.toStringAsFixed(6)}';
    }
    return 'Ubicación no disponible';
  }

  String get _accuracyText {
    if (accuracy != null) {
      return 'Precisión: ${accuracy!.toStringAsFixed(0)}m';
    }
    return 'Precisión: Desconocida';
  }

  Color get _accuracyColor {
    if (accuracy == null) return AppTheme.lightTheme.colorScheme.outline;

    if (accuracy! <= 10) {
      return AppTheme.getSuccessColor(true);
    } else if (accuracy! <= 50) {
      return AppTheme.getWarningColor(true);
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }

  IconData get _accuracyIcon {
    if (accuracy == null) return Icons.location_off;

    if (accuracy! <= 10) {
      return Icons.gps_fixed;
    } else if (accuracy! <= 50) {
      return Icons.gps_not_fixed;
    } else {
      return Icons.gps_off;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Ubicación del Incidente',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: _accuracyIcon.codePoint.toString(),
                      color: _accuracyColor,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        _locationText,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (latitude != null && longitude != null) {
                          Clipboard.setData(ClipboardData(text: _locationText));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Coordenadas copiadas'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: CustomIconWidget(
                        iconName: 'copy',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                        size: 16,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'my_location',
                      color: _accuracyColor,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _accuracyText,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _accuracyColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onLocationTap,
              icon: CustomIconWidget(
                iconName: 'map',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              label: Text(
                'Usar Ubicación Diferente',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
