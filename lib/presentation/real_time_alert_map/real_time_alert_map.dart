import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/incident_bottom_sheet.dart';
import './widgets/incident_detail_sheet.dart';
import './widgets/map_filter_chip.dart';
import './widgets/map_search_bar.dart';

class RealTimeAlertMap extends StatefulWidget {
  const RealTimeAlertMap({super.key});

  @override
  State<RealTimeAlertMap> createState() => _RealTimeAlertMapState();
}

class _RealTimeAlertMapState extends State<RealTimeAlertMap>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  // User location
  LatLng _userLocation = const LatLng(40.4168, -3.7038); // Madrid default
  bool _isLocationPermissionGranted = false;

  // Filter states
  Map<String, bool> _incidentFilters = {
    'fire': true,
    'flood': true,
    'earthquake': true,
    'storm': true,
  };

  // Animation controllers
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Mock incident data
  final List<Map<String, dynamic>> _mockIncidents = [
    {
      "id": "inc_001",
      "type": "fire",
      "title": "Incendio Forestal Activo",
      "description":
          "Incendio forestal de gran magnitud en la zona norte. Los equipos de emergencia están trabajando para contener las llamas. Se recomienda evacuación inmediata de las áreas cercanas.",
      "location": "Parque Nacional de la Sierra, Madrid",
      "latitude": 40.4378,
      "longitude": -3.6795,
      "severity": "Crítico",
      "status": "Activo",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
      "affectedRadius": 5.2,
      "estimatedAffected": 1500,
      "evacuationStatus": "required",
      "distance": 2.3,
    },
    {
      "id": "inc_002",
      "type": "flood",
      "title": "Inundación en Zona Urbana",
      "description":
          "Inundación causada por el desbordamiento del río debido a las fuertes lluvias. Varias calles están bloqueadas y se recomienda evitar la zona.",
      "location": "Centro Histórico, Madrid",
      "latitude": 40.4165,
      "longitude": -3.7026,
      "severity": "Alto",
      "status": "Monitoreando",
      "timestamp": DateTime.now().subtract(const Duration(hours: 1)),
      "affectedRadius": 2.8,
      "estimatedAffected": 800,
      "evacuationStatus": "recommended",
      "distance": 0.8,
    },
    {
      "id": "inc_003",
      "type": "earthquake",
      "title": "Actividad Sísmica Detectada",
      "description":
          "Se ha detectado actividad sísmica menor en la región. Los sensores indican movimientos de baja intensidad. Se mantiene monitoreo constante.",
      "location": "Zona Metropolitana Sur",
      "latitude": 40.3947,
      "longitude": -3.7492,
      "severity": "Medio",
      "status": "Monitoreando",
      "timestamp": DateTime.now().subtract(const Duration(hours: 3)),
      "affectedRadius": 8.5,
      "estimatedAffected": 3200,
      "evacuationStatus": "none",
      "distance": 4.7,
    },
    {
      "id": "inc_004",
      "type": "storm",
      "title": "Tormenta Severa Aproximándose",
      "description":
          "Tormenta severa con vientos fuertes y granizo se aproxima a la ciudad. Se esperan condiciones climáticas adversas en las próximas horas.",
      "location": "Zona Norte de Madrid",
      "latitude": 40.4589,
      "longitude": -3.6842,
      "severity": "Alto",
      "status": "Activo",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 45)),
      "affectedRadius": 12.0,
      "estimatedAffected": 5000,
      "evacuationStatus": "recommended",
      "distance": 6.2,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _requestLocationPermission();
    _createMarkers();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    setState(() {
      _isLocationPermissionGranted = status.isGranted;
    });
  }

  void _createMarkers() {
    final Set<Marker> markers = {};
    final Set<Circle> circles = {};

    // Add user location marker
    markers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: _userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
          title: 'Tu Ubicación',
          snippet: 'Ubicación actual',
        ),
      ),
    );

    // Add incident markers
    for (final incident in _mockIncidents) {
      final incidentType = incident['type'] as String;
      if (_incidentFilters[incidentType] == true) {
        final markerId = MarkerId(incident['id'] as String);
        final position = LatLng(
          incident['latitude'] as double,
          incident['longitude'] as double,
        );

        markers.add(
          Marker(
            markerId: markerId,
            position: position,
            icon: _getMarkerIcon(incidentType),
            infoWindow: InfoWindow(
              title: incident['title'] as String,
              snippet: incident['severity'] as String,
            ),
            onTap: () => _showIncidentDetail(incident),
          ),
        );

        // Add affected area circle
        circles.add(
          Circle(
            circleId: CircleId('circle_${incident['id']}'),
            center: position,
            radius: (incident['affectedRadius'] as double) *
                1000, // Convert to meters
            fillColor: _getIncidentColor(incidentType).withValues(alpha: 0.2),
            strokeColor: _getIncidentColor(incidentType),
            strokeWidth: 2,
          ),
        );
      }
    }

    setState(() {
      _markers = markers;
      _circles = circles;
    });
  }

  BitmapDescriptor _getMarkerIcon(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'flood':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case 'earthquake':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow);
      case 'storm':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet);
      default:
        return BitmapDescriptor.defaultMarker;
    }
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

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onFilterChanged(String filterType) {
    setState(() {
      _incidentFilters[filterType] = !_incidentFilters[filterType]!;
    });
    _createMarkers();
  }

  void _recenterToUserLocation() {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _userLocation,
            zoom: 14.0,
          ),
        ),
      );
    }
  }

  void _showIncidentDetail(Map<String, dynamic> incident) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => IncidentDetailSheet(
        incident: incident,
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _onSearch(String query) {
    if (query.isEmpty) return;

    // Mock search functionality - in real app would use geocoding
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Buscando: $query'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredIncidents {
    return _mockIncidents.where((incident) {
      final type = incident['type'] as String;
      return _incidentFilters[type] == true;
    }).toList()
      ..sort((a, b) =>
          (a['distance'] as double).compareTo(b['distance'] as double));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _userLocation,
              zoom: 12.0,
            ),
            markers: _markers,
            circles: _circles,
            myLocationEnabled: _isLocationPermissionGranted,
            myLocationButtonEnabled: false,
            compassEnabled: true,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            onTap: (LatLng position) {
              // Hide any open bottom sheets when tapping on map
              FocusScope.of(context).unfocus();
            },
          ),

          // Top overlay with search and filters
          SafeArea(
            child: Column(
              children: [
                // Search bar
                MapSearchBar(
                  onSearch: _onSearch,
                  onMenuTap: () => Navigator.pop(context),
                ),

                // Filter chips
                Container(
                  height: 6.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      MapFilterChip(
                        label: 'Incendios',
                        isSelected: _incidentFilters['fire']!,
                        onTap: () => _onFilterChanged('fire'),
                        selectedColor: const Color(0xFFC41E3A),
                        icon: Icons.local_fire_department,
                      ),
                      SizedBox(width: 2.w),
                      MapFilterChip(
                        label: 'Inundaciones',
                        isSelected: _incidentFilters['flood']!,
                        onTap: () => _onFilterChanged('flood'),
                        selectedColor: const Color(0xFF2E5266),
                        icon: Icons.water,
                      ),
                      SizedBox(width: 2.w),
                      MapFilterChip(
                        label: 'Terremotos',
                        isSelected: _incidentFilters['earthquake']!,
                        onTap: () => _onFilterChanged('earthquake'),
                        selectedColor: const Color(0xFFB8860B),
                        icon: Icons.warning,
                      ),
                      SizedBox(width: 2.w),
                      MapFilterChip(
                        label: 'Tormentas',
                        isSelected: _incidentFilters['storm']!,
                        onTap: () => _onFilterChanged('storm'),
                        selectedColor: const Color(0xFF6B46C1),
                        icon: Icons.cloud,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // GPS recenter button
          Positioned(
            top: 20.h,
            right: 4.w,
            child: SafeArea(
              child: FloatingActionButton(
                mini: true,
                onPressed: _recenterToUserLocation,
                backgroundColor: colorScheme.surface,
                foregroundColor: colorScheme.onSurface,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: CustomIconWidget(
                        iconName: 'my_location',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 24,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Report incident button
          Positioned(
            bottom: 25.h,
            right: 4.w,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/incident-reporting');
              },
              backgroundColor: AppTheme.lightTheme.primaryColor,
              foregroundColor: Colors.white,
              child: CustomIconWidget(
                iconName: 'add_alert',
                color: Colors.white,
                size: 28,
              ),
            ),
          ),

          // Bottom sheet with incidents
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IncidentBottomSheet(
              incidents: _filteredIncidents,
              onIncidentTap: _showIncidentDetail,
            ),
          ),
        ],
      ),
    );
  }
}
