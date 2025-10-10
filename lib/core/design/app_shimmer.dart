import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../app_theme.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        //baseColor: AppTheme.warningColor,
        baseColor: AppTheme.primary.withValues(alpha: .2),
        // direction: ShimmerDirection.l,
        highlightColor: Colors.white,
        period: const Duration(seconds: 2),
        child: child);
  }
}
