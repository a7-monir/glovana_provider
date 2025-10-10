import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../generated/locale_keys.g.dart';
import '../app_theme.dart';

class AppEmpty extends StatelessWidget {
  final String? image;
  final String? title, hint;
  final bool withButton;

  const AppEmpty({
    super.key,
    this.image,
    this.title,
    this.hint,
    this.withButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AppImage(
          //   image,
          //   height: 130.h,
          //   width: 130.h,
          //   fit: BoxFit.fill,
          //   // color: Colors.red,
          //  // color: Theme.of(context).primaryColor,
          // ),
          // SizedBox(height: 16.h),
          // if(title!=null)
          Text(
            LocaleKeys.noDataTitle.tr(namedArgs: {'name': title!}),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.primary,
            ),
          ),
          // if(hint!=null)
          // Padding(
          //   padding:  EdgeInsets.only(top: 8.h),
          //   child: Text(
          //     hint!,
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       fontSize: 12.sp,
          //       fontWeight: FontWeight.w500,
          //       color:AppTheme.greyColor,
          //     ),
          //   ),
          // ),
          // SizedBox(height: 22.h),
          // if(withButton)
          // AppButton(
          //   text: LocaleKeys.addProducts.tr(),
          //   height: 28.h,
          //   style: TextStyle(
          //     fontWeight: FontWeight.w400,
          //     fontSize: 12.sp
          //   ),
          //   borderRadius: 20.r,
          //   onPress: (){
          //     //navigateTo(HomeNavView(pageIndex: 1,));
          //   },
          // )
        ],
      ),
    );
  }
}
