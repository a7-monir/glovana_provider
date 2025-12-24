import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_input.dart';
import 'package:glovana_provider/core/design/space_widget.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/chat_utils.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/models/message_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiwi/kiwi.dart';
import 'package:voice_note_kit/voice_note_kit.dart';

import 'package:firebase_storage/firebase_storage.dart';
import '../../../../../core/design/main_services.dart';
import '../../../../../features/send_notification/bloc.dart';

class SendMessageWidget extends StatefulWidget {
  final String userId, name;
  final int id;
  final String? userName;
  final String? userImage;
  final ScrollController scrollController;

  const SendMessageWidget({
    super.key,
    this.userName,
    required this.userId,
    required this.scrollController,
    this.userImage,
    required this.id,
    required this.name,
  });

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  final sendNotificationsBloc = KiwiContainer().resolve<SendNotificationsBloc>();

  File? currentSelectedImage;
  File? currentAudioFile;

  final TextEditingController messageController = TextEditingController();
  bool isTyping = false;

  void _sendTextMessage(String text) {
    ChatUtils.addMessage(
      fromProvider: true, // <- من البروفايدر
      Message(
        content: text,
        createdAt: Timestamp.now(),
        providerId: widget.id.toString(),
        sentAt: Timestamp.now(),
        type: "TEXT",
        userId: widget.userId,
        senderId: widget.id.toString(),
        isReadUser: false,
        isReadProvider: true,
      ),
    );

    sendNotificationsBloc.add(
      SendNotificationsEvent(
        userId: widget.userId,
        title: LocaleKeys.youHaveAMessage.tr(),
        body: "$text\n${LocaleKeys.from.tr()} ${widget.name}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendNotificationsBloc, SendNotificationsStates>(
      bloc: sendNotificationsBloc,
      listener: (context, state) {
        if (state is UploadFilesSuccessState) {
          if (state.uploadFileModel.data?.photo != null) {
            ChatUtils.addMessage(
              fromProvider: true, // <- من البروفايدر
              Message(
                content: state.uploadFileModel.data!.photo!,
                createdAt: Timestamp.now(),
                providerId: widget.id.toString(),
                sentAt: Timestamp.now(),
                type: "IMAGE",
                userId: widget.userId,
                senderId: widget.id.toString(),
                isReadUser: false,
                isReadProvider: true,
              ),
            );
          }

          if (state.uploadFileModel.data?.voice != null) {
            ChatUtils.addMessage(
              fromProvider: true, // <- من البروفايدر
              Message(
                content: state.uploadFileModel.data!.voice!,
                createdAt: Timestamp.now(),
                providerId: widget.id.toString(),
                sentAt: Timestamp.now(),
                type: "VOICE",
                userId: widget.userId,
                senderId: widget.id.toString(),
                isReadUser: false,
                isReadProvider: true,
              ),
            );
          }

          widget.scrollController.animateTo(
            widget.scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );

          currentSelectedImage = null;
          currentAudioFile = null;
          isTyping = false;
          setState(() {});
        }
      },
      child: Column(
        children: [
          currentAudioFile != null || currentSelectedImage != null
              ? const SizedBox(height: 35)
              : const SizedBox.shrink(),
          currentAudioFile != null || currentSelectedImage != null
              ? Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                currentSelectedImage != null
                    ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.file(
                        currentSelectedImage!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            currentSelectedImage = null;
                            isTyping = false;
                          });
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
                currentAudioFile != null
                    ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              currentAudioFile = null;
                              isTyping = false;
                            });
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    AudioPlayerWidget(
                      backgroundColor: AppTheme.primary,
                      progressBarColor: Colors.white,
                      audioType: AudioType.directFile,
                      audioPath: currentAudioFile!.path,
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),
              ],
            ),
          )
              : const SizedBox.shrink(),
          Container(
            padding: EdgeInsets.only(
              top: 16.sp,
              right: 16.sp,
              left: 16.sp,
              bottom: 28.sp,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppInput(
                    hint: "${'message'.tr()} ..",
                    controller: messageController,
                    onChanged: (_) => setState(() => isTyping = true),
                    onFieldSubmitted: (val) {
                      if (val.isEmpty) return;
                      _sendTextMessage(val);
                      messageController.clear();
                      isTyping = false;
                    },
                    suffix: SizedBox(
                      width: 45,
                      child: GestureDetector(
                        onTap: () async {
                          currentSelectedImage = await MainServices.getImageUsingImagePicker(
                            ImageSource.gallery,
                          );
                          if (currentSelectedImage != null) setState(() => isTyping = true);
                        },
                        child: Icon(
                          Icons.image,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                isTyping == false
                    ? VoiceRecorderWidget(
                  backgroundColor: AppTheme.primary,
                  onRecorded: (audio) {
                    currentAudioFile = audio;
                    isTyping = true;
                    setState(() {});
                  },
                )
                    : GestureDetector(
                  onTap: () {
                    if (currentSelectedImage != null || currentAudioFile != null) {
                      sendNotificationsBloc.add(
                        UploadFileEvent(
                          image: currentSelectedImage,
                          voice: currentAudioFile,
                        ),
                      );
                    }
                    if (messageController.text.isNotEmpty) {
                      _sendTextMessage(messageController.text);
                      messageController.clear();
                    }
                  },
                  child: Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primary,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}