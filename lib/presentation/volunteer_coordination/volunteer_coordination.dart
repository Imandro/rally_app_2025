import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/activity_card_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/leaderboard_item_widget.dart';
import './widgets/opportunity_card_widget.dart';

class VolunteerCoordination extends StatefulWidget {
  const VolunteerCoordination({super.key});

  @override
  State<VolunteerCoordination> createState() => _VolunteerCoordinationState();
}

class _VolunteerCoordinationState extends State<VolunteerCoordination>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isAvailable = true;
  Map<String, dynamic> _filters = {};

  // Mock data for opportunities
  final List<Map<String, dynamic>> _opportunities = [
    {
      "id": 1,
      "title": "Asistencia médica de emergencia",
      "type": "medical",
      "location": "Hospital Central",
      "distance": "2.3 km",
      "urgency": "critical",
      "description":
          "Se necesitan voluntarios con experiencia médica para asistir en el triaje de pacientes durante la emergencia por terremoto.",
      "skills": ["Primeros Auxilios", "Médico", "Triaje"],
      "duration": "4-6 horas",
      "organization": "Cruz Roja Española",
      "contactInfo": "+34 911 123 456",
      "requirements":
          "Certificación en primeros auxilios requerida. Experiencia médica preferida.",
    },
    {
      "id": 2,
      "title": "Distribución de suministros",
      "type": "rescue",
      "location": "Centro de Evacuación Norte",
      "distance": "5.1 km",
      "urgency": "high",
      "description":
          "Ayuda necesaria para organizar y distribuir alimentos, agua y mantas a las familias evacuadas.",
      "skills": ["Logística", "Organización"],
      "duration": "3-4 horas",
      "organization": "Protección Civil",
      "contactInfo": "+34 911 234 567",
      "requirements": "Capacidad física para levantar cajas de hasta 20kg.",
    },
    {
      "id": 3,
      "title": "Apoyo psicológico",
      "type": "medical",
      "location": "Refugio Temporal Sur",
      "distance": "1.8 km",
      "urgency": "medium",
      "description":
          "Brindar apoyo emocional y contención a niños y familias afectadas por el desastre.",
      "skills": ["Psicológico", "Trabajo Social"],
      "duration": "2-3 horas",
      "organization": "Cáritas",
      "contactInfo": "+34 911 345 678",
      "requirements":
          "Formación en psicología o trabajo social. Experiencia con niños valorada.",
    },
    {
      "id": 4,
      "title": "Comunicaciones de emergencia",
      "type": "rescue",
      "location": "Centro de Comando",
      "distance": "3.7 km",
      "urgency": "high",
      "description":
          "Operar equipos de radio y coordinar comunicaciones entre equipos de rescate.",
      "skills": ["Comunicaciones", "Radio"],
      "duration": "6-8 horas",
      "organization": "Radioaficionados de Emergencia",
      "contactInfo": "+34 911 456 789",
      "requirements": "Licencia de radioaficionado requerida.",
    },
  ];

  // Mock data for activities
  final List<Map<String, dynamic>> _activities = [
    {
      "id": 1,
      "title": "Rescate en zona de inundación",
      "organization": "Bomberos Voluntarios",
      "status": "active",
      "progress": 75,
      "hoursCompleted": 12,
      "date": "15 Oct 2025",
      "location": "Río Guadalquivir",
      "description":
          "Participación en operaciones de rescate durante las inundaciones.",
    },
    {
      "id": 2,
      "title": "Distribución de alimentos",
      "organization": "Banco de Alimentos",
      "status": "completed",
      "progress": 100,
      "hoursCompleted": 8,
      "date": "10 Oct 2025",
      "location": "Centro Comunitario",
      "description":
          "Organización y distribución de alimentos a familias necesitadas.",
    },
    {
      "id": 3,
      "title": "Capacitación en primeros auxilios",
      "organization": "Cruz Roja",
      "status": "pending",
      "progress": 25,
      "hoursCompleted": 2,
      "date": "20 Oct 2025",
      "location": "Sede Cruz Roja",
      "description":
          "Curso de formación en técnicas básicas de primeros auxilios.",
    },
  ];

  // Mock data for leaderboard
  final List<Map<String, dynamic>> _leaderboard = [
    {
      "id": 1,
      "name": "María González",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "totalHours": 156,
      "activitiesCompleted": 23,
      "points": 2340,
      "badges": ["Héroe Local", "Rescatista", "Mentor"],
    },
    {
      "id": 2,
      "name": "Carlos Rodríguez",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "totalHours": 142,
      "activitiesCompleted": 19,
      "points": 2130,
      "badges": ["Comunicador", "Líder"],
    },
    {
      "id": 3,
      "name": "Ana Martínez",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "totalHours": 128,
      "activitiesCompleted": 18,
      "points": 1920,
      "badges": ["Médica", "Formadora"],
    },
    {
      "id": 4,
      "name": "Tú",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "totalHours": 89,
      "activitiesCompleted": 12,
      "points": 1340,
      "badges": ["Voluntario", "Comprometido"],
    },
    {
      "id": 5,
      "name": "Luis Fernández",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "totalHours": 76,
      "activitiesCompleted": 11,
      "points": 1140,
      "badges": ["Logística"],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.community(
        title: 'Coordinación de Voluntarios',
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: Colors.white,
              size: 6.w,
            ),
            onPressed: _showFilterBottomSheet,
            tooltip: 'Filtros',
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Oportunidades'),
                Tab(text: 'Mis Actividades'),
                Tab(text: 'Clasificación'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOpportunitiesTab(),
                _buildActivitiesTab(),
                _buildLeaderboardTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleAvailability,
        backgroundColor: _isAvailable
            ? const Color(0xFF4A6741)
            : AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
        icon: CustomIconWidget(
          iconName: _isAvailable ? 'check_circle' : 'pause_circle_filled',
          color: Colors.white,
          size: 6.w,
        ),
        label: Text(
          _isAvailable ? 'Disponible' : 'No Disponible',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 3,
        showCommunityPulse: true,
      ),
    );
  }

  Widget _buildOpportunitiesTab() {
    return RefreshIndicator(
      onRefresh: _refreshOpportunities,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        itemCount: _opportunities.length,
        itemBuilder: (context, index) {
          final opportunity = _opportunities[index];
          return OpportunityCardWidget(
            opportunity: opportunity,
            onVolunteer: () => _volunteerForOpportunity(opportunity),
            onSave: () => _saveOpportunity(opportunity),
            onShare: () => _shareOpportunity(opportunity),
            onGetDirections: () => _getDirections(opportunity),
            onLongPress: () => _showOpportunityDetails(opportunity),
          );
        },
      ),
    );
  }

  Widget _buildActivitiesTab() {
    return RefreshIndicator(
      onRefresh: _refreshActivities,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        itemCount: _activities.length,
        itemBuilder: (context, index) {
          final activity = _activities[index];
          return ActivityCardWidget(
            activity: activity,
            onViewDetails: () => _viewActivityDetails(activity),
            onProvideFeedback: () => _provideFeedback(activity),
          );
        },
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    return RefreshIndicator(
      onRefresh: _refreshLeaderboard,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        itemCount: _leaderboard.length,
        itemBuilder: (context, index) {
          final volunteer = _leaderboard[index];
          return LeaderboardItemWidget(
            volunteer: volunteer,
            rank: index + 1,
            isCurrentUser: volunteer['name'] == 'Tú',
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: 80.h,
        child: FilterBottomSheetWidget(
          currentFilters: _filters,
          onFiltersChanged: (filters) {
            setState(() {
              _filters = filters;
            });
            _applyFilters();
          },
        ),
      ),
    );
  }

  void _toggleAvailability() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isAvailable = !_isAvailable;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAvailable
              ? 'Ahora estás disponible para oportunidades de voluntariado'
              : 'Has marcado como no disponible',
        ),
        backgroundColor: _isAvailable
            ? const Color(0xFF4A6741)
            : AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.8),
      ),
    );
  }

  Future<void> _refreshOpportunities() async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate data refresh
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Oportunidades actualizadas'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _refreshActivities() async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate data refresh
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Actividades actualizadas'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _refreshLeaderboard() async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate data refresh
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Clasificación actualizada'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _volunteerForOpportunity(Map<String, dynamic> opportunity) {
    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirmar Voluntariado',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Estás seguro de que quieres ser voluntario para:',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              opportunity['title'] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Ubicación: ${opportunity['location']}',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            Text(
              'Duración: ${opportunity['duration']}',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmVolunteering(opportunity);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _confirmVolunteering(Map<String, dynamic> opportunity) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Te has registrado como voluntario para: ${opportunity['title']}',
        ),
        backgroundColor: const Color(0xFF4A6741),
        action: SnackBarAction(
          label: 'Ver detalles',
          textColor: Colors.white,
          onPressed: () => _showOpportunityDetails(opportunity),
        ),
      ),
    );
  }

  void _saveOpportunity(Map<String, dynamic> opportunity) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${opportunity['title']} guardado en favoritos'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareOpportunity(Map<String, dynamic> opportunity) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compartiendo: ${opportunity['title']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _getDirections(Map<String, dynamic> opportunity) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abriendo direcciones a ${opportunity['location']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showOpportunityDetails(Map<String, dynamic> opportunity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
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

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      opportunity['title'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Descripción:',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      opportunity['description'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Requisitos:',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      opportunity['requirements'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Información de contacto:',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      opportunity['contactInfo'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewActivityDetails(Map<String, dynamic> activity) {
    Navigator.pushNamed(context, '/activity-details');
  }

  void _provideFeedback(Map<String, dynamic> activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Proporcionar Comentarios'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Tus comentarios',
                hintText: 'Comparte tu experiencia...',
              ),
              maxLines: 4,
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                const Text('Calificación: '),
                Expanded(
                  child: Row(
                    children: List.generate(5, (index) {
                      return CustomIconWidget(
                        iconName: 'star',
                        color: index < 4
                            ? const Color(0xFFFFD700)
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.3),
                        size: 6.w,
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Comentarios enviados. ¡Gracias por tu participación!'),
                  backgroundColor: Color(0xFF4A6741),
                ),
              );
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    // Apply filters to opportunities list
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filtros aplicados'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
