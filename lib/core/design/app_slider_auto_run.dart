import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_image.dart';

class AppSliderAutoRun extends StatefulWidget {
  final List<String> list;
  final bool autoPlay,withDotes;
  final double? height;


  const AppSliderAutoRun({super.key, required this.list,this.autoPlay=true, this.height,  this.withDotes=true,});

  @override
  State<AppSliderAutoRun> createState() => _AppSliderAutoRunState();
}

class _AppSliderAutoRunState extends State<AppSliderAutoRun> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:widget.height?? 191.h,
      child: Column(
        children: [
          Expanded(
            child: CarouselSlider.builder(
              itemCount: widget.list.length,
              options: CarouselOptions(
                height: widget.height?? 191.h,
                aspectRatio: 1,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: widget.autoPlay,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                onPageChanged: (index, reason) {
                  currentPage = index;
                  setState(() {});
                },
                scrollDirection: Axis.horizontal,
              ),
              itemBuilder:
                  (BuildContext context, int index, int pageViewIndex) =>
                  Container(
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        // BoxShadow(
                        //   color: Colors.black.withValues(alpha: .25),
                        //   offset: Offset(0, 4),
                        //   blurRadius: 4.r
                        // )
                      ],
                      // border: Border.all(
                      //   color: Theme.of(context).dividerColor,
                      //   strokeAlign: BorderSide.strokeAlignOutside,
                      //   width: .5.w,
                      // ),
                    ),
                    child: AppImage(
                      widget.list[index],
                      height:widget.height??  191.h,
                      withBaseImageUrl: true,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
            ),
          ),
          if(widget.withDotes)...[
            SizedBox(height: 12.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                widget.list.length,
                    (index) => Container(
                  height: 8.h,
                  width:  8.h,
                  margin: EdgeInsetsDirectional.only(end: 8.w),
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    borderRadius: BorderRadius.circular(32.r),
                    color: Theme.of(context)
                        .primaryColor
                        .withValues(alpha:  currentPage == index ? 1 : .12),
                  ),
                ),
              ),
            ),
          ]

        ],
      ),
    );
  }
}

