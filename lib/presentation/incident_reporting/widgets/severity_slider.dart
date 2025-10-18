import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SeveritySlider extends StatelessWidget {
  final double value;
  final Function(double) onChanged;

  const SeveritySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const List<Map<String, dynamic>> _severityLevels = [
    {
      'level': 1,
      'label': 'Menor',
      'description': 'Sin peligro inmediato',
      'color': Color(0xFF4CAF50),
    },
    {
      'level': 2,
      'label': 'Leve',
      'description': 'Situación controlable',
      'color': Color(0xFF8BC34A),
    },
    {
      'level': 3,
      'label': 'Moderado',
      'description': 'Requiere atención',
      'color': Color(0xFFFF9800),
    },
    {
      'level': 4,
      'label': 'Grave',
      'description': 'Situación peligrosa',
      'color': Color(0xFFFF5722),
    },
    {
      'level': 5,
      'label': 'Crítico',
      'description': 'Emergencia extrema',
      'color': Color(0xFFF44336),
    },
  ];

  Map<String, dynamic> get _currentLevel {
    return _severityLevels[value.round() - 1];
  }

  Color _getSliderColor(double position) {
    if (position <= 1) return _severityLevels[0]['color'] as Color;
    if (position >= 5) return _severityLevels[4]['color'] as Color;

    final index = (position - 1).floor();
    final nextIndex = (index + 1).clamp(0, 4);
    final factor = (position - 1) - index;

    final currentColor = _severityLevels[index]['color'] as Color;
    final nextColor = _severityLevels[nextIndex]['color'] as Color;

    return Color.lerp(currentColor, nextColor, factor) ?? currentColor;
  }

  @override
  Widget build(BuildContext context) {
    final currentLevel = _currentLevel;
    final sliderColor = _getSliderColor(value);

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nivel de Severidad',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: sliderColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: sliderColor.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: sliderColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: sliderColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          value.round().toString(),
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentLevel['label'] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: sliderColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            currentLevel['description'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: sliderColor,
                    inactiveTrackColor: sliderColor.withValues(alpha: 0.3),
                    thumbColor: sliderColor,
                    overlayColor: sliderColor.withValues(alpha: 0.2),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 20,
                    ),
                    trackHeight: 6,
                    tickMarkShape: const RoundSliderTickMarkShape(
                      tickMarkRadius: 3,
                    ),
                    activeTickMarkColor: Colors.white,
                    inactiveTickMarkColor: sliderColor.withValues(alpha: 0.5),
                  ),
                  child: Slider(
                    value: value,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (newValue) {
                      HapticFeedback.selectionClick();
                      onChanged(newValue);
                    },
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _severityLevels.map((level) {
                    final isSelected = level['level'] == value.round();
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onChanged((level['level'] as int).toDouble());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (level['color'] as Color).withValues(alpha: 0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(
                                  color: level['color'] as Color,
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: level['color'] as Color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              level['level'].toString(),
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: isSelected
                                    ? (level['color'] as Color)
                                    : AppTheme.lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
