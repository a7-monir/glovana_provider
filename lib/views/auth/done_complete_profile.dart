import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_button.dart';

import 'package:glovana_provider/core/logic/cache_helper.dart';
import 'package:glovana_provider/views/auth/login/view.dart';

import '../../core/design/app_image.dart';
import '../../core/logic/helper_methods.dart';
import '../../generated/locale_keys.g.dart';

class DoneCompleteProfileView extends StatefulWidget {
  const DoneCompleteProfileView({super.key});

  @override
  State<DoneCompleteProfileView> createState() => _DoneCompleteProfileViewState();
}

class _DoneCompleteProfileViewState extends State<DoneCompleteProfileView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          AppImage('background.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,

          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(LocaleKeys.yourApplicationIsBeingProcessed.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.w400,


            ),
            ),
          ),
          Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: AppButton(
                    text: LocaleKeys.confirm.tr(),
                    type: ButtonType.bottomNav,
                    onPress: () {
                      navigateTo(const LoginView(), keepHistory: false);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),

    );
  }
}
