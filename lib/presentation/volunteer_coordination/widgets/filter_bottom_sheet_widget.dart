import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterBottomSheetWidget({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  double _radiusValue = 10.0;

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _radiusValue = (_filters['radius'] as double?) ?? 10.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtros',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Limpiar',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location radius
                  _buildSectionTitle('Radio de ubicación'),
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_radiusValue.round()} km',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              'Máximo: 50 km',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Slider(
                          value: _radiusValue,
                          min: 1.0,
                          max: 50.0,
                          divisions: 49,
                          onChanged: (value) {
                            setState(() {
                              _radiusValue = value;
                              _filters['radius'] = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Skill types
                  _buildSectionTitle('Tipo de habilidades'),
                  SizedBox(height: 1.h),
                  _buildSkillTypeFilters(),
                  SizedBox(height: 3.h),

                  // Availability
                  _buildSectionTitle('Disponibilidad'),
                  SizedBox(height: 1.h),
                  _buildAvailabilityFilters(),
                  SizedBox(height: 3.h),

                  // Urgency level
                  _buildSectionTitle('Nivel de urgencia'),
                  SizedBox(height: 1.h),
                  _buildUrgencyFilters(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text(
                    'Aplicar Filtros',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSkillTypeFilters() {
    final skillTypes = [
      'Primeros Auxilios',
      'Rescate',
      'Comunicaciones',
      'Logística',
      'Construcción',
      'Médico',
      'Psicológico',
      'Traducción',
    ];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: skillTypes.map((skill) {
        final isSelected =
            (_filters['skillTypes'] as List?)?.contains(skill) ?? false;
        return FilterChip(
          label: Text(skill),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _filters['skillTypes'] ??= <String>[];
              if (selected) {
                (_filters['skillTypes'] as List).add(skill);
              } else {
                (_filters['skillTypes'] as List).remove(skill);
              }
            });
          },
          selectedColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
        );
      }).toList(),
    );
  }

  Widget _buildAvailabilityFilters() {
    final availabilityOptions = [
      {'key': 'immediate', 'label': 'Inmediato'},
      {'key': 'today', 'label': 'Hoy'},
      {'key': 'thisWeek', 'label': 'Esta semana'},
      {'key': 'flexible', 'label': 'Flexible'},
    ];

    return Column(
      children: availabilityOptions.map((option) {
        final isSelected = _filters['availability'] == option['key'];
        return RadioListTile<String>(
          title: Text(option['label'] as String),
          value: option['key'] as String,
          groupValue: _filters['availability'] as String?,
          onChanged: (value) {
            setState(() {
              _filters['availability'] = value;
            });
          },
          activeColor: AppTheme.lightTheme.colorScheme.primary,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildUrgencyFilters() {
    final urgencyLevels = [
      {
        'key': 'critical',
        'label': 'Crítico',
        'color': AppTheme.lightTheme.colorScheme.error
      },
      {'key': 'high', 'label': 'Alto', 'color': const Color(0xFFB8860B)},
      {
        'key': 'medium',
        'label': 'Medio',
        'color': AppTheme.lightTheme.colorScheme.secondary
      },
      {'key': 'low', 'label': 'Bajo', 'color': const Color(0xFF4A6741)},
    ];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: urgencyLevels.map((urgency) {
        final isSelected =
            (_filters['urgencyLevels'] as List?)?.contains(urgency['key']) ??
                false;
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 3.w,
                height: 3.w,
                decoration: BoxDecoration(
                  color: urgency['color'] as Color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 2.w),
              Text(urgency['label'] as String),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _filters['urgencyLevels'] ??= <String>[];
              if (selected) {
                (_filters['urgencyLevels'] as List).add(urgency['key']);
              } else {
                (_filters['urgencyLevels'] as List).remove(urgency['key']);
              }
            });
          },
          selectedColor: (urgency['color'] as Color).withValues(alpha: 0.2),
          checkmarkColor: urgency['color'] as Color,
        );
      }).toList(),
    );
  }

  void _resetFilters() {
    setState(() {
      _filters.clear();
      _radiusValue = 10.0;
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(_filters);
    Navigator.pop(context);
  }
}
