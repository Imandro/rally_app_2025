import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/camera_viewfinder.dart';
import './widgets/description_input.dart';
import './widgets/incident_type_selector.dart';
import './widgets/location_card.dart';
import './widgets/sensor_data_toggle.dart';
import './widgets/severity_slider.dart';

class IncidentReporting extends StatefulWidget {
  const IncidentReporting({super.key});

  @override
  State<IncidentReporting> createState() => _IncidentReportingState();
}

class _IncidentReportingState extends State<IncidentReporting>
    with TickerProviderStateMixin {
  // Form state
  String? _selectedIncidentType;
  XFile? _capturedImage;
  Position? _currentPosition;
  String _description = '';
  double _severityLevel = 3.0;
  bool _includeSensorData = false;
  bool _isSubmitting = false;
  bool _isLocationLoading = false;
  bool _isOffline = false;

  // Controllers
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Mock draft data
  final List<Map<String, dynamic>> _savedDrafts = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _getCurrentLocation();
    _checkConnectivity();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _slideController.forward();
  }

  Future<void> _checkConnectivity() async {
    // Mock connectivity check
    setState(() {
      _isOffline = false; // Simulating online state
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLocationLoading = true;
    });

    try {
      final hasPermission = await _requestLocationPermission();
      if (!hasPermission) {
        setState(() {
          _isLocationLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      setState(() {
        _currentPosition = position;
        _isLocationLoading = false;
      });
    } catch (e) {
      // Mock location for demo purposes
      setState(() {
        _currentPosition = Position(
          latitude: 40.7128,
          longitude: -74.0060,
          timestamp: DateTime.now(),
          accuracy: 5.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );
        _isLocationLoading = false;
      });
    }
  }

  Future<bool> _requestLocationPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.location.request();
    return status.isGranted;
  }

  bool get _isFormValid {
    return _selectedIncidentType != null &&
        _description.trim().isNotEmpty &&
        _description.trim().length >= 10;
  }

  Future<void> _submitReport() async {
    if (!_isFormValid || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Create report data
      final reportData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'type': _selectedIncidentType,
        'description': _description.trim(),
        'severity': _severityLevel.round(),
        'location': _currentPosition != null
            ? {
                'latitude': _currentPosition!.latitude,
                'longitude': _currentPosition!.longitude,
                'accuracy': _currentPosition!.accuracy,
              }
            : null,
        'hasImage': _capturedImage != null,
        'includeSensorData': _includeSensorData,
        'timestamp': DateTime.now().toIso8601String(),
        'status': _isOffline ? 'queued' : 'submitted',
      };

      // Success feedback
      HapticFeedback.lightImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    _isOffline
                        ? 'Reporte guardado. Se enviará cuando haya conexión.'
                        : 'Reporte enviado exitosamente',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppTheme.getSuccessColor(true),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate back after success
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'error',
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Error al enviar el reporte. Intenta nuevamente.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _saveDraft() async {
    if (_selectedIncidentType == null && _description.trim().isEmpty) {
      return;
    }

    final draftData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': _selectedIncidentType,
      'description': _description.trim(),
      'severity': _severityLevel,
      'location': _currentPosition != null
          ? {
              'latitude': _currentPosition!.latitude,
              'longitude': _currentPosition!.longitude,
            }
          : null,
      'hasImage': _capturedImage != null,
      'includeSensorData': _includeSensorData,
      'savedAt': DateTime.now().toIso8601String(),
    };

    setState(() {
      _savedDrafts.add(draftData);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'save',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Borrador guardado',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openLocationPicker() {
    // Navigate to map picker (would be implemented separately)
    Navigator.pushNamed(context, '/real-time-alert-map');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Reportar Incidente',
        showBackButton: true,
        emergencyMode: true,
        showEmergencyIndicator: _isOffline,
        actions: [
          if (_savedDrafts.isNotEmpty)
            IconButton(
              onPressed: () {
                // Show drafts dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Borradores Guardados'),
                    content: Text(
                        'Tienes ${_savedDrafts.length} borrador(es) guardado(s).'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cerrar'),
                      ),
                    ],
                  ),
                );
              },
              icon: Stack(
                children: [
                  CustomIconWidget(
                    iconName: 'drafts',
                    color: Colors.white,
                    size: 24,
                  ),
                  if (_savedDrafts.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppTheme.getWarningColor(true),
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          _savedDrafts.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              tooltip: 'Borradores',
            ),
        ],
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null &&
                details.primaryVelocity! > 300) {
              Navigator.of(context).pop();
            }
          },
          child: Container(
            height: double.infinity,
            child: Column(
              children: [
                // Offline indicator
                if (_isOffline)
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    color: AppTheme.getWarningColor(true),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'wifi_off',
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Sin conexión - Los reportes se enviarán automáticamente',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Incident type selector
                        IncidentTypeSelector(
                          selectedType: _selectedIncidentType,
                          onTypeSelected: (type) {
                            setState(() {
                              _selectedIncidentType = type;
                            });
                          },
                        ),
                        SizedBox(height: 3.h),

                        // Camera viewfinder
                        CameraViewfinder(
                          onImageCaptured: (image) {
                            setState(() {
                              _capturedImage = image;
                            });
                          },
                        ),
                        SizedBox(height: 3.h),

                        // Location card
                        LocationCard(
                          latitude: _currentPosition?.latitude,
                          longitude: _currentPosition?.longitude,
                          accuracy: _currentPosition?.accuracy,
                          isLoading: _isLocationLoading,
                          onLocationTap: _openLocationPicker,
                        ),
                        SizedBox(height: 3.h),

                        // Description input
                        DescriptionInput(
                          initialText: _description,
                          onTextChanged: (text) {
                            setState(() {
                              _description = text;
                            });
                          },
                          maxLength: 500,
                        ),
                        SizedBox(height: 3.h),

                        // Severity slider
                        SeveritySlider(
                          value: _severityLevel,
                          onChanged: (value) {
                            setState(() {
                              _severityLevel = value;
                            });
                          },
                        ),
                        SizedBox(height: 3.h),

                        // Sensor data toggle
                        SensorDataToggle(
                          isEnabled: _includeSensorData,
                          onToggled: (enabled) {
                            setState(() {
                              _includeSensorData = enabled;
                            });
                          },
                        ),
                        SizedBox(height: 4.h),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _saveDraft,
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  side: BorderSide(
                                    color:
                                        AppTheme.lightTheme.colorScheme.outline,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'save',
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                      size: 20,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text('Guardar Borrador'),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: _isFormValid && !_isSubmitting
                                    ? _submitReport
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  backgroundColor: _isFormValid
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.3),
                                ),
                                child: _isSubmitting
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomIconWidget(
                                            iconName: 'send',
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 2.w),
                                          Text(
                                            'Enviar Reporte',
                                            style: TextStyle(
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
                        SizedBox(height: 2.h),

                        // Form validation info
                        if (!_isFormValid)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: AppTheme.getWarningColor(true)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.getWarningColor(true)
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'info',
                                  color: AppTheme.getWarningColor(true),
                                  size: 16,
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    'Selecciona un tipo de incidente y proporciona una descripción de al menos 10 caracteres.',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.getWarningColor(true),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        SizedBox(height: 10.h), // Bottom padding for navigation
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 2, // Report tab
        emergencyMode: true,
        showCommunityPulse: false,
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}