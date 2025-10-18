import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/volunteer_coordination/volunteer_coordination.dart';
import '../presentation/emergency_dashboard/emergency_dashboard.dart';
import '../presentation/emergency_response_g/emergency_response_guide.dart';
import '../presentation/real_time_alert_map/real_time_alert_map.dart';
import '../presentation/incident_reporting/incident_reporting.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String volunteerCoordination = '/volunteer-coordination';
  static const String emergencyDashboard = '/emergency-dashboard';
  static const String emergencyResponseGuide = '/emergency-response-guide';
  static const String realTimeAlertMap = '/real-time-alert-map';
  static const String incidentReporting = '/incident-reporting';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const EmergencyDashboard(),
    splash: (context) => const SplashScreen(),
    volunteerCoordination: (context) => const VolunteerCoordination(),
    emergencyDashboard: (context) => const EmergencyDashboard(),
    emergencyResponseGuide: (context) => const EmergencyResponseGuide(),
    realTimeAlertMap: (context) => const RealTimeAlertMap(),
    incidentReporting: (context) => const IncidentReporting(),
    // TODO: Add your other routes here
  };
}
