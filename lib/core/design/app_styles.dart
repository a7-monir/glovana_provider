import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  static TextStyle primaryHeadLinesStyle = GoogleFonts.inter(
      textStyle: TextStyle(
          fontSize: 30.sp, fontWeight: FontWeight.bold, color: Colors.black));

  static TextStyle subtitlesStyles = GoogleFonts.inter(
      textStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      ));

  static TextStyle black16w500Style = GoogleFonts.inter(
      textStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ));

  static TextStyle grey12MediumStyle = GoogleFonts.inter(
      textStyle: TextStyle(
          fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.black));

  static TextStyle black15BoldStyle = GoogleFonts.inter(
      textStyle: TextStyle(
          fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black));

  static TextStyle black18BoldStyle = GoogleFonts.inter(
      textStyle: TextStyle(
          fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black));
}
