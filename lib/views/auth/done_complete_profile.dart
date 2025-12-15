import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_button.dart';

import 'package:glovana_provider/core/logic/cache_helper.dart';
import 'package:glovana_provider/views/auth/login/view.dart';
import 'package:glovana_provider/views/provider_type/view.dart';

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
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            AppImage('background.png',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,

            ),
           if(CacheHelper.activate==2)...[
             Padding(
               padding:  EdgeInsets.symmetric(horizontal: 24.w),
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                   Text(CacheHelper.banReason,
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       fontSize: 25.sp,
                       fontWeight: FontWeight.w400,


                     ),
                   ),
                   Text(CacheHelper.banDescription,
                     textAlign: TextAlign.center,
                     style: TextStyle(
                         fontSize: 18.sp,
                         fontWeight: FontWeight.w400,
                         color: Theme.of(context).hintColor,
                         fontFamily: getFontFamily(FontFamilyType.inter)


                     ),
                   ),
                   SizedBox(height: 4.h),
                   // Text("${LocaleKeys.from.tr()}: ${DateFormat("dd MMM y At ").add_jm().format(DateTime.parse(CacheHelper.bannedAt))}",
                   //   textAlign: TextAlign.center,
                   //   style: TextStyle(
                   //       fontSize: 14.sp,
                   //       fontWeight: FontWeight.w400,
                   //       color: Theme.of(context).hintColor,
                   //       fontFamily: getFontFamily(FontFamilyType.inter)
                   //
                   //
                   //   ),
                   // ),
                   // SizedBox(height: 4.h),
                   // Text("${LocaleKeys.to.tr()}: ${DateFormat("dd MMM y At ").add_jm().format(DateTime.parse(CacheHelper.banUntil))}",
                   //   textAlign: TextAlign.center,
                   //   style: TextStyle(
                   //       fontSize: 14.sp,
                   //       fontWeight: FontWeight.w400,
                   //       color: Theme.of(context).hintColor,
                   //       fontFamily: getFontFamily(FontFamilyType.inter)
                   //
                   //
                   //   ),
                   // ),
                   SizedBox(height: 24.h),
                   Text(CacheHelper.activate.toString()),
                   AppButton(
                     text: LocaleKeys.tryAgain.tr(),
                     onPress: () {
                       CacheHelper.logOut();
                       navigateTo(const LoginView(), keepHistory: false);
                     },
                   ),
                 ],
               ),
             ),

           ]else...[
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
               child: Padding(
                 padding:  EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 16.h),
                 child: Row(
                   children: [
                     Expanded(
                       child: AppButton(
                         text: LocaleKeys.logout.tr(),
                         onPress: () {
                           CacheHelper.logOut();
                           navigateTo(const LoginView(), keepHistory: false);
                         },
                       ),
                     ),
                     SizedBox(width: 16.w),
                     Expanded(
                       child: AppButton(
                         text: CacheHelper.lang == 'en' ? 'edit' : 'تعديل',
                         type: ButtonType.outlined,
                         onPress: () {
                           navigateTo(const ProviderTypeView());
                         },
                       ),
                     ),
                   ],
                 ),
               ),
             )
           ]

          ],
        ),
      ),

    );
  }
}
