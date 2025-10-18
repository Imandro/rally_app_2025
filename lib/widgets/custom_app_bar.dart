import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget for emergency disaster management application
/// Provides consistent navigation and emergency-focused functionality
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Whether to show the back button (defaults to true if canPop is true)
  final bool showBackButton;

  /// Custom leading widget (overrides showBackButton if provided)
  final Widget? leading;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Whether to show emergency alert indicator
  final bool showEmergencyIndicator;

  /// Background color override (uses theme primary color if null)
  final Color? backgroundColor;

  /// Text color override (uses theme onPrimary color if null)
  final Color? foregroundColor;

  /// Elevation override (uses theme elevation if null)
  final double? elevation;

  /// Whether this app bar is in emergency mode (high contrast, simplified)
  final bool emergencyMode;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.leading,
    this.actions,
    this.showEmergencyIndicator = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.emergencyMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canPop = Navigator.of(context).canPop();

    // Emergency mode colors for high contrast
    final effectiveBackgroundColor = emergencyMode
        ? const Color(0xFFC41E3A) // Emergency red
        : backgroundColor ?? colorScheme.primary;

    final effectiveForegroundColor =
        emergencyMode ? Colors.white : foregroundColor ?? colorScheme.onPrimary;

    return AppBar(
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: emergencyMode ? 22 : 20,
                fontWeight: emergencyMode ? FontWeight.w700 : FontWeight.w600,
                color: effectiveForegroundColor,
                letterSpacing: 0.15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (showEmergencyIndicator) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: emergencyMode
                    ? Colors.white
                    : const Color(0xFFB8860B), // Warning amber
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
      leading: leading ??
          (canPop && showBackButton
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: effectiveForegroundColor,
                    size: emergencyMode ? 28 : 24,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                )
              : null),
      actions: [
        ...?actions,
        // Emergency quick access button
        if (emergencyMode)
          IconButton(
            icon: Icon(
              Icons.emergency,
              color: effectiveForegroundColor,
              size: 28,
            ),
            onPressed: () =>
                Navigator.pushNamed(context, '/emergency-dashboard'),
            tooltip: 'Emergency Dashboard',
          ),
        // Location-aware navigation button
        IconButton(
          icon: Icon(
            Icons.location_on,
            color: effectiveForegroundColor,
            size: emergencyMode ? 28 : 24,
          ),
          onPressed: () => Navigator.pushNamed(context, '/real-time-alert-map'),
          tooltip: 'Alert Map',
        ),
        const SizedBox(width: 8),
      ],
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: elevation ?? (emergencyMode ? 4.0 : 2.0),
      centerTitle: false,
      automaticallyImplyLeading: false,
      titleSpacing: leading == null && (!canPop || !showBackButton) ? 16 : 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(emergencyMode ? 64.0 : 56.0);

  /// Factory constructor for emergency mode app bar
  factory CustomAppBar.emergency({
    Key? key,
    required String title,
    bool showBackButton = true,
    Widget? leading,
    List<Widget>? actions,
    bool showEmergencyIndicator = true,
  }) {
    return CustomAppBar(
      key: key,
      title: title,
      showBackButton: showBackButton,
      leading: leading,
      actions: actions,
      showEmergencyIndicator: showEmergencyIndicator,
      emergencyMode: true,
    );
  }

  /// Factory constructor for community features app bar
  factory CustomAppBar.community({
    Key? key,
    required String title,
    bool showBackButton = true,
    Widget? leading,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: title,
      showBackButton: showBackButton,
      leading: leading,
      actions: actions,
      backgroundColor: const Color(0xFF4A6741), // Community warm green
      foregroundColor: Colors.white,
    );
  }
}
