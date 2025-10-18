import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IncidentDetailSheet extends StatelessWidget {
  final Map<String, dynamic> incident;
  final VoidCallback onClose;

  const IncidentDetailSheet({
    super.key,
    required this.incident,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final incidentColor = _getIncidentColor(incident['type'] as String);

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with close button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: incidentColor.withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: incidentColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: _getIncidentIcon(incident['type'] as String),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        incident['title'] as String,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _getIncidentTypeLabel(incident['type'] as String),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: incidentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Severity and status
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Severidad',
                          incident['severity'] as String,
                          _getSeverityColor(incident['severity'] as String),
                          theme,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildInfoCard(
                          'Estado',
                          incident['status'] as String,
                          _getStatusColor(incident['status'] as String),
                          theme,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  // Location and time
                  _buildDetailSection(
                    'Ubicación y Tiempo',
                    [
                      _buildDetailRow('location_on', 'Ubicación',
                          incident['location'] as String, theme),
                      _buildDetailRow(
                          'access_time',
                          'Reportado',
                          _getFormattedTime(incident['timestamp'] as DateTime),
                          theme),
                      _buildDetailRow('my_location', 'Distancia',
                          '${incident['distance']} km de tu ubicación', theme),
                    ],
                    theme,
                  ),
                  SizedBox(height: 3.h),
                  // Affected area
                  _buildDetailSection(
                    'Área Afectada',
                    [
                      _buildDetailRow(
                          'radio_button_unchecked',
                          'Radio de impacto',
                          '${incident['affectedRadius']} km',
                          theme),
                      _buildDetailRow('people', 'Población estimada',
                          '${incident['estimatedAffected']} personas', theme),
                    ],
                    theme,
                  ),
                  SizedBox(height: 3.h),
                  // Description
                  _buildDetailSection(
                    'Descripción',
                    [
                      Text(
                        incident['description'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),
                    ],
                    theme,
                  ),
                  SizedBox(height: 3.h),
                  // Emergency instructions
                  if (incident['evacuationStatus'] == 'required') ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC41E3A).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFC41E3A),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'warning',
                                color: const Color(0xFFC41E3A),
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'EVACUACIÓN REQUERIDA',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFFC41E3A),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Evacúe el área inmediatamente. Siga las rutas de evacuación designadas y diríjase al refugio más cercano.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFFC41E3A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                  ],
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Navigate to emergency guide
                            Navigator.pushNamed(
                                context, '/emergency-response-guide');
                          },
                          icon: CustomIconWidget(
                            iconName: 'menu_book',
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          label: const Text('Guía de Emergencia'),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Report related incident
                            Navigator.pushNamed(context, '/incident-reporting');
                          },
                          icon: CustomIconWidget(
                            iconName: 'report',
                            color: colorScheme.onPrimary,
                            size: 20,
                          ),
                          label: const Text('Reportar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      String label, String value, Color color, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(
      String title, List<Widget> children, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(
      String iconName, String label, String value, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getIncidentColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return const Color(0xFFC41E3A);
      case 'flood':
        return const Color(0xFF2E5266);
      case 'earthquake':
        return const Color(0xFFB8860B);
      case 'storm':
        return const Color(0xFF6B46C1);
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  String _getIncidentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return 'local_fire_department';
      case 'flood':
        return 'water';
      case 'earthquake':
        return 'warning';
      case 'storm':
        return 'cloud';
      default:
        return 'error';
    }
  }

  String _getIncidentTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return 'Incendio';
      case 'flood':
        return 'Inundación';
      case 'earthquake':
        return 'Terremoto';
      case 'storm':
        return 'Tormenta';
      default:
        return 'Emergencia';
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'crítico':
        return const Color(0xFFC41E3A);
      case 'alto':
        return const Color(0xFFB8860B);
      case 'medio':
        return const Color(0xFF2E5266);
      case 'bajo':
        return AppTheme.getSuccessColor(true);
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'activo':
        return const Color(0xFFC41E3A);
      case 'monitoreando':
        return const Color(0xFFB8860B);
      case 'resuelto':
        return AppTheme.getSuccessColor(true);
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  String _getFormattedTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Hace menos de 1 minuto';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} minutos';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} horas';
    } else {
      return 'Hace ${difference.inDays} días';
    }
  }
}
