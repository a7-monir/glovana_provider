import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/responsive.dart';

import '../../core/app_theme.dart';
import 'app_bar.dart';

class BaseSheet extends StatelessWidget {
  final String title;
  final Widget child;

  final String? hint;
  final TextStyle? titleStyle;
  final bool isTitleRed, isBigTitle,withGradient;
  final double? marginBottom, maxHeight, paddingHorizontal;

  const BaseSheet({
    super.key,
    required this.title,
    required this.child,
    this.hint,
    this.isTitleRed = false,
    this.marginBottom,
    this.titleStyle,
    this.isBigTitle = true,
    this.maxHeight,
    this.paddingHorizontal,  this.withGradient=true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(37.r),
          gradient: withGradient?LinearGradient(
            begin:AlignmentDirectional.topCenter,
            end:AlignmentDirectional.bottomCenter,
            colors: [
              Color(0xffFDF2E3),
              Color(0xffFDF2E3),
              Color(0xffFFDADA),
            ]):null
        ),
        padding: EdgeInsets.symmetric(horizontal:paddingHorizontal?? 24.w).copyWith(
          top: 4.h,
          bottom: marginBottom ?? 16.h,
        ),
        constraints:
        BoxConstraints(
    maxHeight:
            Responsive.isTablet(context)
            ? MediaQuery.of(context).size.height / 1.3
            : (maxHeight ?? MediaQuery.of(context).size.height / 1.6),),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5.h,
              width: 36.w,
              decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: .32),
                  borderRadius: BorderRadius.circular(4.r)),
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (title.isNotEmpty)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: paddingHorizontal!=null?24.w:0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Theme.of(context).bottomSheetTheme.backgroundColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 24.h),
                        child: Row(
                        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomBackIcon(paddingStart: 0,),
                            Flexible(
                              child: Center(
                                child: FittedBox(
                                  child: Text(
                                    title,
                                    style: titleStyle ??
                                        (isBigTitle
                                            ? TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w700,
                                          color: isTitleRed
                                              ? Theme.of(context).colorScheme.error
                                              : null,
                                        )
                                            : TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: isTitleRed
                                              ? Theme.of(context).colorScheme.error
                                              : null,
                                        )),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  if (hint != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal!=null?24.w:0),
                      child: Text(
                        hint!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                  SizedBox(height: hint != null ? 24.h : 12.h),
                  Flexible(child: child)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


