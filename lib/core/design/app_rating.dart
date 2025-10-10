import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppRate extends StatelessWidget {
  final bool canEdit;
  final Function(double) onRatingUpdate;
  final double? iconSize, initialRating, paddingEnd;

  const AppRate({
    super.key,
    required this.onRatingUpdate,
    this.iconSize,
    this.initialRating,
    this.canEdit = true,
    this.paddingEnd,
  });

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      itemCount: 5,
      itemPadding: EdgeInsetsDirectional.only(end: paddingEnd ?? 1.w),
      ignoreGestures: canEdit,
      ratingWidget: RatingWidget(
        full: Icon(Icons.star, color: Colors.yellow),

        half: SizedBox.shrink(),
        empty: Icon(Icons.star, color: Theme.of(context).disabledColor),
      ),
      wrapAlignment: WrapAlignment.center,
      allowHalfRating: false,
      glow: false,
      onRatingUpdate: onRatingUpdate,
      itemSize: iconSize ?? 10.h,
      direction: Axis.horizontal,
      initialRating: initialRating ?? 3,
      minRating: 0,
      maxRating: 5,
    );
  }
}
