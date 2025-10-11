import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_colors.dart';
import 'package:glovana_provider/core/design/app_input.dart';
import 'package:glovana_provider/core/design/constants.dart';
import 'package:glovana_provider/core/design/custom_text_field.dart';
import 'package:glovana_provider/core/design/space_widget.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/chat_utils.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/models/message_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voice_note_kit/voice_note_kit.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SendMessageWidget extends StatefulWidget {
  final Object? user;
  final String providerId;
  final String userId;
  final String? providerName;
  final String? providerImage;
  final ScrollController scrollController;

  const SendMessageWidget({
    super.key,
    this.user,
    required this.providerId,
    required this.userId,
    required this.scrollController,
    this.providerName,
    this.providerImage,
  });

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  File? _imageFile;
  File? _audioFile;

  final TextEditingController _messageController = TextEditingController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _ensureMicPermission();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // ---------- permissions ----------
  Future<bool> _ensurePhotoPermission() async {
    final results = await [Permission.photos, Permission.storage].request();
    final photos = results[Permission.photos];
    final storage = results[Permission.storage];
    return (photos?.isGranted ?? false) || (storage?.isGranted ?? false);
  }

  Future<bool> _ensureMicPermission() async {
    final p = await Permission.microphone.request();
    return p.isGranted;
  }

  // ---------- helpers ----------
  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _scrollToBottomSoon() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController.hasClients) {
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearAll() {
    _imageFile = null;
    _audioFile = null;
    _messageController.clear();
    setState(() {});
  }

  // ---------- auth + storage ----------
  // Future<void> _ensureSignedIn() async {
  //   final auth = FirebaseAuth.instance;
  //   if (auth.currentUser == null) {
  //     await auth.signInAnonymously();
  //   }
  // }
  Future<void> _ensureSignedIn() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("🔴 User NOT signed in. Signing in anonymously...");
      await FirebaseAuth.instance.signInAnonymously();
    } else {
      print("✅ Already signed in: ${user.uid}");
    }
  }

  String _extFromPath(String p, {String fallback = ''}) {
    final i = p.lastIndexOf('.');
    return (i != -1) ? p.substring(i).toLowerCase() : fallback;
  }

  Future<String> _uploadFile(
      File file,
      String path, {
        String? contentType,
      }) async {
    try {
      await _ensureSignedIn();

      print("File exists? ${await file.exists()}");
      print("File size: ${await file.length()} bytes");
      print("Uploading to path: $path");

      final ref = FirebaseStorage.instance.ref(path);

      final meta = SettableMetadata(
        contentType: contentType ?? 'application/octet-stream',
      );

      final uploadTask = await ref.putFile(file, meta);

      print("✅ Upload success, getting URL...");
      final url = await ref.getDownloadURL();
      print("✅ Download URL: $url");

      return url;
    } catch (e, s) {
      print("❌ Upload failed: $e");
      print(s);
      rethrow;
    }
  }

  // ---------- sending ----------
  Future<void> _sendText() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    await ChatUtils.addMessage(
      Message(
        content: text,
        createdAt: Timestamp.now(),
        sentAt: Timestamp.now(),
        type: 'TEXT',
        providerId: widget.providerId,
        userId: widget.userId,
        senderId: widget.providerId,
        isReadUser: true,
        isReadProvider: false,
      ),
    );

    _scrollToBottomSoon();
  }

  Future<void> _sendImage(File image) async {
    final ext = _extFromPath(image.path, fallback: '.jpg');
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path =
        'chats/${widget.providerId}_${widget.userId}/images/$fileName$ext';
    print("Uploading to path: $path"); // ✅ سطر التتبع هنا قبل الرفع
    final ct = (ext == '.png') ? 'image/png' : 'image/jpeg';

    final url = await _uploadFile(image, path, contentType: ct);

    await ChatUtils.addMessage(
      Message(
        content: url,
        createdAt: Timestamp.now(),
        sentAt: Timestamp.now(),
        type: 'IMAGE',
        providerId: widget.providerId,
        userId: widget.userId,
        senderId: widget.providerId,
        isReadUser: true,
        isReadProvider: false,
      ),
    );

    _scrollToBottomSoon();
  }

  Future<void> _sendAudio(File audio) async {
    final ext = _extFromPath(audio.path, fallback: '.m4a');
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path =
        'chats/${widget.providerId}_${widget.userId}/audio/$fileName$ext';



    final ct = switch (ext) {
      '.aac' => 'audio/aac',
      '.wav' => 'audio/wav',
      '.mp3' => 'audio/mpeg',
      _ => 'audio/m4a',
    };

    final url = await _uploadFile(audio, path, contentType: ct);

    await ChatUtils.addMessage(
      Message(
        content: url,
        createdAt: Timestamp.now(),
        sentAt: Timestamp.now(),
        type: 'VOICE',
        providerId: widget.providerId,
        userId: widget.userId,
        senderId: widget.providerId,
        isReadUser: true,
        isReadProvider: false,
      ),
    );

    _scrollToBottomSoon();
  }

  // ---------- pickers ----------
  Future<void> _pickImage() async {
    if (!await _ensurePhotoPermission()) {
      _toast('Photos permission required');
      return;
    }
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      // enforce one-of
      _audioFile = null;
      _imageFile = File(picked.path);
      setState(() {});
    }
  }

  bool get _hasAnythingToSend =>
      _messageController.text.trim().isNotEmpty ||
      _imageFile != null ||
      _audioFile != null;

  @override
  Widget build(BuildContext context) {
    final w = Constants.getwidth(context);

    return Column(
      children: [
        if (_imageFile != null || _audioFile != null)
          const SizedBox(height: 35),
        if (_imageFile != null || _audioFile != null)
          Container(
            width: w,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_imageFile != null)
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _imageFile!,
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => setState(() => _imageFile = null),
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.close, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (_audioFile != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _audioFile = null),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const HeightSpace(8),
                  AudioPlayerWidget(
                    backgroundColor: AppTheme.primary,
                    progressBarColor: Colors.white,
                    audioType: AudioType.directFile,
                    audioPath: _audioFile!.path,
                  ),
                ],
              ],
            ),
          ),

        Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: AppInput(
                  marginBottom: 0,
                  hint:
                      'Message ..', // plain text avoids missing-key warning
                  controller: _messageController,
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) async {
                    if (_sending) return;
                    if (_imageFile != null || _audioFile != null)
                      return; // text-only if no attachments
                    setState(() => _sending = true);
                    try {
                      await _sendText();
                      _clearAll();
                    } catch (e) {
                      _toast('1111Send failed: $e');
                    } finally {
                      setState(() => _sending = false);
                    }
                  },

                  suffix: SizedBox(
                    width: w * 0.22,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (_sending) return;
                            await _pickImage();
                          },
                          child:  Icon(
                            Icons.image,
                            color: AppTheme.primary,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
               SizedBox(width: 16.w),

              if (!_hasAnythingToSend)
                VoiceRecorderWidget(
                  enableHapticFeedback: true,
                  onStartRecording: () async {
                    final ok = await _ensureMicPermission();
                    if (!ok) _toast('Microphone permission required');
                    _imageFile = null;
                    setState(() {});
                  },
                  onRecorded: (audio) async {
                    setState(() => _audioFile = audio);
                  },
                  onError: (err) => _toast(err),

                  backgroundColor: AppTheme.primary,

                )
              else
                InkWell(
                  onTap: () async {
                    if (_sending) return;
                    setState(() => _sending = true);
                    try {
                      if (_imageFile != null) {
                        await _sendImage(_imageFile!);
                      } else if (_audioFile != null) {
                        await _sendAudio(_audioFile!);
                      } else {
                        await _sendText();
                      }
                      _clearAll();
                    } catch (e) {
                      _toast('2222Send failed: $e');
                      print("2222Send failed:$e");
                    } finally {
                      setState(() => _sending = false);
                    }
                  },
                  child: _sending
                      ?  Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primary,
                          ),
                        )
                      :  Icon(
                          Icons.send_sharp,
                          color: AppTheme.primary,
                          size: 24,
                        ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
