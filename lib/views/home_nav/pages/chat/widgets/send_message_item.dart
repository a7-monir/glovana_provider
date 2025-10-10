// import 'dart:developer';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:glovana_provider/core/utils/app_ui.dart';
// import 'package:glovana_provider/core/utils/constants.dart';
// import 'package:glovana_provider/core/utils/main_services.dart';
// import 'package:glovana_provider/core/widgets/custom_text_field.dart';
// import 'package:glovana_provider/core/widgets/space_widgets.dart';
// import 'package:glovana_provider/features/auth/models/user_response_model.dart';
// import 'package:glovana_provider/features/chat/chat_utils.dart';
// import 'package:glovana_provider/features/chat/models/message_model.dart';
//
// import 'package:glovana_provider/features/main/cubit/home_cubit.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:voice_note_kit/voice_note_kit.dart';
//
// class SendMessageWidget extends StatefulWidget {
//   final UserResponseModel user;
//
//   final String providerId;
//   final String userId;
//   final String? providerName;
//   final String? providerImage;
//   final ScrollController scrollController;
//
//   const SendMessageWidget(
//       {super.key,
//       required this.user,
//       this.providerName,
//       required this.providerId,
//       required this.userId,
//       required this.scrollController,
//       this.providerImage});
//
//   @override
//   State<SendMessageWidget> createState() => _SendMessageWidgetState();
// }
//
// class _SendMessageWidgetState extends State<SendMessageWidget> {
//   File? currentSelectedImage;
//
//   File? currentAudioFile;
//   File? currentSelectedFile;
//   TextEditingController messageController = TextEditingController();
//
//   bool isTyping = false;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         currentAudioFile != null || currentSelectedImage != null
//             ? const SizedBox(
//                 height: 35,
//               )
//             : const SizedBox.shrink(),
//         currentAudioFile != null || currentSelectedImage != null
//             ? Container(
//                 width: Constants.getwidth(context),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     currentSelectedImage == null
//                         ? const SizedBox.shrink()
//                         : Stack(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(30),
//                                 child: Image.file(
//                                   currentSelectedImage!,
//                                   width: 100,
//                                   height: 100,
//                                   fit: BoxFit.fill,
//                                 ),
//                               ),
//                               Positioned(
//                                   top: 10,
//                                   right: 10,
//                                   child: GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           currentSelectedImage = null;
//                                           isTyping = false;
//                                         });
//                                       },
//                                       child: Container(
//                                           height: 30,
//                                           width: 30,
//                                           decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(30)),
//                                           child: const Icon(
//                                             Icons.close,
//                                             color: Colors.black,
//                                           )))),
//                             ],
//                           ),
//                     currentAudioFile == null
//                         ? const SizedBox.shrink()
//                         : Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           currentAudioFile = null;
//                                           isTyping = false;
//                                         });
//                                       },
//                                       child: Container(
//                                           height: 30,
//                                           width: 30,
//                                           decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(30)),
//                                           child: const Icon(
//                                             Icons.delete,
//                                             color: Colors.redAccent,
//                                           ))),
//                                 ],
//                               ),
//                               HeightSpace(8),
//                               AudioPlayerWidget(
//                                   backgroundColor: AppColors.primaryColor,
//                                   progressBarColor: Colors.white,
//                                   audioType: AudioType.directFile,
//                                   audioPath: currentAudioFile!.path),
//                             ],
//                           ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     currentSelectedFile == null
//                         ? const SizedBox.shrink()
//                         : Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       currentSelectedFile = null;
//                                     });
//                                   },
//                                   child: Container(
//                                       height: 30,
//                                       width: 30,
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(30)),
//                                       child: const Icon(
//                                         Icons.close,
//                                         color: Colors.black,
//                                       ))),
//                               Container(
//                                 padding: const EdgeInsets.all(10),
//                                 child: Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.file_copy_outlined,
//                                       size: 30,
//                                       color: Colors.grey,
//                                     ),
//                                     const SizedBox(
//                                       width: 20,
//                                     ),
//                                     SizedBox(
//                                       width: 100,
//                                       child: Text(
//                                         currentSelectedFile!.path!
//                                             .split("/")
//                                             .last
//                                             .toString()!,
//                                         maxLines: 1,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           )
//                   ],
//                 ),
//               )
//             : const SizedBox.shrink(),
//         currentSelectedFile != null
//             ? const SizedBox(
//                 height: 35,
//               )
//             : const SizedBox.shrink(),
//         // showAudioRecorder
//         //     ? SizedBox(
//         //         height: 100,
//         //         child: VoiceRecorderWidget(
//         //           onRecorded: (audio) {
//         //             currentAudioFile = audio;
//
//         //             // chatCubit.sendMessage(
//         //             //     type: MESSAGETYPE.AUDIO,
//         //             //     userId: widget.userId,
//         //             //     roomId: widget.roomId,
//         //             //     file: currentAudioFile);
//
//         //             setState(() {
//         //               showAudioRecorder = false;
//         //             });
//         //           },
//         //           backgroundColor: AppColors.primaryColor,
//         //         ),
//         //       )
//         //     : SizedBox.shrink(),
//         Container(
//           padding: EdgeInsets.only(
//               top: 16.sp, right: 16.sp, left: 16.sp, bottom: 28.sp),
//           decoration: BoxDecoration(color: Colors.white, boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 5,
//               blurRadius: 7,
//               offset: const Offset(0, 3), // changes position of shadow
//             ),
//           ]),
//           child: Row(
//             children: [
//               Expanded(
//                 child: CustomTextField(
//                   hintText: "${'message'.tr()} ..",
//                   controller: messageController,
//                   onChanged: (value) {
//                     setState(() {
//                       isTyping = true;
//                     });
//                   },
//                   onSubmit: (val) {
//                     setState(() {
//                       isTyping = false;
//                     });
//                     ChatUtils.addMessage(Message(
//                             content: val,
//                             createdAt: Timestamp.now(),
//                             providerId: widget.providerId,
//                             sentAt: Timestamp.now(),
//                             type: "TEXT",
//                             userId: widget.userId.toString() ?? "0",
//                             senderId: widget.providerId.toString() ?? "0",
//                             isReadUser: true,
//                             isReadProvider: false))
//                         .then((v) {
//                       context.read<HomeCubit>().sendNotification(
//                             userId: widget.providerId,
//                             title: "you_have_a_message".tr(),
//                             body: val +
//                                 "\n" +
//                                 "from".tr() +
//                                 " " +
//                                 (widget.user.data?.user?.name ?? ""),
//                           );
//                       widget.scrollController.animateTo(
//                           widget.scrollController.position.maxScrollExtent,
//                           duration: const Duration(milliseconds: 200),
//                           curve: Curves.easeOut);
//                     });
//                     messageController.clear();
//                   },
//                   borderRadius: 15,
//                   suffixIcon: SizedBox(
//                     width: Constants.getwidth(context) * 0.1,
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () async {
//                             currentSelectedImage =
//                                 await MainServices.getImageUsingImagePicker(
//                                     ImageSource.gallery);
//                             if (currentSelectedImage != null) {
//                               setState(() {
//                                 isTyping = true;
//                               });
//                             }
//                           },
//                           child: const Icon(
//                             Icons.image,
//                             color: AppColors.primaryColor,
//                             size: 25,
//                           ),
//                         ),
//                         // const SizedBox(
//                         //   width: 10,
//                         // ),
//                         // GestureDetector(
//                         //     onTap: () async {
//                         //       currentSelectedFile =
//                         //           await MainServices.pickDocumentFile();
//                         //       if (currentSelectedFile != null) {
//                         //         setState(() {});
//                         //       }
//                         //     },
//                         //     child: const Icon(
//                         //       Icons.attach_file,
//                         //       color: Colors.grey,
//                         //       size: 25,
//                         //     )),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 width: 16,
//               ),
//               isTyping == false
//                   ? VoiceRecorderWidget(
//                       enableHapticFeedback: true,
//                       onRecorded: (audio) {
//                         setState(() {
//                           currentAudioFile = audio;
//                           isTyping = true;
//                         });
//
//                         // chatCubit.sendMessage(
//                         //     type: MESSAGETYPE.AUDIO,
//                         //     userId: widget.userId,
//                         //     roomId: widget.roomId,
//                         //     file: currentAudioFile);
//                       },
//                       backgroundColor: AppColors.primaryColor,
//                     )
//                   :
//                   // InkWell(
//                   //   onTap: () {
//                   //     setState(() {
//                   //       showAudioRecorder = !showAudioRecorder;
//                   //     });
//                   //   },
//                   //   child: Container(
//                   //     height: 46.sp,
//                   //     width: 46.sp,
//                   //     padding:
//                   //         const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                   //     decoration: BoxDecoration(
//                   //       shape: BoxShape.circle,
//                   //       color: const Color.fromARGB(255, 106, 63, 61),
//                   //     ),
//                   //     child: const Icon(
//                   //       Icons.mic,
//                   //       color: Colors.white,
//                   //       size: 25,
//                   //     ),
//                   //   ),
//                   // ),
//
//                   InkWell(
//                       onTap: () async {
//                         if (currentSelectedFile != null) {
//                           // chatCubit.sendMessage(
//                           //     type: MESSAGETYPE.FILE,
//                           //     userId: widget.userId,
//                           //     roomId: widget.roomId,
//                           //     file: currentSelectedFile!);
//                         }
//                         if (currentSelectedImage != null ||
//                             currentAudioFile != null) {
//                           context
//                               .read<HomeCubit>()
//                               .uploadFile(
//                                   image: currentSelectedImage,
//                                   voice: currentAudioFile)
//                               .then((uploadFileModel) {
//                             if (uploadFileModel != null) {
//                               if (uploadFileModel.data?.photo != null) {
//                                 ChatUtils.addMessage(Message(
//                                         content:
//                                             uploadFileModel.data?.photo ?? "",
//                                         createdAt: Timestamp.now(),
//                                         providerId: widget.providerId,
//                                         sentAt: Timestamp.now(),
//                                         type: "IMAGE",
//                                         userId: widget.userId.toString() ?? "0",
//                                         senderId:
//                                             widget.providerId.toString() ?? "0",
//                                         isReadUser: true,
//                                         isReadProvider: false))
//                                     .then((val) {
//                                   widget.scrollController.animateTo(
//                                       widget.scrollController.position
//                                           .maxScrollExtent,
//                                       duration:
//                                           const Duration(milliseconds: 200),
//                                       curve: Curves.easeOut);
//                                   context.read<HomeCubit>().sendNotification(
//                                         userId: widget.providerId,
//                                         title: "you_have_a_message".tr(),
//                                         body: "from".tr() +
//                                             " " +
//                                             (widget.user.data?.user?.name ??
//                                                 ""),
//                                       );
//                                 });
//                               }
//                               if (uploadFileModel.data?.voice != null) {
//                                 ChatUtils.addMessage(Message(
//                                         content:
//                                             uploadFileModel.data?.voice ?? "",
//                                         createdAt: Timestamp.now(),
//                                         providerId: widget.providerId,
//                                         sentAt: Timestamp.now(),
//                                         type: "VOICE",
//                                         userId: widget.userId.toString() ?? "0",
//                                         senderId:
//                                             widget.providerId.toString() ?? "0",
//                                         isReadUser: true,
//                                         isReadProvider: false))
//                                     .then((val) {
//                                   widget.scrollController.animateTo(
//                                       widget.scrollController.position
//                                           .maxScrollExtent,
//                                       duration:
//                                           const Duration(milliseconds: 200),
//                                       curve: Curves.easeOut);
//                                   context.read<HomeCubit>().sendNotification(
//                                         userId: widget.providerId,
//                                         title: "you_have_a_message".tr(),
//                                         body: "from".tr() +
//                                             " " +
//                                             (widget.user.data?.user?.name ??
//                                                 ""),
//                                       );
//                                 });
//                                 // chatCubit.sendMessage(
//                                 //     type: MESSAGETYPE.AUDIO,
//                                 //     userId: widget.userId,
//                                 //     roomId: widget.roomId,
//                                 //     file: currentAudioFile!);
//                               }
//                             }
//                           });
//
//                           // chatCubit.sendMessage(
//                           //     type: MESSAGETYPE.IMAGE,
//                           //     userId: widget.userId,
//                           //     roomId: widget.roomId,
//                           //     file: currentSelectedImage!);
//                         }
//
//                         if (messageController.text.isNotEmpty) {
//                           String message = messageController.text;
//                           ChatUtils.addMessage(Message(
//                                   content: messageController.text,
//                                   createdAt: Timestamp.now(),
//                                   providerId: widget.providerId,
//                                   sentAt: Timestamp.now(),
//                                   type: "TEXT",
//                                   userId: widget.userId.toString() ?? "0",
//                                   senderId: widget.providerId.toString() ?? "0",
//                                   isReadUser: true,
//                                   isReadProvider: false))
//                               .then((val) {
//                             widget.scrollController.animateTo(
//                                 widget
//                                     .scrollController.position.maxScrollExtent,
//                                 duration: const Duration(milliseconds: 200),
//                                 curve: Curves.easeOut);
//
//                             context.read<HomeCubit>().sendNotification(
//                                   userId: widget.providerId,
//                                   title: "you_have_a_message".tr(),
//                                   body: message +
//                                       "\n" +
//                                       "from".tr() +
//                                       " " +
//                                       (widget.user.data?.user?.name ?? ""),
//                                 );
//                           });
//                           messageController.clear();
//                         }
//
//                         messageController.clear();
//                         currentSelectedFile = null;
//                         currentAudioFile = null;
//                         currentSelectedImage = null;
//                         isTyping = false;
//                         setState(() {});
//                       },
//                       child: Container(
//                         height: 46,
//                         width: 46,
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 10, horizontal: 10),
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: AppColors.primaryColor,
//                         ),
//                         child: const Icon(
//                           Icons.send_sharp,
//                           color: Colors.white,
//                           size: 25,
//                         ),
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
