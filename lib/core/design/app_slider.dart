import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_image.dart';

class AppSlider extends StatefulWidget {
  final List<String> list;

  const AppSlider({super.key, required this.list});

  @override
  State<AppSlider> createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: widget.list.length,
              onPageChanged: (value) {
                currentPage = value;
                setState(() {});
              },
              itemBuilder: (context, index) => Container(
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.symmetric(horizontal: 24.w),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    width: .5,
                  ),
                ),
                child: AppImage(
                  widget.list[index],
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.list.length,
                  (index) => Container(
                height: 8.h,
                width: currentPage == index ? 32.w : 8.h,
                margin: EdgeInsetsDirectional.only(end: 2.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.r),
                  color: Theme.of(context)
                      .primaryColor
                      .withOpacity(currentPage == index ? 1 : .12),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}