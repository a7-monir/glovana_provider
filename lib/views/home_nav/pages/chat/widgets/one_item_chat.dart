import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_image.dart';


import '../models/rooms_model.dart';

class OnePersonChatItem extends StatelessWidget {
  final Room room;
  final Function()? onTap;
  const OnePersonChatItem({super.key, required this.room, required this.onTap});

  @override
  Widget build(BuildContext context) {
    log(room.providerImageUrl.toString());
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
                    room.userImageUrl??'',
                    height: 43.sp,
                    width: 43.sp,
                    fit: BoxFit.cover,
                  ),
                ),
                 SizedBox(width: 8.w),
                Column(
                  children: [
                    SizedBox(
                      width: 150.w,
                      child: Text(
                        room.userName ?? "",

                      ),
                    ),
                    room.lastMessage != null
                        ? SizedBox(
                            width: 150.w,
                            child: Text(
                              room.lastMessageType == "IMAGE"
                                  ? "photo"
                                  : room.lastMessageType == "VOICE"
                                      ? "voice"
                                      : room.lastMessage ?? "",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ],
            ),
            room.lastMessageDate == null
                ? SizedBox.shrink()
                : Text(
                    DateFormat('yyyy-MM-dd – hh:mm a')
                        .format(room.lastMessageDate!.toDate()),
                    style: TextStyle(
                        fontSize: 12.sp, fontWeight: FontWeight.normal),
                  )
          ],
        ),
      ),
    );
  }
}
