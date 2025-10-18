import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IncidentTypeSelector extends StatelessWidget {
  final String? selectedType;
  final Function(String) onTypeSelected;

  const IncidentTypeSelector({
    super.key,
    this.selectedType,
    required this.onTypeSelected,
  });

  static const List<Map<String, dynamic>> _incidentTypes = [
    {
      'type': 'Fire',
      'icon': 'local_fire_department',
      'color': Color(0xFFFF5722),
    },
    {
      'type': 'Flood',
      'icon': 'water',
      'color': Color(0xFF2196F3),
    },
    {
      'type': 'Earthquake',
      'icon': 'terrain',
      'color': Color(0xFF795548),
    },
    {
      'type': 'Storm',
      'icon': 'thunderstorm',
      'color': Color(0xFF607D8B),
    },
    {
      'type': 'Other',
      'icon': 'report_problem',
      'color': Color(0xFF9E9E9E),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Tipo de Incidente',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: _incidentTypes.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final incident = _incidentTypes[index];
                final isSelected = selectedType == incident['type'];

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onTypeSelected(incident['type'] as String);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (incident['color'] as Color).withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.surface,
                      border: Border.all(
                        color: isSelected
                            ? (incident['color'] as Color)
                            : AppTheme.lightTheme.colorScheme.outline,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: incident['icon'] as String,
                          color: isSelected
                              ? (incident['color'] as Color)
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          incident['type'] as String,
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: isSelected
                                ? (incident['color'] as Color)
                                : AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
