import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_colors.dart';
import 'package:glovana_provider/core/design/constants.dart';
import 'package:glovana_provider/core/logic/endpoints.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/models/message_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voice_note_kit/player/audio_player_widget.dart';
import 'package:voice_note_kit/player/player_enums/player_enums.dart';
import 'dart:ui' as ui;

class SenderMsgItemWidget extends StatelessWidget {
  const SenderMsgItemWidget({
    super.key,
    required this.message,
    required this.senderPhoto,
  });

  final Message message;
  final String? senderPhoto;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
                width: Constants.getwidth(context),
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                ),
                child: message.type == "IMAGE"
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: CachedNetworkImage(
                          imageUrl: ApiEndPoints.imagesUrl +
                              message.content.toString(),
                          height: Constants.getHeight(context) * 0.2,
                          width: 30.w,
                          fit: BoxFit.fill,
                        ),
                      )
                    : message.type == "FILE"
                        ? InkWell(
                            onTap: () {
                              launchUrl(Uri.parse(message.content.toString()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.file_copy_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "open_file".tr(),
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ))
                        : message.type == "VOICE"
                            ? AudioPlayerWidget(
                                backgroundColor: AppColors.primaryColor,
                                progressBarColor: Colors.white,
                                audioType: AudioType.url,
                                playerStyle: PlayerStyle.style1,
                                textDirection: Constants.lang == "ar"
                                    ? ui.TextDirection.ltr
                                    : ui.TextDirection.rtl,
                                audioPath: ApiEndPoints.imagesUrl +
                                    message.content.toString())
                            : Text(
                                message.content.toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                DateFormat('yyyy-MM-dd – hh:mm a')
                    .format(message.sentAt!.toDate()),
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(width: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: CachedNetworkImage(
            imageUrl: senderPhoto == null ||
                    senderPhoto == "" ||
                    senderPhoto == "null"
                ? "https://www.greiner-gmbh.de/fileadmin/images/hairline/galerie/saloneinrichtung_berlin_blacklabel/bl_store_3_big.jpg"
                : (senderPhoto!),
            height: 40.sp,
            width: 40.sp,
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}
