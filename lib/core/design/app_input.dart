import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../logic/cache_helper.dart';
import 'app_image.dart';

enum InputType { normal, password, money, phone }

class AppInput extends StatefulWidget {
  final InputType inputType;
  final String? hint, label, fixedPositionedLabel;
  final Widget? suffix;
  final Widget? prefix;
  final double? marginBottom;
  final Color? prefixColor, filledColor;
  final bool isDense, isPassword, isCardNumber, isCenterTitle,isValid;
  final int maxLines;
  final int? maxLength;
  final InputBorder? border;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final TextStyle? hintStyle;
  final TextAlign? textAlign;
  final TextInputAction textInputAction;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String value)? onChanged;
  final void Function(String value)? onFieldSubmitted;
  final void Function(bool)? onFocusChange;
  final bool withShadow;

  final void Function(bool value)? onTogglePassword;

  const AppInput({
    super.key,
    this.hint,
    this.label,
    this.maxLength,
    this.marginBottom,
    this.prefix,
    this.prefixColor,
    this.inputType = InputType.normal,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.controller,
    this.validator,
    this.onChanged,
    this.isCardNumber = false,
    this.isDense = false,
    this.suffix,
    this.maxLines = 1,
    this.fixedPositionedLabel,
    this.onTogglePassword,
    this.isPassword = false,
    this.border,
    this.onTap,
    this.filledColor,
    this.onFieldSubmitted,
    this.onFocusChange,
    this.isCenterTitle = false,  this.withShadow=true,  this.isValid=true, this.hintStyle, this.textAlign,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  bool isPasswordShown = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.marginBottom ?? 16.h),
      child: Column(
        crossAxisAlignment:
        widget.isCenterTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (widget.fixedPositionedLabel != null)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                widget.fixedPositionedLabel!,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400
                ),
              ),
            ),
          Material(
            // تطبيق الظل باستخدام elevation
            elevation: widget.withShadow ? 4.r : 0,
            shadowColor: widget.withShadow ? Colors.black.withValues(alpha: .8) : Colors.transparent,
            borderRadius: BorderRadius.circular(30.r),
            clipBehavior: Clip.antiAlias,
            color: widget.filledColor ?? Theme.of(context).cardColor,
            child: GestureDetector(
              onTap: widget.onTap,
              child: AbsorbPointer(
                absorbing: widget.onTap != null,
                child: Focus(
                  onFocusChange: widget.onFocusChange,
                  child: TextFormField(
                    onTapOutside:(event) {
                      if(widget.onFieldSubmitted!=null&&widget.controller!=null){
                        widget.onFieldSubmitted!(widget.controller!.text);
                      }
                    } ,
                    controller: widget.controller,
                    onChanged: widget.onChanged,
                    minLines: widget.maxLines,
                    maxLines: widget.maxLines,
                    textAlign:widget.textAlign??TextAlign.start,
                    obscureText:
                    ((widget.inputType == InputType.password) && !isPasswordShown) ||
                        widget.isPassword,
                    textInputAction: widget.textInputAction,
                    onFieldSubmitted: widget.onFieldSubmitted,
                    keyboardType: widget.keyboardType,
                    validator: widget.validator,
                    inputFormatters: [
                      if ([InputType.money].contains(widget.inputType))
                        FilteringTextInputFormatter.allow(RegExp("^(?!0)[0-9\\s]*")),
                      if (widget.maxLength != null)
                        LengthLimitingTextInputFormatter(widget.maxLength),
                      if (widget.keyboardType == TextInputType.datetime) CardExpirationFormatter(),
                      if (widget.isCardNumber) CardFormatter(separator: '-'),
                      if (widget.keyboardType == TextInputType.phone ||
                          widget.inputType == InputType.phone)
                        FilteringTextInputFormatter.deny(
                            RegExp(r'^0+(?=.)'))
                    ],
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      alignLabelWithHint: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      hintStyle:widget.hintStyle ,
                      filled: true,
                      fillColor: Colors.transparent,
                      isDense: widget.isDense,
                      labelText: widget.label,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h), // مساحة داخلية مناسبة
                      prefixIcon:
                      widget.inputType == InputType.phone && CacheHelper.lang == "en"
                          ? countryCode
                          : widget.prefix,
                      suffixIcon:
                      widget.inputType == InputType.password
                          ? GestureDetector(
                        child: Container(
                          color: Colors.transparent,
                          child: Icon(
                            Icons.remove_red_eye_outlined,
                            color: isPasswordShown ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                          ),
                        ),
                        onTap: () {
                          isPasswordShown = !isPasswordShown;
                          if (widget.onTogglePassword != null) {
                            widget.onTogglePassword!(isPasswordShown);
                          }

                          setState(() {});
                        },
                      )
                          : widget.suffix ??
                          (widget.inputType == InputType.phone && CacheHelper.lang == "ar"
                              ? countryCode
                              : null),
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget get countryCode {
    return SizedBox(
      height: 20.h,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 8.w),
            if (widget.inputType == InputType.phone)
              Text(
                "+962",
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).hintColor,
                ),
              ),
            if (widget.inputType == InputType.phone)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: const VerticalDivider(),
              ),
            if (widget.inputType == InputType.phone) SizedBox(width: 8.w),
            widget.inputType == InputType.phone
                ? AppImage("flag.png", height: 20.h, width: 20.h)
                : widget.prefix!,
            if (widget.inputType == InputType.phone) SizedBox(width: 16.w),
          ],
        ),
      ),
    );
  }
}

class CardExpirationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueString = newValue.text;
    String valueToReturn = '';

    for (int i = 0; i < newValueString.length; i++) {
      if (newValueString[i] != '/') valueToReturn += newValueString[i];
      var nonZeroIndex = i + 1;
      final contains = valueToReturn.contains(RegExp(r'\/'));
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newValueString.length && !(contains)) {
        valueToReturn += '/';
      }
    }
    return newValue.copyWith(
      text: valueToReturn,
      selection: TextSelection.fromPosition(TextPosition(offset: valueToReturn.length)),
    );
  }
}

class CardFormatter extends TextInputFormatter {
  final String separator;

  CardFormatter({required this.separator});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var oldS = oldValue.text;
    var newS = newValue.text;
    var endsWithSeparator = false;

    // if you add text
    if (newS.length > oldS.length) {
      for (var char in separator.characters) {
        if (newS.substring(0, newS.length - 1).endsWith(char)) {
          endsWithSeparator = true;
        }
      }
      print('Ends with separator: $endsWithSeparator, so we will add it with next digit.');

      var clean = newS.replaceAll(separator, '');
      print('CLEAN add: $clean');
      if (!endsWithSeparator && clean.length > 1 && clean.length % 4 == 1) {
        return newValue.copyWith(
          text: newS.substring(0, newS.length - 1) + separator + newS.characters.last,
          selection: TextSelection.collapsed(offset: newValue.selection.end + separator.length),
        );
      }
    }

    // if you delete text
    if (newS.length < oldS.length) {
      for (var char in separator.characters) {
        if (oldS.substring(0, oldS.length - 1).endsWith(char)) {
          endsWithSeparator = true;
        }
      }
      print('Ends with separator: $endsWithSeparator, so we removed it');

      var clean = oldS.substring(0, oldS.length - 1).replaceAll(separator, '');
      print('CLEAN remove: $clean');
      if (endsWithSeparator && clean.isNotEmpty && clean.length % 4 == 0) {
        return newValue.copyWith(
          text: newS.substring(0, newS.length - separator.length),
          selection: TextSelection.collapsed(offset: newValue.selection.end - separator.length),
        );
      }
    }

    return newValue;
  }
}