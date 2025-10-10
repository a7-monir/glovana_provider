import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/views/Appointment_history/view.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/chat_screen.dart';
import 'package:glovana_provider/views/payment_report/view.dart';
import 'package:glovana_provider/views/ratings/view.dart';

import '../../../../core/design/app_image.dart';
import '../../../../core/logic/cache_helper.dart';
import '../../../../core/logic/helper_methods.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../sheets/logout.dart';
import '../../../edit_profile/view.dart';
import '../../../wallet/view.dart';
import 'components/photo.dart';



class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              ItemPhoto(),
              SizedBox(height: 20.h),
              Text(
                CacheHelper.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 32.sp,
                  fontFamily: getFontFamily(FontFamilyType.inter),
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  CacheHelper.email,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              _ItemProfile(
                image: 'edit_user.png',
                title: LocaleKeys.editProfile.tr(),
                onTap: () {
                  navigateTo(EditProfileView());
                },
              ),
              _ItemProfile(
                image: 'wallet.png',
                title: LocaleKeys.wallet.tr(),
                onTap: () => navigateTo(WalletView()),
              ),
              _ItemProfile(
                image: 'card.png',
                title: LocaleKeys.paymentReport.tr(),
                onTap: () {
                 navigateTo(PaymentReportView());
                },
              ),
              _ItemProfile(
                image: 'shop_fill.png',
                title: LocaleKeys.ratings.tr(),
                onTap: () => navigateTo(RatingsView()),
              ),
              _ItemProfile(
                image: 'user_fill.png',
                title: LocaleKeys.providerType.tr(),
                onTap: () {
                 navigateTo(ChatScreen());
                },
              ),
              _ItemProfile(
                image: 'history.png',
                title: LocaleKeys.appointmentsHistory.tr(),
                onTap: () => navigateTo(AppointmentHistory()),
              ),
              _ItemProfile(
                image: 'about_us.png',
                title: LocaleKeys.aboutUs.tr(),
                //onTap:
                    // () => navigateTo(
                    //   StaticPageView(id: 1, title: LocaleKeys.aboutUs.tr()),
                    // ),
              ),
              _ItemProfile(
                image: 'terms.png',
                title: LocaleKeys.termsCondition.tr(),
              ),
              _ItemProfile(
                image: 'privacy.png',
                title: LocaleKeys.privacyPolicy.tr(),
              ),
              _ItemProfile(
                image: 'support.png',
                title: LocaleKeys.support.tr(),
              ),
              _ItemProfile(
                image: 'settings.png',
                title: LocaleKeys.settings.tr(),
                // onTap:
                //     () => showModalBottomSheet(
                //       context: context,
                //       builder:
                //           (context) => ChooseLanguageSheet(
                //             selectedLang: CacheHelper.lang,
                //           ),
                //     ),
              ),
              _ItemProfile(
                image: 'logout.png',
                title: LocaleKeys.logout.tr(),
                onTap:
                    () => showModalBottomSheet(
                      context: context,
                      builder: (context) => LogoutSheet(),
                    ),
                isLogout: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemProfile extends StatelessWidget {
  final String image, title;
  final bool isLogout;
  final VoidCallback? onTap;

  const _ItemProfile({
    super.key,
    required this.image,
    required this.title,
    this.isLogout = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        color: Colors.transparent,
        child: Row(
          children: [
            AppImage(
              image,
              height: 29.h,
              width: 29.h,
              color: isLogout ? Color(0xffDE0707) : Colors.black,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: isLogout ? Color(0xffDE0707) : Colors.black,
                  fontFamily: getFontFamily(FontFamilyType.inter),
                ),
              ),
            ),
            Transform.rotate(
              angle: CacheHelper.lang == 'ar' ? pi : 0,
              child: AppImage(
                'arrow_right.png',
                height: 29.h,
                width: 29.h,
                color: isLogout ? Color(0xffDE0707) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
