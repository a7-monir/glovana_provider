import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../core/logic/helper_methods.dart';
import '../../../generated/locale_keys.g.dart';
import '../login/view.dart';
import '../signup/view.dart';

class HaveAccountSection extends StatelessWidget {
  final bool isLogin;

  const HaveAccountSection({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text:
                  isLogin
                      ? LocaleKeys.doNotHaveAnAccount.tr()
                      : LocaleKeys.alreadyHaveAnAccount.tr(),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).hintColor,
              ),
            ),
            TextSpan(
              text: " ${LocaleKeys.signUp.tr()}",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
              recognizer:
                  TapGestureRecognizer()
                    ..onTap = () {
                      navigateTo(isLogin ? SignupView() : LoginView(), keepHistory: false);
                    },
            ),
          ],
        ),
      ),
    );
  }
}
