import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/bottom_toolbar.dart';
import './widgets/disaster_type_header.dart';
import './widgets/instruction_card.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/quick_action_buttons.dart';

class EmergencyResponseGuide extends StatefulWidget {
  const EmergencyResponseGuide({super.key});

  @override
  State<EmergencyResponseGuide> createState() => _EmergencyResponseGuideState();
}

class _EmergencyResponseGuideState extends State<EmergencyResponseGuide>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;

  String _selectedDisasterType = 'Terremoto';
  String _currentThreatLevel = 'Alto';
  int _currentInstructionIndex = 0;
  List<bool> _completedSteps = [];
  bool _isAudioPlaying = false;

  // Mock data for disaster types and instructions
  final Map<String, Map<String, dynamic>> _disasterData = {
    'Terremoto': {
      'threatLevel': 'Alto',
      'threatColor': const Color(0xFFC41E3A),
      'instructions': [
        {
          'instruction':
              'Manténgase calmado y busque refugio inmediatamente bajo una mesa resistente o contra una pared interior.',
          'icon': 'shield',
          'duration': '30 seg',
        },
        {
          'instruction':
              'Proteja su cabeza y cuello con los brazos. Aléjese de ventanas, espejos y objetos que puedan caer.',
          'icon': 'security',
          'duration': '1 min',
        },
        {
          'instruction':
              'Si está al aire libre, aléjese de edificios, árboles y líneas eléctricas. Busque un área abierta.',
          'icon': 'nature',
          'duration': '2 min',
        },
        {
          'instruction':
              'Una vez que pare el temblor, evacue el edificio de manera ordenada usando las escaleras, nunca el ascensor.',
          'icon': 'stairs',
          'duration': '5 min',
        },
        {
          'instruction':
              'Diríjase al punto de encuentro designado y verifique que todos estén seguros.',
          'icon': 'group',
          'duration': '10 min',
        },
        {
          'instruction':
              'Manténgase alerta a réplicas y siga las instrucciones de las autoridades locales.',
          'icon': 'notifications_active',
          'duration': 'Continuo',
        },
      ],
    },
    'Incendio': {
      'threatLevel': 'Crítico',
      'threatColor': const Color(0xFF8B0000),
      'instructions': [
        {
          'instruction':
              'Active la alarma de incendio más cercana y grite "¡FUEGO!" para alertar a otros.',
          'icon': 'alarm',
          'duration': '15 seg',
        },
        {
          'instruction':
              'Salga inmediatamente del edificio por la ruta de escape más cercana. No use ascensores.',
          'icon': 'exit_to_app',
          'duration': '2 min',
        },
        {
          'instruction':
              'Si hay humo, manténgase agachado y cubra nariz y boca con un paño húmedo.',
          'icon': 'air',
          'duration': '1 min',
        },
        {
          'instruction':
              'Toque las puertas antes de abrirlas. Si están calientes, busque otra salida.',
          'icon': 'touch_app',
          'duration': '30 seg',
        },
        {
          'instruction':
              'Una vez afuera, diríjase al punto de encuentro y llame a los bomberos (911).',
          'icon': 'local_fire_department',
          'duration': '3 min',
        },
        {
          'instruction':
              'No regrese al edificio hasta que las autoridades lo declaren seguro.',
          'icon': 'block',
          'duration': 'Hasta autorización',
        },
      ],
    },
    'Inundación': {
      'threatLevel': 'Moderado',
      'threatColor': const Color(0xFF2E5266),
      'instructions': [
        {
          'instruction':
              'Muévase inmediatamente a terreno más alto. Evite caminar o conducir por agua corriente.',
          'icon': 'terrain',
          'duration': '5 min',
        },
        {
          'instruction':
              'Desconecte la electricidad y el gas si es seguro hacerlo antes de evacuar.',
          'icon': 'power_off',
          'duration': '2 min',
        },
        {
          'instruction':
              'Tome solo lo esencial: documentos, medicamentos, agua y comida no perecedera.',
          'icon': 'backpack',
          'duration': '3 min',
        },
        {
          'instruction':
              'Evite agua estancada que pueda estar contaminada o tener corriente eléctrica.',
          'icon': 'dangerous',
          'duration': 'Continuo',
        },
        {
          'instruction':
              'Manténgase informado a través de radio o teléfono sobre la situación.',
          'icon': 'radio',
          'duration': 'Continuo',
        },
        {
          'instruction':
              'No regrese a su hogar hasta que las autoridades confirmen que es seguro.',
          'icon': 'home',
          'duration': 'Hasta autorización',
        },
      ],
    },
    'Tormenta': {
      'threatLevel': 'Moderado',
      'threatColor': const Color(0xFFB8860B),
      'instructions': [
        {
          'instruction':
              'Busque refugio en un edificio sólido. Evite estructuras temporales o móviles.',
          'icon': 'home',
          'duration': '2 min',
        },
        {
          'instruction':
              'Aléjese de ventanas y puertas. Vaya al centro del edificio en el piso más bajo.',
          'icon': 'meeting_room',
          'duration': '1 min',
        },
        {
          'instruction':
              'Desconecte aparatos eléctricos y evite usar teléfonos con cable durante la tormenta.',
          'icon': 'power',
          'duration': '30 seg',
        },
        {
          'instruction':
              'Si está al aire libre, busque refugio inmediatamente. Evite árboles y estructuras altas.',
          'icon': 'forest',
          'duration': '1 min',
        },
        {
          'instruction':
              'Manténgase informado sobre alertas meteorológicas a través de radio o aplicaciones.',
          'icon': 'weather_snowy',
          'duration': 'Continuo',
        },
        {
          'instruction':
              'Espere a que pase completamente la tormenta antes de salir al exterior.',
          'icon': 'schedule',
          'duration': 'Variable',
        },
      ],
    },
  };

  final List<String> _disasterTypes = [
    'Terremoto',
    'Incendio',
    'Inundación',
    'Tormenta'
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: _disasterTypes.length, vsync: this);
    _initializeCompletedSteps();

    // Listen to tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedDisasterType = _disasterTypes[_tabController.index];
          _currentThreatLevel =
              _disasterData[_selectedDisasterType]!['threatLevel'];
          _currentInstructionIndex = 0;
          _initializeCompletedSteps();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _initializeCompletedSteps() {
    final instructions =
        _disasterData[_selectedDisasterType]!['instructions'] as List;
    _completedSteps = List.generate(instructions.length, (index) => false);
  }

  void _toggleStepComplete(int index) {
    setState(() {
      _completedSteps[index] = !_completedSteps[index];
    });

    if (_completedSteps[index]) {
      HapticFeedback.mediumImpact();
      _showToast('Paso ${index + 1} completado');
    }
  }

  void _playAudioInstruction(String instruction) {
    setState(() {
      _isAudioPlaying = true;
    });

    // Simulate audio playback
    HapticFeedback.lightImpact();
    _showToast('Reproduciendo instrucción de audio...');

    // Reset audio state after simulated playback
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isAudioPlaying = false;
        });
      }
    });
  }

  void _callEmergencyServices() {
    HapticFeedback.heavyImpact();
    _showToast('Llamando a servicios de emergencia...');
    // In a real app, this would make an actual emergency call
  }

  void _shareLocation() {
    HapticFeedback.lightImpact();
    _showToast('Compartiendo ubicación con contactos de emergencia...');
    // In a real app, this would share GPS location
  }

  void _reportStatus() {
    HapticFeedback.lightImpact();
    _showToast('Reportando estado a autoridades locales...');
    // In a real app, this would send status report
  }

  void _openEmergencyKit() {
    _showToast('Abriendo lista de kit de emergencia...');
    // Navigate to emergency kit checklist
  }

  void _openEvacuationRoutes() {
    _showToast('Mostrando rutas de evacuación...');
    Navigator.pushNamed(context, '/real-time-alert-map');
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.primaryColor,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  int get _completedStepsCount {
    return _completedSteps.where((completed) => completed).length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final instructions =
        _disasterData[_selectedDisasterType]!['instructions'] as List;
    final threatColor =
        _disasterData[_selectedDisasterType]!['threatColor'] as Color;

    return Scaffold(
      appBar: CustomAppBar.emergency(
        title: 'Guía de Respuesta',
        showEmergencyIndicator: true,
      ),
      body: Column(
        children: [
          // Disaster Type Tabs
          Container(
            color: theme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.6),
              indicatorColor: theme.colorScheme.primary,
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
              tabs: _disasterTypes.map((type) => Tab(text: type)).toList(),
            ),
          ),

          // Main Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _disasterTypes.map((disasterType) {
                final currentInstructions =
                    _disasterData[disasterType]!['instructions'] as List;
                final currentThreatColor =
                    _disasterData[disasterType]!['threatColor'] as Color;
                final currentThreatLevel =
                    _disasterData[disasterType]!['threatLevel'] as String;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Column(
                    children: [
                      // Disaster Type Header
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: DisasterTypeHeader(
                          disasterType: disasterType,
                          threatLevel: currentThreatLevel,
                          threatColor: currentThreatColor,
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Quick Action Buttons
                      QuickActionButtons(
                        onCallEmergency: _callEmergencyServices,
                        onShareLocation: _shareLocation,
                        onReportStatus: _reportStatus,
                      ),

                      SizedBox(height: 2.h),

                      // Instructions List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: currentInstructions.length,
                        itemBuilder: (context, index) {
                          final instruction = currentInstructions[index];
                          final isCurrentDisaster =
                              disasterType == _selectedDisasterType;

                          return InstructionCard(
                            stepNumber: index + 1,
                            instruction: instruction['instruction'],
                            iconName: instruction['icon'],
                            duration: instruction['duration'],
                            isCompleted: isCurrentDisaster
                                ? _completedSteps[index]
                                : false,
                            onToggleComplete: () => isCurrentDisaster
                                ? _toggleStepComplete(index)
                                : null,
                            onAudioPlay: () => _playAudioInstruction(
                                instruction['instruction']),
                          );
                        },
                      ),

                      SizedBox(height: 10.h), // Space for bottom toolbar
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),

      // Bottom Toolbar
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress Indicator
          ProgressIndicatorWidget(
            currentStep: _currentInstructionIndex + 1,
            totalSteps: instructions.length,
            completedSteps: _completedStepsCount,
          ),

          // Bottom Toolbar
          BottomToolbar(
            onEmergencyKit: _openEmergencyKit,
            onEvacuationRoutes: _openEvacuationRoutes,
          ),
        ],
      ),
    );
  }
}
