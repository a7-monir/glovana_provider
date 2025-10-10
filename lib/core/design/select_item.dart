
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_theme.dart';

class SelectionItem extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final Widget? startWidget;
  final bool isSelect;

  const SelectionItem(
      {super.key,
        this.onTap,
        required this.title,
        this.startWidget,
        required this.isSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            height: 60.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 5.0),
                      blurRadius: 20.0)
                ]),
            child: Row(children: [
              if (startWidget != null) Padding(
                padding:  EdgeInsetsDirectional.only(end: 15.w),
                child: startWidget!,
              ),
              Expanded(
                  child: Text(title, )),
              Icon(
                  isSelect
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  weight: 24.h,
                  color: isSelect ? AppTheme.primary : AppTheme.hintTextColor)
            ])));
  }
}