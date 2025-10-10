import 'package:flutter/material.dart';

class PaginationBodyView extends StatelessWidget {
  final Widget child;
  final VoidCallback onLoading;
  final bool haveNext, isGetPreviousSuccess;

  const PaginationBodyView(
      {Key? key,
      required this.child,
      required this.onLoading,
      required this.haveNext,
      required this.isGetPreviousSuccess})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification sn) {
        if (haveNext &&
            sn is ScrollUpdateNotification &&
            sn.metrics.pixels == sn.metrics.maxScrollExtent &&
            sn.metrics.axisDirection == AxisDirection.down &&
            isGetPreviousSuccess) {
          onLoading();
        }
        return true;
      },
      child: child,
    );
  }
}
