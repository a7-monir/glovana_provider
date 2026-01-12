import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:glovana_provider/core/design/app_image.dart';

import '../models/rooms_model.dart';

class OnePersonChatItem extends StatelessWidget {
  final Room room;
  final Function()? onTap;

  const OnePersonChatItem({
    super.key,
    required this.room,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.sp),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child: AppImage(
                    room.userImageUrl ?? '',
                    height: 43.sp,
                    width: 43.sp,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 8.w),


                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150.w,
                      child: Text(
                        room.userName ?? "",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (room.lastMessage != null)
                      SizedBox(
                        width: 150.w,
                        child: Text(
                          room.lastMessageType == "image"
                              ? "Photo"
                              : room.lastMessageType == "voice"
                              ? "Voice"
                              : room.lastMessage ?? "",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ],
            ),


            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (room.lastMessageDate != null)
                  Text(
                    DateFormat('hh:mm a').format(room.lastMessageDate!.toDate()),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                if (room.unreadCountProvider > 0)
                  Container(
                    margin: EdgeInsets.only(top: 4.h),
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                        shape: BoxShape.circle
                    ),
                    child: Text(
                      (room.unreadCountProvider).toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}