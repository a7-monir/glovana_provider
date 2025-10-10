// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:habiba_store/core/app_theme.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
//
// class CustomPinCode extends StatelessWidget {
//   final TextEditingController? controller;
//   final void Function(String)? onCompleted;
//
//   const CustomPinCode({super.key, this.controller, this.onCompleted});
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: PinCodeTextField(
//         appContext: context,
//         autoFocus: true,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         pastedTextStyle: const TextStyle(fontWeight: FontWeight.bold),
//         length: 4,
//         hintCharacter: '-',
//         controller: controller,
//         obscureText: false,
//         validator: (value) => value?.length != 4 ? '' : null,
//         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//         hintStyle: TextStyle(
//           color: AppTheme.hintText2Color,
//           fontSize: 20.sp,
//           fontWeight: FontWeight.w500,
//         ),
//         textStyle: TextStyle(
//             fontSize: 20.sp,
//             fontWeight: FontWeight.w500,
//             color: Theme.of(context).primaryColor),
//         animationType: AnimationType.fade,
//
//         pinTheme: PinTheme(
//           activeColor: const Color(0xffF7F7F7),
//           selectedColor: Theme.of(context).primaryColor,
//           activeFillColor: Colors.white,
//           borderWidth: 1.r,
//           // activeFillColor: context.theme.scaffoldBackgroundColor,
//           selectedFillColor: Theme.of(context).scaffoldBackgroundColor,
//           inactiveColor: Theme.of(context).cardColor,
//           inactiveFillColor: Theme.of(context).scaffoldBackgroundColor,
//           shape: PinCodeFieldShape.box,
//           borderRadius: BorderRadius.circular(10.r),
//           fieldHeight: 50.w,
//           fieldWidth: 50.w,
//           disabledColor: Colors.red
//         ),
//         cursorColor: Colors.black,
//         animationDuration: const Duration(milliseconds: 300),
//         enableActiveFill: true,
//         autovalidateMode: AutovalidateMode.always,
//         keyboardType: TextInputType.number,
//         animationCurve: Curves.easeInOutQuad,
//         enablePinAutofill: true,
//         useExternalAutoFillGroup: true,
//         onChanged: (value) {},
//         onCompleted: onCompleted,
//         beforeTextPaste: (text) {
//           return false;
//         },
//       ),
//     );
//   }
// }
