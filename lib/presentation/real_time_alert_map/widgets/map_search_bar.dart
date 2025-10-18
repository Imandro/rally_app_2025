import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final Function(String)? onSearch;
  final VoidCallback? onMenuTap;

  const MapSearchBar({
    super.key,
    this.hintText = 'Buscar ubicación...',
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.onSearch,
    this.onMenuTap,
  });

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  late TextEditingController _controller;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _controller.clear();
        widget.onChanged?.call('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                widget.onChanged?.call(value);
                widget.onSearch?.call(value);
              },
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  size: 20.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
              style: theme.textTheme.bodyMedium,
            ),
          ),
          if (_isSearching)
            IconButton(
              onPressed: _toggleSearch,
              icon: Icon(
                Icons.clear,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                size: 20.sp,
              ),
            )
          else if (widget.onMenuTap != null)
            IconButton(
              onPressed: widget.onMenuTap,
              icon: Icon(
                Icons.menu,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                size: 20.sp,
              ),
            ),
        ],
      ),
    );
  }
}
