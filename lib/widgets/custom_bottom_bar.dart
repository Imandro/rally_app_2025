import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data for bottom navigation bar
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;
  final bool isEmergency;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
    this.isEmergency = false,
  });
}

/// Custom Bottom Navigation Bar widget for emergency disaster management application
/// Adapts based on emergency status and provides location-aware navigation
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when item is tapped
  final ValueChanged<int>? onTap;

  /// Whether the app is in emergency mode
  final bool emergencyMode;

  /// Whether to show emergency pulse indicators
  final bool showCommunityPulse;

  /// Background color override
  final Color? backgroundColor;

  /// Selected item color override
  final Color? selectedItemColor;

  /// Unselected item color override
  final Color? unselectedItemColor;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.emergencyMode = false,
    this.showCommunityPulse = false,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  /// Navigation items for the bottom bar
  static const List<BottomNavItem> _navItems = [
    BottomNavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/emergency-dashboard',
      isEmergency: true,
    ),
    BottomNavItem(
      icon: Icons.map_outlined,
      activeIcon: Icons.map,
      label: 'Alert Map',
      route: '/real-time-alert-map',
      isEmergency: true,
    ),
    BottomNavItem(
      icon: Icons.report_outlined,
      activeIcon: Icons.report,
      label: 'Report',
      route: '/incident-reporting',
      isEmergency: true,
    ),
    BottomNavItem(
      icon: Icons.volunteer_activism_outlined,
      activeIcon: Icons.volunteer_activism,
      label: 'Volunteer',
      route: '/volunteer-coordination',
    ),
    BottomNavItem(
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book,
      label: 'Guide',
      route: '/emergency-response-guide',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Emergency mode colors for high contrast
    final effectiveBackgroundColor = emergencyMode
        ? const Color(0xFF1A1A1A) // High contrast dark background
        : backgroundColor ?? colorScheme.surface;

    final effectiveSelectedColor = emergencyMode
        ? const Color(0xFFC41E3A) // Emergency red
        : selectedItemColor ?? colorScheme.primary;

    final effectiveUnselectedColor = emergencyMode
        ? const Color(0xFF6B7280) // Neutral gray
        : unselectedItemColor ?? colorScheme.onSurface.withValues(alpha: 0.6);

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: emergencyMode ? 8 : 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: emergencyMode ? 72 : 64,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = currentIndex == index;
              final isEmergencyItem = item.isEmergency;

              return Expanded(
                child: _BottomNavItemWidget(
                  item: item,
                  isSelected: isSelected,
                  isEmergencyMode: emergencyMode,
                  isEmergencyItem: isEmergencyItem,
                  showCommunityPulse:
                      showCommunityPulse && item.label == 'Volunteer',
                  selectedColor: effectiveSelectedColor,
                  unselectedColor: effectiveUnselectedColor,
                  onTap: () {
                    if (onTap != null) {
                      onTap!(index);
                    }
                    Navigator.pushNamed(context, item.route);
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Individual bottom navigation item widget
class _BottomNavItemWidget extends StatefulWidget {
  final BottomNavItem item;
  final bool isSelected;
  final bool isEmergencyMode;
  final bool isEmergencyItem;
  final bool showCommunityPulse;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  const _BottomNavItemWidget({
    required this.item,
    required this.isSelected,
    required this.isEmergencyMode,
    required this.isEmergencyItem,
    required this.showCommunityPulse,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  State<_BottomNavItemWidget> createState() => _BottomNavItemWidgetState();
}

class _BottomNavItemWidgetState extends State<_BottomNavItemWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.showCommunityPulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_BottomNavItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showCommunityPulse && !oldWidget.showCommunityPulse) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.showCommunityPulse && oldWidget.showCommunityPulse) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color =
        widget.isSelected ? widget.selectedColor : widget.unselectedColor;
    final iconSize = widget.isEmergencyMode ? 28.0 : 24.0;
    final fontSize = widget.isEmergencyMode ? 12.0 : 11.0;

    Widget iconWidget = Icon(
      widget.isSelected
          ? (widget.item.activeIcon ?? widget.item.icon)
          : widget.item.icon,
      size: iconSize,
      color: color,
    );

    // Add emergency indicator for emergency items
    if (widget.isEmergencyItem && widget.isEmergencyMode) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFFB8860B), // Warning amber
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }

    // Add community pulse indicator
    if (widget.showCommunityPulse) {
      iconWidget = AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                child!,
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A6741), // Community green
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4A6741).withValues(alpha: 0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        child: iconWidget,
      );
    }

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(height: 2),
            Text(
              widget.item.label,
              style: GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight:
                    widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
