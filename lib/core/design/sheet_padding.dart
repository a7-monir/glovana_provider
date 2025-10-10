import 'package:flutter/material.dart';

class SheetsPadding extends StatelessWidget {
  final Widget? child;

  const SheetsPadding({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}