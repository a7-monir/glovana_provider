
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../generated/locale_keys.g.dart';
import '../app_theme.dart';
import '../logic/dio_helper.dart';
import '../logic/helper_methods.dart';
import 'app_button.dart';
import 'app_image.dart';

class AppFailed extends StatelessWidget {
  final VoidCallback onPress;
  final CustomResponse? response;
  final String msg;
  final bool isScrollable;
  final bool isSmallShape, withPaddingHorizontal;
  final String? description;

  const AppFailed({
    super.key,
     this.response,
    required this.onPress,
    this.description,
    this.isScrollable = false,
    this.isSmallShape = false,
    this.withPaddingHorizontal = true,
    this.msg = "",
  });

  Widget get image => ClipOval(
    child: AppImage(
      (response?.msg ?? msg).toLowerCase().contains("no internet") ? "no_internet.svg" : "failed.svg",
      height: isSmallShape ? 56.h : 240.h,
      width: isSmallShape ? 56.h : 240.h,
      fit: BoxFit.fill,
      color: Theme.of(navigatorKey.currentContext!).primaryColor,
    ),
  );

  Widget get texts => Column(
    crossAxisAlignment: isSmallShape ? CrossAxisAlignment.start : CrossAxisAlignment.center,
    children: [
      Text(
        response?.msg ?? msg,
        textAlign: isSmallShape ? TextAlign.start : TextAlign.center,
        style: TextStyle(
          fontSize: isSmallShape ? 16.sp : 20.sp,
          fontWeight: FontWeight.w600,
          // color: Theme.of(context).primaryColor,
        ),
      ),
      if ((description != null || (response?.msg ?? msg).toLowerCase().contains("no internet") && !isSmallShape))
        Padding(
          padding: EdgeInsets.only(bottom: 16.h, top: isSmallShape ? 4.h : 8.h),
          child: Text(
            description ?? LocaleKeys.noInternetConnectionFound.tr(),
            textAlign: isSmallShape ? TextAlign.start : TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.hintText2Color,
            ),
          ),
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: isScrollable ? null : const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isSmallShape ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
          children: [
            if (isSmallShape)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: withPaddingHorizontal ? 24.w : 0),
                child: Row(
                  children: [
                    image,
                    SizedBox(width: 16.h),
                    Expanded(child: texts),
                    IconButton(
                      onPressed: onPress,
                      icon: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                        child: Icon(
                          Icons.replay,
                          color: Colors.white,
                          size: 20.r,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            if (!isSmallShape)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  image,
                  SizedBox(height: 16.h),
                  texts,
                ],
              ),
            if (!isSmallShape)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 16.h),
                child: AppButton(
                  text: LocaleKeys.tryAgain.tr(),
                  onPress: onPress,
                ),
              )
          ],
        ),
      ),
    );
  }
}
