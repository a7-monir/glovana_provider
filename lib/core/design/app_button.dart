import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_theme.dart';

enum ButtonType { normal, outlined, bottomNav }

class AppButton extends StatelessWidget {
  final bool isLoading, isSecondary, withShadow,withWhitShadow;
  final ButtonType type;
  final String text;
  final Widget? titleWidget;
  final TextStyle? style;
  final double? borderRadius, height;
  final EdgeInsetsGeometry? padding;
  final Color? bgColor, textColor;
  final Color borderColor;
  final VoidCallback? onPress;

  const AppButton({
    super.key,
    this.isLoading = false,
    this.text = '',
    this.onPress,
    this.bgColor,
    this.type = ButtonType.normal,
    this.textColor,
    this.padding,
    this.titleWidget,
    this.borderRadius,
    this.height,
    this.style,
    this.isSecondary = true,
    this.withShadow = false, this.borderColor=Colors.transparent,  this.withWhitShadow=false,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.normal:
        if (isLoading) {
          return Padding(
            padding: padding ?? EdgeInsets.zero,
            child: FilledButton.icon(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor:
                    bgColor?.withValues(alpha: .3) ??
                    (isSecondary
                        ? Theme.of(context).secondaryHeaderColor
                        : Theme.of(context).primaryColor.withValues(alpha: .3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 40.r),
                ),
                fixedSize: Size.fromHeight(height ?? 43.h),
              ),
              icon: SizedBox(
                height: 20.h,
                width: 20.h,
                child: CircularProgressIndicator(strokeWidth: .8, color: bgColor),
              ),
              label: FittedBox(
                child:
                    titleWidget ??
                    Text(
                      text,
                      style:
                          style ??
                          TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                            color:
                                isSecondary
                                    ? Theme.of(context).primaryColor.withValues(alpha: .6)
                                    : textColor,
                          ),
                    ),
              ),
            ),
          );
        }
        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              boxShadow:withShadow? [
              AppTheme.mainShadow,
              if(withWhitShadow)
              AppTheme.whiteShadow,
            ]:null,
              borderRadius: BorderRadius.circular(borderRadius ?? 40.r),
            ),
            child: FilledButton(
              onPressed: onPress,
              style: FilledButton.styleFrom(
                backgroundColor: isSecondary ? Theme.of(context).secondaryHeaderColor : bgColor,
                disabledBackgroundColor: bgColor?.withValues(alpha: .32),
                side: BorderSide(
                  color: borderColor,
                  width: 1.5.w
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 40.r),

                ),
                fixedSize: Size.fromHeight(height ?? 43.h),
              ),
              child: FittedBox(
                child:
                    titleWidget ??
                    Text(
                      text,
                      style:
                          style ??
                          TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                            color: isSecondary ? Theme.of(context).primaryColor : textColor,
                          ),
                    ),
              ),
            ),
          ),
        );
      case ButtonType.outlined:
        if (isLoading) {
          return Padding(
            padding: padding ?? EdgeInsets.zero,
            child: OutlinedButton.icon(
              onPressed: null,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r)),
                backgroundColor: Colors.transparent,
                side: BorderSide(color: Theme.of(context).primaryColor.withValues(alpha: .3)),
                fixedSize: Size.fromHeight(height ?? 43.h),
              ),
              icon: SizedBox(
                height: 20.h,
                width: 20.h,
                child: CircularProgressIndicator(strokeWidth: .8, color: textColor),
              ),
              label: FittedBox(
                child:
                    titleWidget ??
                    Text(
                      text,
                      style:
                          style ??
                          TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor.withValues(alpha: .3),
                          ),
                    ),
              ),
            ),
          );
        }
        return Opacity(
          opacity: onPress == null ? .24 : 1,
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: OutlinedButton(
              onPressed: onPress,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r)),
                side: BorderSide(color:textColor?? Theme.of(context).primaryColor),
                fixedSize: Size.fromHeight(height ?? 43.h),
              ),
              child: FittedBox(
                child:
                    titleWidget ??
                    Text(
                      text,
                      style:
                          style ??
                          TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                            color: textColor ?? Theme.of(context).primaryColor,
                          ),
                    ),
              ),
            ),
          ),
        );
      case ButtonType.bottomNav:
        return Padding(
          padding:
              padding ??
              EdgeInsetsDirectional.symmetric(horizontal: 16.w).copyWith(bottom: 20.h, top: 8.h),
          child: AppButton(
            text: text,
            titleWidget: titleWidget,
            isLoading: isLoading,
            onPress: onPress,
          ),
        );
    }
  }
}
