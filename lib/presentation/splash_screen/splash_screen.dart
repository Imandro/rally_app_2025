import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _progressAnimation;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  bool _isInitializing = true;
  double _initializationProgress = 0.0;
  String _currentTask = 'Inicializando servicios de emergencia...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Pulse animation for the logo
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Fade animation for screen transition
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Progress animation
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Rotation animation for loading spinner
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 6.28).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _pulseController.repeat(reverse: true);
    _fadeController.forward();
    _rotationController.repeat();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate initialization tasks with realistic timing
      await _performInitializationTask(
        'Verificando permisos de ubicación...',
        0.2,
        Duration(milliseconds: 600),
      );

      await _performInitializationTask(
        'Conectando con sensores...',
        0.4,
        Duration(milliseconds: 500),
      );

      await _performInitializationTask(
        'Cargando datos de emergencia...',
        0.6,
        Duration(milliseconds: 400),
      );

      await _performInitializationTask(
        'Sincronizando información offline...',
        0.8,
        Duration(milliseconds: 400),
      );

      await _performInitializationTask(
        'Preparando dashboard...',
        1.0,
        Duration(milliseconds: 300),
      );

      // Wait a moment before navigation
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
        _navigateToNextScreen();
      }
    } catch (e) {
      // Handle initialization errors gracefully
      if (mounted) {
        setState(() {
          _currentTask = 'Error en inicialización. Continuando...';
          _initializationProgress = 1.0;
          _isInitializing = false;
        });
        await Future.delayed(const Duration(milliseconds: 1000));
        _navigateToNextScreen();
      }
    }
  }

  Future<void> _performInitializationTask(
    String taskName,
    double progress,
    Duration duration,
  ) async {
    if (mounted) {
      setState(() {
        _currentTask = taskName;
      });
    }

    await Future.delayed(duration);

    if (mounted) {
      setState(() {
        _initializationProgress = progress;
      });
    }
  }

  void _navigateToNextScreen() {
    _fadeController.reverse().then((_) {
      if (mounted) {
        // Navigate to emergency dashboard as the main entry point
        Navigator.pushReplacementNamed(context, '/emergency-dashboard');
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style for emergency branding
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFC41E3A),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFF1a1a2e), // Deep navy emergency background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e), // Deep navy
              Color(0xFF16213e), // Darker navy
              Color(0xFF0f3460), // Emergency blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 8.h),

              // Emergency Shield Logo with Animation
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFe53e3e), // Emergency red
                      Color(0xFFc53030), // Darker red
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFe53e3e).withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_pulseAnimation.value * 0.1),
                      child: Icon(
                        Icons.shield,
                        size: 15.w,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 4.h),

              // App Title
              Text(
                'DisasterGuard',
                style: GoogleFonts.inter(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),

              SizedBox(height: 1.h),

              // Nicaragua Subtitle
              Text(
                'Nicaragua',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                  letterSpacing: 2.0,
                ),
              ),

              SizedBox(height: 6.h),

              // Loading Animation
              AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: CircularProgressIndicator(
                        color: Colors.white.withValues(alpha: 0.7),
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 3.h),

              // Loading Text
              Text(
                'Inicializando sistema de emergencias...',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.7),
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Nicaragua Emergency Info
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Protección Civil Nicaragua',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Sistema Nacional de Prevención,\nMitigación y Atención de Desastres',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.8),
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildEmergencyContact('911', 'Emergencias'),
                        _buildEmergencyContact('118', 'Policía'),
                        _buildEmergencyContact('115', 'Bomberos'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyContact(String number, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Color(0xFFe53e3e).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFe53e3e).withValues(alpha: 0.3)),
          ),
          child: Text(
            number,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}