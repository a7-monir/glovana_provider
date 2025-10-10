import 'package:flutter/material.dart';

class UnFocus extends StatelessWidget {
  final Widget? child;

  const UnFocus({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
