import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_theme.dart';
import '../logic/cache_helper.dart';
import 'app_circle_icon.dart';
import 'app_image.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool centerTitle, withBack,withDivider;
  final VoidCallback? onBackPress;
  final List<Widget>? actions;
  final Widget? leadingIcon;
  final Widget? titleWidget;
  final double? leadingWidth, titleSpacing;
  final TextStyle? textStyle;
  final Color? backColor, backgroundColor,shadowColor;

  const MainAppBar({
    super.key,
    this.title,
    this.centerTitle = true,
    this.textStyle,
    this.onBackPress,
    this.leadingIcon,
    this.titleWidget,
    this.actions,
    this.leadingWidth,
    this.titleSpacing,
    this.withBack = true,
    this.backColor,
    this.backgroundColor, this.shadowColor,  this.withDivider=false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shadowColor: Colors.transparent,
      backgroundColor: backgroundColor ?? (shadowColor!=null?Theme.of(context).scaffoldBackgroundColor:Colors.transparent),
      elevation: shadowColor!=null?1:0,
      bottom:withDivider? PreferredSize(preferredSize: preferredSize, child: Divider(height: 2.h,color: Colors.black.withValues(alpha: .25),)):null,
      leadingWidth: leadingWidth ?? (withBack ? 56.w : 16.w),
      titleSpacing: titleSpacing ?? (withBack ? 8.w : 24.w),
      toolbarHeight: 90.h,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      actions: actions ?? [],
      leading: leadingIcon ?? (withBack ? CustomBackIcon(backColor: backColor) : null),
      title:
          titleWidget ??
          Text(title??'', style: textStyle ?? TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w400)),
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}

class SecondAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle, withBack;
  final VoidCallback? onBackPress;
  final List<Widget>? actions;
  final Widget? leadingIcon;
  final Widget? titleWidget;
  final double? leadingWidth, titleSpacing;
  final TextStyle? textStyle;
  final Color? backColor, backgroundColor;

  const SecondAppBar({
    super.key,
    this.title='',
    this.centerTitle = true,
    this.textStyle,
    this.onBackPress,
    this.leadingIcon,
    this.titleWidget,
    this.actions,
    this.leadingWidth,
    this.titleSpacing,
    this.withBack = true,
    this.backColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shadowColor: Colors.transparent,
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leadingWidth: leadingWidth ?? (withBack ? 56.w : 16.w),
      titleSpacing: titleSpacing ?? (withBack ? 8.w : 24.w),
      toolbarHeight: 90.h,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      actions: actions ?? [],
      leading:
          leadingIcon ??
          (withBack
              ? CustomBackIcon(
                backColor: Theme.of(context).primaryColor,
                circleColor: AppTheme.containerColor,
              )
              : null),
      title:
          titleWidget ??
          Text(title, style: textStyle ?? TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700)),
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}

class CustomBackIcon extends StatelessWidget {
  final VoidCallback? onBackPress;
  final double? size;
  final Color? backColor, circleColor;
  final double? paddingStart;

  const CustomBackIcon({
    super.key,
    this.onBackPress,
    this.size,
    this.paddingStart,
    this.backColor,
    this.circleColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onBackPress != null) {
          onBackPress!();
        } else {
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: paddingStart ?? 16.w),
        child: AppCircleIcon(
          img: 'arrow_back.png',
          bgColor: circleColor ?? Theme.of(context).canvasColor,
          bgRadius: 36.h,
          radius: 24.r,
          iconColor: Theme.of(context).primaryColor,

          // child: Transform.rotate(
          //     angle: CacheHelper.lang == 'ar' ? 0 : pi,
          //     child: AppImage('arrow_right.svg',height: size??20.h,width: size??20.h,color: backColor?? Colors.white,)),
        ),
      ),
    );
  }
}
