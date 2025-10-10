import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
                  child: CachedNetworkImage(
                    imageUrl: room.userImageUrl == null ||
                            room.userImageUrl!.isEmpty ||
                            room.userImageUrl == "null"
                        ? "https://www.greiner-gmbh.de/fileadmin/images/hairline/galerie/saloneinrichtung_berlin_blacklabel/bl_store_3_big.jpg"
                        : room.userImageUrl!,
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
                                  ? "photo".tr()
                                  : room.lastMessageType == "VOICE"
                                      ? "voice".tr()
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
            Column(
              children: [
                room.lastMessageDate == null
                    ? SizedBox.shrink()
                    : Text(
                        DateFormat('yyyy-MM-dd – hh:mm a')
                            .format(room.lastMessageDate!.toDate()),
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.normal),
                      ),
                 SizedBox(width: 2.w),
                // Container(
                //   height: 20.sp,
                //   width: 20.sp,
                //   alignment: Alignment.center,
                //   padding: EdgeInsets.all(3.sp),
                //   decoration: const BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: AppColors.primaryColor,
                //   ),
                //   child: Text(
                //     "3",
                //     style: TextStyle(fontSize: 16.sp, color: Colors.white),
                //   ),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}
