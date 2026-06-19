import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_input.dart';
import 'package:glovana_provider/core/logic/cache_helper.dart';
import 'package:glovana_provider/core/logic/helper_methods.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/chat_utils.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/models/message_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiwi/kiwi.dart';
import 'package:voice_note_kit/voice_note_kit.dart';

import '../../../../../core/design/main_services.dart';
import '../../../../../features/send_notification/bloc.dart';
import '../models/rooms_model.dart';

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
  final sendNotificationsBloc = KiwiContainer()
      .resolve<SendNotificationsBloc>();

  File? currentSelectedImage;
  File? currentAudioFile;

  final TextEditingController messageController = TextEditingController();
  bool isTyping = false;
  bool isSending = false;

  bool get _hasAttachments =>
      currentSelectedImage != null || currentAudioFile != null;

  void _syncTypingState([String? value]) {
    final hasText = (value ?? messageController.text).trim().isNotEmpty;
    isTyping = hasText || _hasAttachments;
  }

  Future<void> _ensureRoomExists() async {
    await ChatUtils.addRoom(
      room: Room(
        userId: widget.userId,
        providerId: widget.id.toString(),
        providerName: widget.name,
        userName: widget.userName ?? '',
        userImageUrl: widget.userImage ?? '',
        providerImageUrl: CacheHelper.photo,
        isActive: true,
      ),
    );
  }

  void _notifyUser(String body) {
    sendNotificationsBloc.add(
      SendNotificationsEvent(
        userId: widget.userId,
        title: LocaleKeys.youHaveAMessage.tr(),
        body: body,
      ),
    );
  }

  Future<void> _sendMessage({
    required String content,
    required String type,
    String? notificationBody,
  }) async {
    await _ensureRoomExists();
    await ChatUtils.addMessage(
      fromProvider: true,
      Message(
        content: content,
        createdAt: Timestamp.now(),
        providerId: widget.id.toString(),
        sentAt: Timestamp.now(),
        userType: 'provider',
        type: type,
        userId: widget.userId,
        senderId: widget.id.toString(),
        isReadUser: false,
        isReadProvider: true,
      ),
    );

    if (notificationBody != null && notificationBody.isNotEmpty) {
      _notifyUser(notificationBody);
    }
  }

  Future<bool> _sendTextMessage(String text) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) {
      return false;
    }

    try {
      await _sendMessage(
        content: trimmedText,
        type: "TEXT",
        notificationBody:
            "$trimmedText\n${LocaleKeys.from.tr()} ${widget.name}",
      );
      return true;
    } catch (e) {
      showMessage(e.toString());
      return false;
    }
  }

  Future<void> _sendUploadedMessage({
    required String content,
    required String type,
  }) async {
    await _sendMessage(
      content: content,
      type: type,
      notificationBody:
          "${LocaleKeys.youHaveAMessage.tr()}\n${LocaleKeys.from.tr()} ${widget.name}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendNotificationsBloc, SendNotificationsStates>(
      bloc: sendNotificationsBloc,
      listener: (context, state) async {
        if (state is UploadFilesSuccessState) {
          try {
            if (state.uploadFileModel.data?.photo != null) {
              await _sendUploadedMessage(
                content: state.uploadFileModel.data!.photo!,
                type: "IMAGE",
              );
            }

            if (state.uploadFileModel.data?.voice != null) {
              await _sendUploadedMessage(
                content: state.uploadFileModel.data!.voice!,
                type: "VOICE",
              );
            }
          } catch (e) {
            showMessage(e.toString());
          }

          if (widget.scrollController.hasClients) {
            widget.scrollController.animateTo(
              widget.scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }

          if (!mounted) return;
          setState(() {
            currentSelectedImage = null;
            currentAudioFile = null;
            messageController.clear();
            isTyping = false;
            isSending = false;
          });
        }

        if (state is UploadFilesFailedState) {
          showMessage(state.msg);
          if (!mounted) return;
          setState(() {
            isSending = false;
            _syncTypingState();
          });
        }
      },
      child: Column(
        children: [
          if (_hasAttachments) const SizedBox(height: 35),
          if (_hasAttachments)
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentSelectedImage != null)
                    Stack(
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
                                _syncTypingState();
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
                    ),
                  if (currentAudioFile != null)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentAudioFile = null;
                                  _syncTypingState();
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
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
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
                  color: Colors.grey.withValues(alpha: 0.5),
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppInput(
                    hint: "${LocaleKeys.message.tr()} ..",
                    controller: messageController,
                    onChanged: (value) =>
                        setState(() => _syncTypingState(value)),
                    onFieldSubmitted: (val) async {
                      if (isSending) return;
                      if (val.isEmpty) return;
                      setState(() {
                        isSending = true;
                      });
                      final sent = await _sendTextMessage(val);
                      if (!mounted) return;
                      setState(() {
                        if (sent) {
                          messageController.clear();
                        }
                        isSending = false;
                        _syncTypingState();
                      });
                    },
                    suffix: SizedBox(
                      width: 45,
                      child: GestureDetector(
                        onTap: () async {
                          final image =
                              await MainServices.getImageUsingImagePicker(
                                ImageSource.gallery,
                              );
                          if (!mounted) return;
                          setState(() {
                            currentSelectedImage = image;
                            _syncTypingState();
                          });
                        },
                        child: Icon(Icons.image, color: AppTheme.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                isTyping == false
                    ? VoiceRecorderWidget(
                        backgroundColor: AppTheme.primary,
                        onRecorded: (audio) {
                          setState(() {
                            currentAudioFile = audio;
                            _syncTypingState();
                          });
                        },
                      )
                    : GestureDetector(
                        onTap: () async {
                          if (isSending) return;

                          final hasAttachments = _hasAttachments;
                          final messageText = messageController.text.trim();

                          if (!hasAttachments && messageText.isEmpty) {
                            setState(() {
                              _syncTypingState();
                            });
                            return;
                          }

                          setState(() {
                            isSending = true;
                          });

                          if (hasAttachments) {
                            sendNotificationsBloc.add(
                              UploadFileEvent(
                                image: currentSelectedImage,
                                voice: currentAudioFile,
                              ),
                            );
                          }

                          if (messageText.isNotEmpty) {
                            final sent = await _sendTextMessage(messageText);
                            if (!mounted) return;
                            setState(() {
                              if (sent) {
                                messageController.clear();
                              }
                              if (!hasAttachments) {
                                isSending = false;
                              }
                              _syncTypingState();
                            });
                          } else if (!hasAttachments && mounted) {
                            setState(() {
                              isSending = false;
                              _syncTypingState();
                            });
                          }
                        },
                        child: Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primary,
                          ),
                          child: isSending
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.send, color: Colors.white),
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
