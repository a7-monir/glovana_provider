import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../generated/locale_keys.g.dart';


class InputValidator {
  static final emailReg =
      RegExp(r'[a-z]+\d*@[a-z]+\.[a-z]{3}', caseSensitive: false);
  static final arabicPhoneNumbersReg = RegExp(r"[\u0661-\u0669]");
  static final _arabicTextReg = RegExp(r"[\u0600-\u06ff]+");
  static final _cardNumbersReg = RegExp(r"\d.{4}");
  static final jordanNumberReg = RegExp(r'^(?:\+962|00962|962|0)?7[0-9]{8}$');

  static String? validatePhone(String? value) {
    if (value!.isEmpty) {
      return LocaleKeys.thisIsARequiredField.tr();
    }
    else if (!jordanNumberReg.hasMatch(value)) {
      return LocaleKeys.invalidPhoneNumber.tr();
    }
    return null;
  }

  static String? emailValidator(String value) {
    if (value.isEmpty) {
      return LocaleKeys.validateRequired
          .tr(namedArgs: {"name": LocaleKeys.emailAddress.tr()});
    } else if (emailReg.hasMatch(value)) {
      return null;
    } else {
      return LocaleKeys.invalidEmail.tr();
    }
  }

  static String? requiredValidator(
      {required String value,
      required String itemName,
      bool lengthRequired = false,
      int lengthNumber = 3}) {
    if (value.trim().isEmpty) {
      return LocaleKeys.validateRequired.tr(namedArgs: {"name": itemName});
    } else if (value.trim().length < lengthNumber && lengthRequired) {
      return LocaleKeys.validateAtLeastDigitsWithNameAndValue
          .tr(namedArgs: {"name": itemName, "value": lengthNumber.toString()});
    }
    return null;
  }
  // static String? emailValidator(String? value) {
  //   if (value!.isEmpty) {
  //     return LocaleKeys.validateRequired
  //         .tr(namedArgs: {"name": LocaleKeys.email.tr()});
  //   } else {
  //     if (_emailReg.hasMatch(value) == false) {
  //       return LocaleKeys.invalidEmail.tr();
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  // static String? codeValidator(String value) {
  //   if (value.isEmpty) {
  //     return LocaleKeys.validateRequired.tr(namedArgs: {"name": LocaleKeys.code.tr()});
  //   } else if (value.length < 4) {
  //     return LocaleKeys.validateAtLeast3Digits.tr(namedArgs: {
  //       "name": LocaleKeys.code.tr(),
  //       "number": "4",
  //     });
  //   }
  //   return null;
  // }

  static String? passwordValidator(String value,  {lengthRequired = false}) {
    if (value.isEmpty) {
      return LocaleKeys.validateRequired.tr(
        namedArgs: {
          'name':LocaleKeys.password.tr()
        }
      );
    }
    else if (lengthRequired) {
      if (value.length >= 8) {
        return null;
      } else {
        return LocaleKeys.validateAtLeastDigitsWithNameAndValue.tr(namedArgs: {
          "name": LocaleKeys.password.tr(),
          "value": "8",
        });
      }
    } else {
      return null;
    }
  }

  static String? confirmPasswordValidator(String password, String confirmPassword) {
    if (password.isEmpty) {
      return LocaleKeys.validateRequired.tr(namedArgs: {"name": LocaleKeys.confirmPassword.tr()});
    } else if (confirmPassword.isEmpty) {
      return null;
    } else if (password != confirmPassword) {
      return LocaleKeys.passwordsNotMatched.tr();
    }
    return null;
  }

  static bool isNumbersArabic(String value) {
    if (arabicPhoneNumbersReg.hasMatch(value)) {
      return true;
    }
    return false;
  }

  static String replaceArabicNumbers(String value) {
    return value.replaceAllMapped(
        arabicPhoneNumbersReg, (m) => '${(m[0]!.codeUnits[0] - 1584) - 48}');
  }

  static bool isTextArabic(String value) {
    if (_arabicTextReg.hasMatch(value)) {
      return true;
    }
    return false;
  }

  static String showAsCardNumber(String value) {
    return value.replaceAllMapped(_cardNumbersReg, (m) => '${m[0]} ');
  }

  static String fixPhone({required String phone, required String countryCode}) {
    if (phone.trim().startsWith("0")) {
      phone = phone.trim().substring(1);
    }
    return (countryCode) + replaceArabicNumbers(phone);
  }

  static String fixPhoneCode(String phoneCode) {
    if (phoneCode.startsWith("+")) {
      phoneCode = phoneCode.substring(1);
    }
    return phoneCode;
  }
}
