import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_theme.dart';
import '../logic/helper_methods.dart';

Future showMySheet({required Widget child, bool withDivider = true}) async {
  return await showModalBottomSheet(
    isScrollControlled: true,
    builder:
        (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (withDivider)
              Padding(
                padding: EdgeInsets.only(top: 21.h, bottom: 24.h),
                child: Center(
                  child: Container(
                    width: 134.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffDCDCE4),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
            child,
          ],
        ),
    backgroundColor: AppTheme.bgLightColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
    ),
    context: navigatorKey.currentContext!,
  );
}

// showLogoutSheet(BuildContext context) {
//   showMySheet(
//     child:const LogoutSheet(),
//   );
// }
// showDeleteAccountSheet(BuildContext context) {
//   showMySheet(
//     child:const DeleteAccountSheet(),
//   );
// }

// class LoginFirstSheet extends StatelessWidget {
//   const LoginFirstSheet({super.key,});
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       Padding(
//         padding: EdgeInsets.all(24.r),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               LocaleKeys.loginToTheApp.tr(),
//               style:
//               TextStyle(
//                 fontSize: 24.sp,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             Text(
//               LocaleKeys.createAProfileDiscoverServicesForACompleteExperience.tr(),
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 color: AppTheme.hintText2Color,
//               ),
//             ),
//             SizedBox(height: 24.h),
//             AppButton(
//               text: LocaleKeys.login.tr(),
//               onPress: () {
//                 navigateTo(const LoginView());
//               },
//             ),
//             SizedBox(height: 24.h),
//             Text(
//               LocaleKeys.ifYouAreANewCustomerOfHabibaStore.tr(),
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontSize: 12.sp,
//                   color: Theme.of(context).hintColor),
//             ),
//             SizedBox(height: 6.h),
//             GestureDetector(
//               onTap: () {
//                 navigateTo(const RegisterView());
//               },
//               child: Container(
//                 color: Colors.transparent,
//                 child: Text(
//                   LocaleKeys.signUpForANewAccount.tr(),
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 16.sp,
//                       color: Theme.of(context).primaryColor),
//                 ),
//               ),
//             ),
//
//           ],
//         ),
//       );
//   }
// }
