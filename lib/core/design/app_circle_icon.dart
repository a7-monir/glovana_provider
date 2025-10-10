import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_image.dart';

class AppCircleIcon extends StatelessWidget {
  final String img;
  final bool isFromNetwork;
  final double? radius,borderRadius,bgRadius;
  final Color? iconColor,bgColor;
  final  BoxFit fit;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const AppCircleIcon({super.key, required this.img,this.fit=BoxFit.scaleDown, this.radius, this.iconColor, this.bgColor, this.borderRadius, this.bgRadius,  this.isFromNetwork=false, this.boxShadow, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height:bgRadius?? (radius!=null?radius!*2 : 48.h),
        width: bgRadius?? (radius!=null?radius!*2 : 48.h),
        decoration: BoxDecoration(
            color: bgColor??Theme.of(context).canvasColor,
            borderRadius:borderRadius!=null? BorderRadius.circular(borderRadius!):null,
            shape: borderRadius != null ? BoxShape.rectangle : BoxShape.circle,
            boxShadow: boxShadow
        ),
        alignment: Alignment.center,
        child: AppImage(
          img,
          height: radius ?? 24.h,
          width: radius ?? 24.h,
          color: iconColor ,
          fit: fit,
        ),
      ),
    );
  }
}
