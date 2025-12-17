import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_colors.dart';
import 'package:glovana_provider/core/design/app_image.dart';
import 'package:glovana_provider/core/design/constants.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:voice_note_kit/voice_note_kit.dart';
import 'dart:ui' as ui;

import '../models/message_model.dart';

class ReceiverMsgItemWidget extends StatelessWidget {
  final Message message;
  final String recieverPhoto;
  const ReceiverMsgItemWidget({
    super.key,
    required this.message,
    required this.recieverPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(100.r),
          child:
          AppImage(recieverPhoto,
            height: 40.sp,
            width: 40.sp,
            fit: BoxFit.fill,
            withBaseImageUrl: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: message.type == "IMAGE"
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImage(
                    imageUrl: resolveMediaUrl(message.content.toString()),
                    height: Constants.getHeight(context) * 0.2,
                    width: 30,
                    fit: BoxFit.cover,
                  ),
                )
                    : message.type == "FILE"
                    ? InkWell(
                  onTap: () => launchUrl(Uri.parse(resolveMediaUrl(message.content.toString()))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.file_copy_outlined, size: 30, color: Colors.black),
                      const SizedBox(width: 10),
                      Text("open_file", style: TextStyle(fontSize: 16.sp, color: Colors.black)),
                    ],
                  ),
                )
                    : message.type == "VOICE"
                    ? AudioPlayerWidget(
                  backgroundColor: AppTheme.primary,
                  progressBarColor: Colors.white,
                  audioType: AudioType.url,
                  playerStyle: PlayerStyle.style1,
                  textDirection: Constants.lang == "en" ? ui.TextDirection.ltr : ui.TextDirection.rtl,
                  audioPath: resolveMediaUrl(message.content.toString()),
                )
                    : Text(
                  message.content.toString(),
                  style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                DateFormat(
                  'yyyy-MM-dd – hh:mm a',
                ).format(message.sentAt!.toDate()),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
String resolveMediaUrl(String content) {
  if (content.startsWith('http://') || content.startsWith('https://')) {
    return content;
  }
  return AppTheme.imageUrl + content;
}