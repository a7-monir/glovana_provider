import 'package:flutter/material.dart';
import '../app_theme.dart';

class AppRefresh extends StatelessWidget {
  final Future<void> Function() event;
  final Widget child;

  const AppRefresh({
    super.key,
    required this.event,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppTheme.primary,
      color: Colors.white,
      onRefresh: event,
      child: child,
    );
  }
}