import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OlaColors {
  OlaColors._();

  static const Color actionBtnColor = Color(0xFFE0E0E0);
  static const Color splashcreen = Color(0XFF06071C);
  static const Color appbackground = Color(0xFF121314);
  static const Color primarycolor = Color(0xFF7E11D8);
  static const Color basewhite = Color(0xffffffff);
  static const Color baseblack = Color(0xff212121);
  static const Color base499EEF = Color(0xff499eef);
  static const Color primarycolor25 = Color(0xfff5f8ff);
  static const Color primarycolor50 = Color(0xffeff4ff);
  static const Color primarycolor100 = Color(0xffd1e0ff);
  static const Color primarycolor200 = Color(0xffb2ccff);
  static const Color primarycolor300 = Color(0xff84adff);
  static const Color primarycolor400 = Color(0xff528bff);
  static const Color primarycolor500 = Color(0xff2970ff);
  static const Color primarycolor600 = Color(0xff155eef);
  static const Color primarycolor700 = Color(0xff004eeb);
  static const Color primarycolor800 = Color(0xff0040c1);
  static const Color primarycolor900 = Color(0xff00359e);
  static const Color gray25 = Color(0xfffcfcfd);
  static const Color gray50 = Color(0xfff9fafb);
  static const Color gray100 = Color(0xfff2f4f7);
  static const Color gray200 = Color(0xffeaecf0);
  static const Color gray300 = Color(0xffd0d5dd);
  static const Color gray400 = Color(0xff98a2b3);
  static const Color gray500 = Color(0xff667085);
  static const Color gray600 = Color(0xff475467);
  static const Color gray700 = Color(0xff344054);
  static const Color gray800 = Color(0xff1d2939);
  static const Color gray900 = Color(0xff101828);
  static const Color red25 = Color(0xfffffbfa);
  static const Color red50 = Color(0xfffef3f2);
  static const Color red100 = Color(0xfffee4e2);
  static const Color red200 = Color(0xfffecdca);
  static const Color red300 = Color(0xfffda29b);
  static const Color red400 = Color(0xfff97066);
  static const Color red500 = Color(0xfff04438);
  static const Color red600 = Color(0xffd92d20);
  static const Color red700 = Color(0xffb42318);
  static const Color red800 = Color(0xff912018);
  static const Color red900 = Color(0xff7a271a);
  static const Color war25 = Color(0xfffffcf5);
  static const Color war50 = Color(0xfffffaeb);
  static const Color war100 = Color(0xfffef0c7);
  static const Color war200 = Color(0xfffedf89);
  static const Color war300 = Color(0xfffec84b);
  static const Color war400 = Color(0xfffdb022);
  static const Color war500 = Color(0xfff79009);
  static const Color war600 = Color(0xffdc6803);
  static const Color war700 = Color(0xffb54708);
  static const Color war800 = Color(0xff93370d);
  static const Color war900 = Color(0xff7a2e0e);
  static const Color green25 = Color(0xfff6fef9);
  static const Color green50 = Color(0xffedfcf2);
  static const Color green100 = Color(0xffd3f8df);
  static const Color green200 = Color(0xffaaf0c4);
  static const Color green300 = Color(0xff73e2a3);
  static const Color green400 = Color(0xff3ccb7f);
  static const Color green500 = Color(0xff16b364);
  static const Color green600 = Color(0xff099250);
  static const Color green700 = Color(0xff087443);
  static const Color green800 = Color(0xff095c37);
  static const Color green900 = Color(0xff084c2e);
  static const Color neugray25 = Color(0xfffcfcfd);
  static const Color neugray500 = Color(0xff4e5ba6);
  static const Color neublue25 = Color(0xfff5fbff);
  static const Color neublue100 = Color(0xffe0f2fe);
  static const Color neublue500 = Color(0xff0ba5ec);
  static const Color neuviolet25 = Color(0xfffbfaff);
  static const Color neuviolet500 = Color(0xff875bf7);
  static const Color neupink25 = Color(0xfffef6fb);
  static const Color neupink500 = Color(0xffee46bc);
  static const Color neuorange25 = Color(0xfffff9f5);
  static const Color neuorange50 = Color(0xffff4405);
  static const Color neuyello25 = Color(0xfffefdf0);
  static const Color neuyello50 = Color(0xffeaaa08);
  static const Color neutea25 = Color(0xfff6fefc);
  static const Color neutea50 = Color(0xff15b79e);
  static const Color darkGrey = Color(0xff252728);

  static const Color background = Color(0xff333334);
  static const Color bgCard = Color(0xff252728);
  static const Color grayColor = Color(0xff939598);

  static const Color secondaryHeader = Color(0xff243A52);
}

class OlaTextStyles {
  OlaTextStyles._();

  static TextStyle get displaymd36Regular => TextStyle(
    fontSize: 36.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 44 / 36,
    letterSpacing: -2,
  );

  static TextStyle get displaymd36Medium => TextStyle(
    fontSize: 36.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 44 / 36,
    letterSpacing: -2,
  );

  static TextStyle get displaymd36Semibold => TextStyle(
    fontSize: 36.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 44 / 36,
    letterSpacing: -2,
  );

  static TextStyle get displaymd36Bold => TextStyle(
    fontSize: 36.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 44 / 36,
    letterSpacing: -2,
  );

  static TextStyle get displaysm30Regular => TextStyle(
    fontSize: 30.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 38 / 30,
    letterSpacing: 0,
  );

  static TextStyle get displaysm30Medium => TextStyle(
    fontSize: 30.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 38 / 30,
    letterSpacing: 0,
  );

  static TextStyle get displaysm30Semibold => TextStyle(
    fontSize: 30.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    height: 38 / 30,
    letterSpacing: 0,
  );

  static TextStyle get displaysm30bold => TextStyle(
    fontSize: 30.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 38 / 30,
    letterSpacing: 0,
  );

  static TextStyle get displayxs24regular => TextStyle(
    fontSize: 24.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 32 / 24,
    letterSpacing: 0,
  );

  static TextStyle get displayxs24medium => TextStyle(
    fontSize: 24.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 32 / 24,
    letterSpacing: 0,
  );

  static TextStyle get displayxs24semibold => TextStyle(
    fontSize: 24.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: 0,
  );

  static TextStyle get displayxs24bold => TextStyle(
    fontSize: 24.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: 0,
  );

  static TextStyle get textlg18regular => TextStyle(
    fontSize: 18.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
    letterSpacing: 0,
  );

  static TextStyle get textlg18medium => TextStyle(
    fontSize: 18.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 28 / 18,
    letterSpacing: 0,
  );

  static TextStyle get textlg18semibold => TextStyle(
    fontSize: 18.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    height: 28 / 18,
    letterSpacing: 0,
  );

  static TextStyle get textlg18bold => TextStyle(
    fontSize: 18.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 18 / 18,
    letterSpacing: 0,
  );

  static TextStyle get primarytext14regular => TextStyle(
    fontSize: 14.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 14 / 14,
    letterSpacing: 0,
  );

  static TextStyle get primarytext14medium => TextStyle(
    fontSize: 14.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 14 / 14,
    letterSpacing: 0,
  );

  static TextStyle get primarytext14semibold => TextStyle(
    fontSize: 14.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
    letterSpacing: 0,
  );

  static TextStyle get primarytext14bold => TextStyle(
    fontSize: 14.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
    letterSpacing: 0,
  );

  static TextStyle get subtext12regular => TextStyle(
    fontSize: 12.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 12 / 12,
    letterSpacing: 0,
  );

  static TextStyle get subtext12medium => TextStyle(
    fontSize: 12.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 18 / 12,
    letterSpacing: 0,
  );

  static TextStyle get subtext12semibold => TextStyle(
    fontSize: 12.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 18 / 12,
    letterSpacing: 0,
  );

  static TextStyle get subtext12bold => TextStyle(
    fontSize: 12.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 18 / 12,
    letterSpacing: 0,
  );

  static TextStyle get title20regular => TextStyle(
    fontSize: 20.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 30 / 20,
    letterSpacing: 0,
  );

  static TextStyle get title20medium => TextStyle(
    fontSize: 20.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 30 / 20,
    letterSpacing: 0,
  );

  static TextStyle get title20semibold => TextStyle(
    fontSize: 20.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 30 / 20,
    letterSpacing: 0,
  );

  static TextStyle get title20bold => TextStyle(
    fontSize: 20.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 30 / 20,
    letterSpacing: 0,
  );
}

// KoHo Text Styles
class KoHoTextStyles {
  KoHoTextStyles._();

  static TextStyle get display36Regular => GoogleFonts.koHo(
    fontSize: 36.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 44 / 36,
    letterSpacing: -2,
  );

  static TextStyle get display36Medium => GoogleFonts.koHo(
    fontSize: 36.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 44 / 36,
    letterSpacing: -2,
  );

  static TextStyle get display36Bold => GoogleFonts.koHo(
    fontSize: 36.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 44 / 36,
    letterSpacing: -2,
  );

  static TextStyle get primary14Regular => GoogleFonts.koHo(
    fontSize: 14.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 14 / 14,
    letterSpacing: 0,
  );

  static TextStyle get primary14Semibold => GoogleFonts.koHo(
    fontSize: 14.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
    letterSpacing: 0,
  );
}

class PoppinsTextStyles {
  PoppinsTextStyles._();

  static TextStyle get display36Regular => GoogleFonts.poppins(
    fontSize: 36.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 44 / 36,
    letterSpacing: -2,
  );

  static TextStyle get display36Medium => GoogleFonts.poppins(
    fontSize: 36.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 44 / 36,
    letterSpacing: -2,
  );

  static TextStyle get display36Bold => GoogleFonts.poppins(
    fontSize: 36.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 44 / 36,
    letterSpacing: -2,
  );

  static TextStyle get display16Regular => GoogleFonts.poppins(
    fontSize: 16.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 44 / 36,
    letterSpacing: -1,
  );

  static TextStyle get display16Medium => GoogleFonts.poppins(
    fontSize: 16.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 44 / 36,
    letterSpacing: -1,
  );

  static TextStyle get display16Bold => GoogleFonts.poppins(
    fontSize: 16.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 44 / 36,
    letterSpacing: -2,
  );

  static TextStyle get display14Bold => GoogleFonts.poppins(
    fontSize: 24.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 44 / 36,
    letterSpacing: -1,
  );

  static TextStyle get primary14Regular => GoogleFonts.poppins(
    fontSize: 14.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 14 / 14,
    letterSpacing: 0,
  );

  static TextStyle get primary18Semibold => GoogleFonts.poppins(
    fontSize: 18.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
    letterSpacing: 0,
  );

  static TextStyle get primary18Regular => GoogleFonts.poppins(
    fontSize: 18.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 14 / 14,
    letterSpacing: 0,
  );

  static TextStyle get primary14Semibold => GoogleFonts.poppins(
    fontSize: 14.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
    letterSpacing: 0,
  );

  static TextStyle get primary12Regular => GoogleFonts.poppins(
    fontSize: 12.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
    height: 16 / 14,
    letterSpacing: 0,
  );

  static TextStyle get primary12Semibold => GoogleFonts.poppins(
    fontSize: 12.sp,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
    letterSpacing: 0,
  );
}
