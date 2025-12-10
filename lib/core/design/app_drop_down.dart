import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../logic/input_validator.dart';
import 'app_image.dart';

class AppDropDown extends StatefulWidget {
  final List<String> list;
  final String? title;
  final String hint;
  final String? Function(String?)? validator;

  final ValueChanged<int> onChoose;
  final bool isLoading;
  final int? selectedIndex;
  final double? marginBottom;
  final Widget? prefix;

  const AppDropDown(
      {super.key,
        required this.list,
        this.title,
        required this.hint,
        required this.onChoose,
        this.marginBottom,
        this.isLoading = false,
        this.selectedIndex,
        this.validator,
        this.prefix});

  @override
  State<AppDropDown> createState() => _AppDropDownState();
}

class _AppDropDownState extends State<AppDropDown> {
  int? selectedDurationIndex;

  @override
  void initState() {
    super.initState();
    selectedDurationIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedIndex != null) {
      selectedDurationIndex = widget.selectedIndex;
    }
   // if (!widget.isLoading && widget.list.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: widget.marginBottom ?? 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                widget.title!,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),

          DropdownButtonFormField<int>(
            value: selectedDurationIndex,
            decoration: InputDecoration(

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide:  BorderSide(
                  color: Theme.of(context).primaryColor,
                  // color: Color(0xffE9E9E9),
                ),
              ),
              enabledBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide:  BorderSide(
                  color: Theme.of(context).primaryColor,
                  // color: Color(0xffE9E9E9),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide:  BorderSide(
                  color: Theme.of(context).colorScheme.error,
                  // color: Color(0xffE9E9E9),
                ),
              ),
              contentPadding:Theme.of(context).inputDecorationTheme.contentPadding,
              prefix: widget.prefix,
            ),
            validator: (value) {
              return widget.validator == null
                  ? null
                  : widget.validator!(value?.toString() ?? "");
            },
            elevation: 0,
            focusColor: Colors.transparent,
            dropdownColor: Theme.of(context).secondaryHeaderColor,
            iconSize: 16.sp,
            icon: widget.isLoading
                ? SizedBox(
                height: 26.h,
                width: 26.h,
                child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: .9,
                    )))
                : AppImage(
              "arrow_down.png",
              height: 26.h,
              width: 26.h,
              fit: BoxFit.fill,
            ),
            onChanged: (value) {
              if (value != null) {
                selectedDurationIndex = value;
                widget.onChoose(value);
                setState(() {});
              }
            },
            // underline: const SizedBox.shrink(),
            hint: Text(
              widget.hint,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            borderRadius: BorderRadius.circular(12.r),
            isExpanded: true,
            items: List.generate(
              widget.list.length,
                  (index) => DropdownMenuItem(
                value: index,
                child: Text(
                  widget.list[index].trim(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
