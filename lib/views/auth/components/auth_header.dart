import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/locale_keys.g.dart';
import '../login/view.dart';

class AuthHeader extends StatelessWidget {
  final bool  isLogin;
  const AuthHeader({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        SizedBox(height: 32.h),
        Text(
          LocaleKeys.welcome.tr(),
          style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 12.h),
        Text(
          LocaleKeys.youAreJoiningOneOfTheBestApps.tr(),
          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 20.h),
        SwitchButtonSection(isLogin: isLogin),
      ],
    );
  }
}
