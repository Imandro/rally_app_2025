import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/alert_banner.dart';
import './widgets/emergency_action_card.dart';
import './widgets/sensor_status_card.dart';
import './widgets/status_indicator.dart';
import './widgets/volunteer_stats_card.dart';
import 'widgets/alert_banner.dart';
import 'widgets/emergency_action_card.dart';
import 'widgets/sensor_status_card.dart';
import 'widgets/status_indicator.dart';
import 'widgets/volunteer_stats_card.dart';

class EmergencyDashboard extends StatefulWidget {
  const EmergencyDashboard({super.key});

  @override
  State<EmergencyDashboard> createState() => _EmergencyDashboardState();
}

class _EmergencyDashboardState extends State<EmergencyDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  DateTime _lastUpdated = DateTime.now();

  // Mock data for emergency dashboard - Nicaragua localized
  final List<Map<String, dynamic>> _emergencyActions = [
    {
      "id": 1,
      "title": "Reportar Incidente",
      "icon": "camera_alt",
      "route": "/incident-reporting",
      "isEmergency": true,
    },
    {
      "id": 2,
      "title": "Encontrar Refugio",
      "icon": "location_on",
      "route": "/real-time-alert-map",
      "isEmergency": false,
    },
    {
      "id": 3,
      "title": "Contactos de Emergencia",
      "icon": "phone",
      "route": "/emergency-contacts",
      "isEmergency": false,
    },
    {
      "id": 4,
      "title": "Estado de Sensores",
      "icon": "sensors",
      "route": "/sensor-monitoring",
      "isEmergency": false,
    },
  ];

  // Nicaragua-specific natural disaster monitoring
  final List<Map<String, dynamic>> _sensorData = [
    {
      "type": "Volcán Masaya",
      "status": "Normal",
      "value": "Nivel 2 - Verde",
      "lastUpdate": "hace 1 min",
      "isOnline": true,
    },
    {
      "type": "Río San Juan",
      "status": "Advertencia",
      "value": "Nivel alto - 2.8m",
      "lastUpdate": "hace 3 min",
      "isOnline": true,
    },
    {
      "type": "Sismo Nacional",
      "status": "Normal",
      "value": "3.1 Richter",
      "lastUpdate": "hace 5 min",
      "isOnline": true,
    },
    {
      "type": "Huracán Caribe",
      "status": "Crítico",
      "value": "Cat. 2 - 120 km/h",
      "lastUpdate": "hace 2 min",
      "isOnline": true,
    },
  ];

  final Map<String, dynamic> _currentAlert = {
    "threatLevel": "Medium",
    "location": "Managua, Nicaragua",
    "lastUpdated": "hace 15 minutos",
    "isActive": true,
  };

  final Map<String, dynamic> _volunteerStats = {
    "nearbyVolunteers": 24,
    "activeIncidents": 3,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        HapticFeedback.selectionClick();
      }
    });
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _refreshData();
        _startAutoRefresh();
      }
    });
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    HapticFeedback.lightImpact();

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _lastUpdated = DateTime.now();
      });
    }
  }

  void _onEmergencyPressed() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                CustomIconWidget(
                  iconName: 'emergency',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 6.w,
                ),
                SizedBox(width: 2.w),
                const Text('Emergencia'),
              ],
            ),
            content: const Text(
              '¿Necesitas asistencia de emergencia inmediata?\n\nPresiona "Llamar 911" para contactar servicios de emergencia de Nicaragua.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Simulate emergency call for Nicaragua
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Conectando con servicios de emergencia Nicaragua - 911...',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.primaryColor,
                ),
                child: const Text('Llamar 911'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'DisasterGuard',
        showEmergencyIndicator: true,
        emergencyMode: false,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: theme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Dashboard'),
                Tab(text: 'Alertas'),
                Tab(text: 'Voluntarios'),
                Tab(text: 'Perfil'),
              ],
            ),
          ),
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDashboardTab(),
                _buildAlertsTab(),
                _buildVolunteersTab(),
                _buildProfileTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onEmergencyPressed,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
          iconName: 'emergency',
          color: Colors.white,
          size: 7.w,
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 0,
        emergencyMode: false,
        showCommunityPulse: true,
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Alert Banner
                AlertBanner(
                  threatLevel: _currentAlert["threatLevel"] as String,
                  location: _currentAlert["location"] as String,
                  lastUpdated: _currentAlert["lastUpdated"] as String,
                  isActive: _currentAlert["isActive"] as bool,
                ),

                SizedBox(height: 2.h),

                // Quick Status Indicators
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatusIndicator(
                        label: 'GPS',
                        iconName: 'gps_fixed',
                        isActive: true,
                        value: '±3m',
                      ),
                      StatusIndicator(
                        label: 'Sensores',
                        iconName: 'sensors',
                        isActive: true,
                        value: '4/4',
                      ),
                      StatusIndicator(
                        label: 'Red',
                        iconName: 'signal_cellular_4_bar',
                        isActive: true,
                        value: '4G',
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // Emergency Actions Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    'Acciones de Emergencia',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                SizedBox(height: 1.h),

                // Emergency Action Cards
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: _emergencyActions.length,
                  separatorBuilder: (context, index) => SizedBox(height: 1.h),
                  itemBuilder: (context, index) {
                    final action = _emergencyActions[index];
                    return EmergencyActionCard(
                      title: action["title"] as String,
                      iconName: action["icon"] as String,
                      isEmergency: action["isEmergency"] as bool,
                      onTap: () {
                        Navigator.pushNamed(context, action["route"] as String);
                      },
                    );
                  },
                ),

                SizedBox(height: 3.h),

                // Community Stats Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    children: [
                      Text(
                        'Estado de la Comunidad',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (_isRefreshing)
                        SizedBox(
                          width: 4.w,
                          height: 4.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 1.h),

                // Volunteer Stats and Sensor Data
                SizedBox(
                  height: 20.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    children: [
                      VolunteerStatsCard(
                        nearbyVolunteers:
                            _volunteerStats["nearbyVolunteers"] as int,
                        activeIncidents:
                            _volunteerStats["activeIncidents"] as int,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/volunteer-coordination',
                          );
                        },
                      ),
                      SizedBox(width: 3.w),
                      ...(_sensorData as List).map(
                        (sensor) => Padding(
                          padding: EdgeInsets.only(right: 3.w),
                          child: SensorStatusCard(
                            sensorType: sensor["type"] as String,
                            status: sensor["status"] as String,
                            value: sensor["value"] as String?,
                            lastUpdate: sensor["lastUpdate"] as String,
                            isOnline: sensor["isOnline"] as bool,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),

                // Last Updated Info
                Center(
                  child: Text(
                    'Última actualización: ${_lastUpdated.hour.toString().padLeft(2, '0')}:${_lastUpdated.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),

                SizedBox(height: 10.h), // Space for FAB
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'notifications_active',
            color: AppTheme.lightTheme.primaryColor,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Alertas en Tiempo Real',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 1.h),
          Text(
            'Las alertas aparecerán aquí cuando\nse detecten emergencias cercanas',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVolunteersTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'volunteer_activism',
            color: AppTheme.communityLight,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Coordinación de Voluntarios',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 1.h),
          Text(
            'Conecta con voluntarios locales\ny coordina esfuerzos de ayuda',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'person',
            color: Theme.of(context).colorScheme.primary,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Perfil de Usuario',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 1.h),
          Text(
            'Gestiona tu información personal\ny preferencias de emergencia',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
