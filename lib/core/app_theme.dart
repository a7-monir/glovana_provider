import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static const hintTextColor = Colors.black;
  static const secondaryHeaderColor = Color(0xffFEDCD3);
  static const greyColor = Color(0xff8D8D8D);
  static const hintText2Color = Color(0xffB2B2B2);
  static const fontFamily = "Aboreto";
  static const imageUrl = "https://glovana.net/assets/admin/uploads/";

  static final mainShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.25),
    blurRadius: 4.r,
    offset: const Offset(0, 4),
    //blurStyle: BlurStyle.
  );
  static final whiteShadow = BoxShadow(
    offset: Offset(0, -4),
    blurRadius: 20.r,
    color: Colors.white.withValues(alpha: .3),
    blurStyle: BlurStyle.inner,
  );

  // static const textColor = Colors.red;
  // static const textLightColor = Colors.red;

  static const textLightColor = Color(0xff752E2C);
  static const textDarkColor = Colors.white;
  static const subTitleColor = Color(0xff6F6F6F);
  static const borderColor = Color(0xff757575);
  static const errorColor = Color(0xffFF3D3D);
  static const warningColor = Color(0xffF5C84C);
  static const bgLightColor = Color(0xffFDF2E3);

  static const canvasColor = Color(0xffFFDAD4);
  static const hoverColor = Color(0xffFFE9D8);

  static const dividerLightColor = Color(0xffCECCDE);
  static const dividerDarkColor = Color(0xff434345);

  static const containerColor = Color(0xffFEEEE1);

  static const cardDarkColor = Color(0xff2C2C2E);
  static const cardLightColor = Color(0xffFFF0E9);

  static final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.r),
    borderSide: const BorderSide(
      color: Colors.transparent,
      // color: Color(0xffE9E9E9),
    ),
  );
  static Color primary = const Color(0xff752E2C);
  static Color onBoardingColor = const Color(0xff752E2C);

  static ThemeData get light => ThemeData(
    fontFamily: fontFamily,
    hintColor: hintTextColor.withValues(alpha: .59),
    secondaryHeaderColor: secondaryHeaderColor,
    splashColor: primary.withValues(alpha: .1),
    highlightColor: primary.withValues(alpha: .1),
    cardColor: cardLightColor,
    canvasColor: canvasColor,
    hoverColor: hoverColor,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        overlayColor: Colors.transparent,
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamily,
        ),
      ),
    ),
    scaffoldBackgroundColor: bgLightColor,
    primarySwatch: Colors.red,

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      elevation: 20,
      modalBackgroundColor: bgLightColor,
      constraints: BoxConstraints(maxWidth: double.infinity),
      surfaceTintColor: Colors.transparent,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        highlightColor: primary.withValues(alpha: .1),
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
      ),
    ),
    primaryColor: primary,
    listTileTheme: ListTileThemeData(
      horizontalTitleGap: 19.w,
      contentPadding: EdgeInsets.zero,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      error: errorColor,
    ),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: textLightColor)),
    dividerColor: primary,
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(57.r),
        side: BorderSide.none,
      ),
      side: BorderSide.none,
      disabledColor: const Color(0xffBCBCBC).withValues(alpha: .1),
    ),
    dividerTheme: DividerThemeData(
      color: primary,
      indent: 0,
      endIndent: 0,
      space: 10.h,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: _border,
      enabledBorder: _border,
      filled: true,
      fillColor: cardLightColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      hintStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
        color: hintTextColor.withValues(alpha: .59),
      ),
      floatingLabelStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
      ),
      labelStyle: TextStyle(
        fontSize: 16.sp,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: Colors.black.withValues(alpha: .33),
    ),
    tabBarTheme: TabBarThemeData(
      labelPadding: EdgeInsets.zero,
      dividerColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2.w, color: primary),
      ),
      unselectedLabelColor: primary,
      labelColor: primary,
      labelStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      backgroundColor: bgLightColor,
      selectedLabelStyle: TextStyle(
        color: const Color(0xff6C6C6C),
        height: 2,
        fontSize: 13.sp,
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: bgLightColor,
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        fontSize: 20.sp,
        fontFamily: fontFamily,
        color: textLightColor,
        fontWeight: FontWeight.w600,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      side: const BorderSide(color: Colors.transparent),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
      fillColor: WidgetStateProperty.all(const Color(0xffE8E8E8)),
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        fixedSize: Size.fromHeight(56.h),
        side: const BorderSide(color: Color(0xffD4D4D4)),
        disabledBackgroundColor: primary.withValues(alpha: .32),
        disabledForegroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.r),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        fixedSize: Size.fromHeight(52.h),
        disabledForegroundColor: Colors.white,
        textStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        disabledBackgroundColor: primary.withValues(alpha: .32),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      alignment: Alignment.center,
      surfaceTintColor: Colors.white,
    ),
  );
}
