// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../app_theme.dart';
// import 'app_image.dart';
//
// class ItemRate extends StatelessWidget {
//   final Function(double) onRatingUpdate;
//   final double? iconSize,initialRating;
//
//   const ItemRate({super.key, required this.onRatingUpdate, this.iconSize, this.initialRating});
//
//   @override
//   Widget build(BuildContext context) {
//     return RatingBar.builder(
//       itemCount: 5,
//       itemPadding: EdgeInsetsDirectional.only(end: 12.w),
//       itemBuilder: (context, index) => const AppImage('star_active.svg',
//         color: Color(0xffFF8C19),
//       ),
//       unratedColor: const Color(0xffF5F5F5),
//       glow: false,
//       onRatingUpdate:onRatingUpdate,
//       itemSize:iconSize?? 12.h,
//       allowHalfRating: true,
//       direction: Axis.horizontal,
//       initialRating: initialRating??3,
//       minRating: 0,
//       maxRating: 5,
//     );
//   }
// }
