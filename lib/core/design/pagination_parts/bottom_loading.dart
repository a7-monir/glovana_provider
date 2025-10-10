import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomLoading extends StatelessWidget {
  final bool isPaginationLoading, isPaginationFailed;

  final VoidCallback onLoading;

  const BottomLoading(
      {Key? key,
      required this.isPaginationLoading,
      required this.isPaginationFailed,
      required this.onLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isPaginationLoading
        ? Padding(
            padding: EdgeInsets.only(bottom: 10.h, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: .5,
                    )),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  "Loading more...",
                  style: TextStyle(fontSize: 13.sp),
                )
              ],
            ),
          )
        : isPaginationFailed
            ? Padding(
                padding: EdgeInsets.only(bottom: 10.h, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          onLoading();
                        },
                        icon: const Icon(Icons.refresh)),
                    Text("Try Again"),
                  ],
                ),
              )
            : const SizedBox.shrink();
  }
}
