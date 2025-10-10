import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/locale_keys.g.dart';

class WithSection extends StatelessWidget {
  final bool isLogin;
  const WithSection({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(height: 2.h)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(isLogin?LocaleKeys.loginWith.tr():LocaleKeys.signupWith.tr()),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}
