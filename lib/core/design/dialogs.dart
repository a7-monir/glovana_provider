import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/locale_keys.g.dart';
import '../app_theme.dart';
import '../logic/helper_methods.dart';
import 'app_button.dart';
import 'app_circle_icon.dart';
import 'app_image.dart';

Future showMyDialog({required Widget child, bool isDismissible = true}) async {
  return await showDialog(
    barrierDismissible: isDismissible,
    builder: (context) => SimpleDialog(
        elevation: 0,
        backgroundColor: AppTheme.bgLightColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
        children: [child]),
    context: navigatorKey.currentContext!,
  );
}
//
// class SuccessfullyDialog extends StatefulWidget {
//
//   const SuccessfullyDialog(
//       {super.key,});
//
//   @override
//   State<SuccessfullyDialog> createState() => _SuccessfullyDialogState();
// }
//
// class _SuccessfullyDialogState extends State<SuccessfullyDialog> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(
//       Duration(seconds: 2),
//           () {
//         navigateTo(const HomeNavView(), keepHistory: false);
//       },
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(LocaleKeys.yourOrderIsComplete.tr(),
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 36.sp,
//             fontWeight: FontWeight.w400,
//
//           ),
//         ),
//         SizedBox(height: 17.h),
//         Text(LocaleKeys.thankYouForChoosingGlovana.tr(),
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w400,
//
//           ),
//         ),
//         AppImage('done.png',height: 122.h,width: 122.h,),
//
//
//       ],
//     );
//   }
// }






// showSuccessDialog(BuildContext context,{required String title,
//   required String des,
//   VoidCallback? onBackTap
// }) {
//   showMyDialog(
//     child: SuccessfullyDialog(
//       title: title,
//       desc:
//           des,
//       child: AppButton(text: "LocaleKeys.back.tr()",onPress:onBackTap?? (){
//         Navigator.pop(context);
//       },
//         type: ButtonType.outlined,
//         bgColor: Theme.of(context).scaffoldBackgroundColor,
//       ),
//     ),
//   );
// }

