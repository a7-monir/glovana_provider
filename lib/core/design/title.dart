import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../generated/locale_keys.g.dart';
import '../logic/helper_methods.dart';
class CustomTitle extends StatelessWidget {
  final String? text;
  final Widget? textWidget;
  final VoidCallback? onAllTap;

  const CustomTitle({super.key,  this.text, this.onAllTap, this.textWidget});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if(text!=null)
        Text(
          text!,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700
          ),
        ),
        if(textWidget!=null)
          textWidget!,
        if (onAllTap != null)
          GestureDetector(
            onTap: onAllTap,
            child: IntrinsicWidth(
              child: Column(
                children: [
                  Text(
                    LocaleKeys.seeAll.tr(),
                    style: TextStyle(
                        fontSize: 14.sp,
                      height: .8.h,
                      fontWeight: FontWeight.w200,
                      fontFamily: getFontFamily(FontFamilyType.lateef),
                    ),
                  ),
                  Container(
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor
                    ),
                  )
                ],
              ),
            ),
          )
      ],
    );
  }
}
