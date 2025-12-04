import 'package:flutter/material.dart';
import '../app_theme.dart';

class AppRefresh extends StatelessWidget {
  final VoidCallback event;
  final Widget child;

  const AppRefresh({super.key, required this.event, required this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor:AppTheme.primary,
      color: Colors.white,
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
        event();
      },
      child: child,
    );
  }
}