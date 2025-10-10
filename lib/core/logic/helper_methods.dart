import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

Future openUrl(url) async {
  try {
    if (!await launchUrl(
      Uri.parse(url),
      mode:
          Platform.isAndroid
              ? LaunchMode.externalNonBrowserApplication
              : LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true,
        enableDomStorage: true,
      ),
    )) {
      showMessage("LocaleKeys.someThingWrongWithUrl.tr()");
    }
  } catch (ex) {
    showMessage("LocaleKeys.someThingWrongWithUrl.tr()");
  }
}

Future<SignInResultGoogle?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      showMessage('❗️User cancelled the sign-in');
      print('❗️User cancelled the sign-in');
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );

    return SignInResultGoogle(googleUser: googleUser, googleAuth: googleAuth);
  } catch (e, stack) {
    showMessage('❌ Sign-in error: $e');
    print('❌ Sign-in error: $e');
    print(stack);
    return null;
  }
}

Future<SignInResultApple?> signInWithApple() async {
  try {
    final appleAuth = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleAuth.identityToken,
      accessToken: appleAuth.authorizationCode,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      oauthCredential,
    );

    return SignInResultApple(
      appleCredential: userCredential,
      appleAuth: appleAuth,
    );
  } catch (e, stack) {
    print('❌ Apple sign-in error: $e');
    print(stack);
    return null;
  }
}

class SignInResultGoogle {
  final GoogleSignInAccount googleUser;
  final GoogleSignInAuthentication googleAuth;

  SignInResultGoogle({required this.googleUser, required this.googleAuth});
}

class SignInResultApple {
  final dynamic appleCredential;
  final AuthorizationCredentialAppleID appleAuth;

  SignInResultApple({required this.appleCredential, required this.appleAuth});
}
// Future<void> loginFirstThenGo(VoidCallback onSuccess) async {
//   if (CacheHelper.isAuthed) {
//     onSuccess();
//   } else {
//     await showModalBottomSheet(
//       context: navigatorKey.currentContext!,
//       builder: (context) => const LoginFirstSheet(),
//     );
//   }
// }

enum FontFamilyType { aboreto, lateef, inter, abhayaLibre }

String getFontFamily(FontFamilyType fontFamilyType) {
  return fontFamilyType == FontFamilyType.lateef
      ? "Lateef"
      : fontFamilyType == FontFamilyType.inter
      ? "Inter"
      : fontFamilyType == FontFamilyType.abhayaLibre
      ? "AbhayaLibre"
      : 'Aboreto';
}

Future<CustomPosition> getCurrentLocation() async {
  try {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print("serviceEnabled $serviceEnabled");
    if (!serviceEnabled) {
      showMessage('Location services are disabled.');
      await Geolocator.openLocationSettings();
      // showDialog(context: navigatorKey.currentContext!, builder: (context) => ,);
      return CustomPosition(
        msg: 'Location services are disabled.',
        success: false,
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print('11111111111111');
      // permission = await Geolocator.checkPermission();
      // await Geolocator.openLocationSettings();
      // permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showMessage('Location services are denied.');
        print('2222222222222222222222');
        permission = await Geolocator.requestPermission();
        return CustomPosition(
          msg: 'Location permissions are denied.',
          success: false,
        );
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print('33333333333333333333');
      showMessage(
        'Location permissions are permanently denied, we cannot request permissions.',
      );

      return CustomPosition(
        msg:
            'Location permissions are permanently denied, we cannot request permissions.',
        success: false,
      );
    }
    final position = await Geolocator.getCurrentPosition();
    print(position.toJson().toString());

    return CustomPosition(msg: '', success: true, position: position);
  } catch (e) {
    showMessage(e.toString());
    return CustomPosition(msg: e.toString(), success: false);
  }
}

class CustomPosition {
  final Position? position;
  final String msg;
  final bool success;

  LatLng? get latLang {
    if (position != null) {
      return LatLng(position!.latitude, position!.longitude);
    }
    return null;
  }

  CustomPosition({required this.msg, required this.success, this.position});
}

final navigatorKey = GlobalKey<NavigatorState>();

Future navigateTo(
  Widget page, {
  bool keepHistory = true,
  bool replacement = false,
}) async {
  final route = PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
  if (replacement) {
    return await Navigator.pushReplacement(navigatorKey.currentContext!, route);
  } else {
    return await Navigator.pushAndRemoveUntil(
      navigatorKey.currentContext!,
      route,
      (route) => keepHistory,
    );
  }
}

num handelPrice(dynamic value) {
  if (value is String) {
    return num.parse(value);
  } else {
    return value;
  }
}

Future openWhatsApp(String phone) async {
  final androidUrl = 'whatsapp://send?phone=$phone';
  final iosUrl = 'https://wa.me/$phone?';

  try {
    if (Platform.isIOS) {
      await launchUrl(Uri.parse(iosUrl));
    } else {
      await launchUrl(Uri.parse(androidUrl));
    }
  } on Exception {
    showMessage('WhatsApp is not installed.');
  }
}

Future callPhone(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  await launchUrl(launchUri);
}

enum MessageType { success, fail, warning }

void showMessage(
  String msg, {
  int duration = 2,
  MessageType type = MessageType.fail,
  bool withPadding = true,
}) async {
  if (msg.isNotEmpty) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).clearSnackBars();
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(
          horizontal: withPadding ? 20.w : 0,
          vertical: 20.h,
        ),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        elevation: 0,
        backgroundColor: getBgColor(type),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.r)),
        content: Row(
          children: [
            Expanded(
              child: Text(
                msg,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                softWrap: true,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontFamily: getFontFamily(FontFamilyType.inter),
                ),
              ),
            ),
            // Container(
            //   height: 24.h,
            //   width: 24.h,
            //   padding: EdgeInsets.all(5.r),
            //   decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            //   child: AppImage(
            //     getToastIcon(type),
            //     height: 19.h,
            //     width: 24.h,
            //     color: getBgColor(type),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

DateTime? currentBackPressTime;

Future<void> closePage(String message) async {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
    currentBackPressTime = now;
    ScaffoldMessenger.of(navigatorKey.currentContext!).clearSnackBars();
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        elevation: 0,
        content: Text(message, style: const TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xffE3E3EC),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } else {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}

Color getBgColor(MessageType msgType) {
  return msgType == MessageType.success
      ? const Color(0xff53A653)
      : msgType == MessageType.warning
      ? const Color(0xffEEA621)
      : const Color(0xffEF233C);
}

String getToastIcon(MessageType msgType) {
  return msgType == MessageType.success
      ? "check.svg"
      : msgType == MessageType.warning
      ? "warning.svg"
      : "danger.svg";
}

Future showPermissions({
  String? content,
  required void Function()? onPressed,
}) async {
  await showDialog(
    builder:
        (context) => AlertDialog(
          title: Text("LocaleKeys.appName.tr()"),
          content: Text(content!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          actions: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide.none,
                    ),
                    textStyle: TextStyle(fontSize: 17.sp),
                  ),
                  child: Text("LocaleKeys.accept.tr()"),
                ),
                SizedBox(width: 10.w),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text("LocaleKeys.cancel.tr()"),
                ),
              ],
            ),
          ],
        ),
    context: navigatorKey.currentContext!,
  );
}

List<double> saturationAdjustMatrix(double value) {
  value = value * 100;

  if (value == 0) {
    return [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
  }

  double x =
      ((1 + ((value > 0) ? ((3 * value) / 100) : (value / 100)))).toDouble();
  double lumR = 0.3086;
  double lumG = 0.6094;
  double lumB = 0.082;

  return List<double>.from(<double>[
    (lumR * (1 - x)) + x,
    lumG * (1 - x),
    lumB * (1 - x),
    0,
    0,
    lumR * (1 - x),
    (lumG * (1 - x)) + x,
    lumB * (1 - x),
    0,
    0,
    lumR * (1 - x),
    lumG * (1 - x),
    (lumB * (1 - x)) + x,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]).map((i) => i.toDouble()).toList();
}
