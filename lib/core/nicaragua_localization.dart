import 'package:flutter/material.dart';

/// Nicaragua-specific localization and emergency data for DisasterGuard
class NicaraguaLocalization {
  NicaraguaLocalization._();

  /// Emergency contact numbers for Nicaragua
  static const Map<String, String> emergencyContacts = {
    'police': '118',
    'fire': '115',
    'medical': '128',
    'general': '911',
    'red_cross': '133',
    'disaster_management': '911',
  };

  /// Nicaragua disaster types and their descriptions
  static const Map<String, Map<String, String>> disasterTypes = {
    'earthquake': {
      'name': 'Terremoto',
      'description': 'Actividad sísmica detectada',
      'icon': 'terrain',
      'severity_levels': 'Leve, Moderado, Fuerte, Muy Fuerte',
    },
    'volcano': {
      'name': 'Actividad Volcánica',
      'description': 'Monitoreo volcanes activos',
      'icon': 'volcano',
      'severity_levels': 'Verde, Amarillo, Naranja, Rojo',
    },
    'hurricane': {
      'name': 'Huracán/Tormenta',
      'description': 'Sistema tropical del Caribe',
      'icon': 'cyclone',
      'severity_levels': 'Depresión, Tormenta, Cat.1, Cat.2, Cat.3+',
    },
    'flood': {
      'name': 'Inundación',
      'description': 'Crecida de ríos y lagos',
      'icon': 'flood',
      'severity_levels': 'Leve, Moderado, Mayor, Crítico',
    },
    'drought': {
      'name': 'Sequía',
      'description': 'Escasez de agua prolongada',
      'icon': 'drought',
      'severity_levels': 'Moderado, Severo, Extremo',
    },
    'landslide': {
      'name': 'Deslizamiento',
      'description': 'Deslaves por lluvia intensa',
      'icon': 'landslide',
      'severity_levels': 'Menor, Moderado, Mayor',
    },
  };

  /// Major Nicaragua volcanoes for monitoring
  static const List<Map<String, dynamic>> activeVolcanoes = [
    {
      'name': 'Masaya',
      'location': 'Parque Nacional Volcán Masaya',
      'coordinates': {'lat': 11.9842, 'lng': -86.1611},
      'alert_level': 'Verde',
      'last_activity': '2024-01-15',
    },
    {
      'name': 'Momotombo',
      'location': 'León',
      'coordinates': {'lat': 12.4225, 'lng': -86.5403},
      'alert_level': 'Verde',
      'last_activity': '2016-12-01',
    },
    {
      'name': 'San Cristóbal',
      'location': 'Chinandega',
      'coordinates': {'lat': 12.7022, 'lng': -87.0042},
      'alert_level': 'Amarillo',
      'last_activity': '2023-09-12',
    },
    {
      'name': 'Telica',
      'location': 'León',
      'coordinates': {'lat': 12.6058, 'lng': -86.8456},
      'alert_level': 'Verde',
      'last_activity': '2023-11-20',
    },
    {
      'name': 'Concepción',
      'location': 'Ometepe, Rivas',
      'coordinates': {'lat': 11.5383, 'lng': -85.6217},
      'alert_level': 'Verde',
      'last_activity': '2010-03-15',
    },
  ];

  /// Major Nicaragua rivers for flood monitoring
  static const List<Map<String, dynamic>> monitoredRivers = [
    {
      'name': 'Río San Juan',
      'region': 'Región Autónoma Atlántico Sur',
      'risk_level': 'Alto',
      'monitoring_stations': 3,
    },
    {
      'name': 'Río Coco (Segovia)',
      'region': 'Nueva Segovia / Atlántico Norte',
      'risk_level': 'Moderado',
      'monitoring_stations': 2,
    },
    {
      'name': 'Río Grande de Matagalpa',
      'region': 'Matagalpa / Atlántico Norte',
      'risk_level': 'Alto',
      'monitoring_stations': 4,
    },
    {
      'name': 'Río Tipitapa',
      'region': 'Managua',
      'risk_level': 'Moderado',
      'monitoring_stations': 2,
    },
  ];

  /// Nicaragua administrative departments
  static const List<String> departments = [
    'Boaco',
    'Carazo',
    'Chinandega',
    'Chontales',
    'Estelí',
    'Granada',
    'Jinotega',
    'León',
    'Madriz',
    'Managua',
    'Masaya',
    'Matagalpa',
    'Nueva Segovia',
    'Río San Juan',
    'Rivas',
    'Región Autónoma Atlántico Norte (RAAN)',
    'Región Autónoma Atlántico Sur (RAAS)',
  ];

  /// Common Nicaragua disaster shelter locations
  static const List<Map<String, dynamic>> emergencyShelters = [
    {
      'name': 'Estadio Nacional Dennis Martínez',
      'location': 'Managua',
      'capacity': 15000,
      'type': 'Estadio Nacional',
    },
    {
      'name': 'Centro Nacional de Convenciones',
      'location': 'Managua',
      'capacity': 5000,
      'type': 'Centro de Convenciones',
    },
    {
      'name': 'Universidad Nacional Autónoma de Nicaragua (UNAN)',
      'location': 'León',
      'capacity': 8000,
      'type': 'Universidad',
    },
    {
      'name': 'Universidad Centroamericana (UCA)',
      'location': 'Managua',
      'capacity': 6000,
      'type': 'Universidad',
    },
  ];

  /// Hurricane season information for Nicaragua
  static const Map<String, dynamic> hurricaneSeasonInfo = {
    'season_start': 'Junio 1',
    'season_end': 'Noviembre 30',
    'peak_months': ['Agosto', 'Septiembre', 'Octubre'],
    'affected_regions': [
      'Costa Caribe Norte',
      'Costa Caribe Sur',
      'Región Central',
      'Pacífico Norte',
    ],
    'evacuation_routes': [
      'Carretera Panamericana (hacia el oeste)',
      'Carretera Nueva a León',
      'Carretera a Masaya-Granada',
    ],
  };

  /// Seismic zones in Nicaragua (based on geological risk)
  static const Map<String, List<String>> seismicZones = {
    'high_risk': ['Managua', 'León', 'Chinandega', 'Masaya', 'Granada'],
    'moderate_risk': ['Matagalpa', 'Jinotega', 'Estelí', 'Boaco', 'Carazo'],
    'low_risk': [
      'Nueva Segovia',
      'Madriz',
      'Rivas',
      'Chontales',
      'Río San Juan',
    ],
  };

  /// Get emergency contact for specific service
  static String getEmergencyContact(String service) {
    return emergencyContacts[service] ?? emergencyContacts['general']!;
  }

  /// Get volcano info by name
  static Map<String, dynamic>? getVolcanoInfo(String name) {
    try {
      return activeVolcanoes.firstWhere(
        (volcano) => volcano['name'].toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get department risk level for specific disaster
  static String getDepartmentRiskLevel(String department, String disasterType) {
    switch (disasterType.toLowerCase()) {
      case 'earthquake':
        if (seismicZones['high_risk']!.contains(department)) return 'Alto';
        if (seismicZones['moderate_risk']!.contains(department))
          return 'Moderado';
        return 'Bajo';
      case 'hurricane':
        if (hurricaneSeasonInfo['affected_regions'].contains(department))
          return 'Alto';
        return 'Moderado';
      case 'volcano':
        List<String> volcanicDepartments = [
          'León',
          'Chinandega',
          'Masaya',
          'Granada',
          'Managua',
          'Rivas',
        ];
        return volcanicDepartments.contains(department) ? 'Alto' : 'Bajo';
      default:
        return 'Moderado';
    }
  }

  /// Format Nicaragua phone number
  static String formatNicaraguaPhone(String phone) {
    // Remove any non-digits
    String digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 8) {
      // Local number: XXXX-XXXX
      return '${digits.substring(0, 4)}-${digits.substring(4)}';
    } else if (digits.length == 11 && digits.startsWith('505')) {
      // International: +505 XXXX-XXXX
      return '+505 ${digits.substring(3, 7)}-${digits.substring(7)}';
    }

    return phone; // Return original if format not recognized
  }

  /// Get localized disaster message
  static String getDisasterMessage(String disasterType, String severity) {
    Map<String, dynamic>? disaster = disasterTypes[disasterType];
    if (disaster == null) return 'Alerta de emergencia activada';

    return 'ALERTA: ${disaster['name']} - Nivel $severity detectado. Manténgase informado y siga las instrucciones de las autoridades.';
  }
}
