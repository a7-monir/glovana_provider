import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_styles.dart';
import 'package:glovana_provider/core/design/space_widget.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/widgets/reciever_message_item.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/widgets/send_message_item.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/widgets/sender_message_item.dart';

import '../../../../features/login/bloc.dart' show User, UserResponseModel;
import 'chat_utils.dart';
import 'models/message_model.dart';
import 'models/rooms_model.dart';

class ChatDetailsScreen extends StatefulWidget {
  final UserResponseModel user;

  final String providerId;
  final String userId;
  final String? providerName;
  final String? userName;
  final String? providerImage;
  final String? userImage;

  const ChatDetailsScreen(
      {super.key,
        required this.user,
        this.providerName,
        this.userName,
        this.userImage,
        required this.userId,
        required this.providerId,
        this.providerImage});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  ScrollController scrollController = ScrollController();

  Room? room;

  @override
  initState() {
    ChatUtils.addRoom(
        room: Room(
            userId: widget.userId.toString(),
            providerId: widget.providerId.toString(),
            providerName: widget.providerName ?? "",
            userName: widget.userName,
            userImageUrl: widget.userImage ?? "",
            providerImageUrl: widget.providerImage ?? "",
            lastMessage: "",
            lastMessageType: "",
            lastMessageUserId: "",
            lastMessageDate: null,
            isReadUser: false,
            isReadProvider: false,
            createdAt: Timestamp.fromDate(
              DateTime.now(),
            ))).then((value) {
      room = value;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 90.h,
        elevation: 1,
        leadingWidth: 300.w,
        leading: Padding(
          padding: EdgeInsetsDirectional.only(start: 8.sp),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: CachedNetworkImage(
                  imageUrl: widget.userImage == null ||
                      widget.userImage!.isEmpty ||
                      widget.userImage == "null"
                      ? "https://www.greiner-gmbh.de/fileadmin/images/hairline/galerie/saloneinrichtung_berlin_blacklabel/bl_store_3_big.jpg"
                      : widget.userImage.toString(),
                  height: 50.sp,
                  width: 50.sp,
                  fit: BoxFit.fill,
                ),
              ),
              const WidthSpace(8),
              Text(
                widget.userName ?? "",
                style: AppStyles.black18BoldStyle.copyWith(fontSize: 16.sp),
              ),
            ],
          ),
        ),
        actions: [],
      ),
      body: Column(children: [
        StreamBuilder(
            stream: ChatUtils.getRoomMessages(
              widget.userId.toString(),
              widget.providerId.toString(),
            ),
            builder: (context, snapshot) {
              final messages = snapshot.data?.docs ?? [];

              if (messages.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (scrollController.hasClients) {
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                    );
                  }
                });
              }
              return Expanded(
                child: snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : snapshot.hasError || snapshot.data!.docs.isEmpty
                    ? SizedBox()
                    : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 30),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, i) {
                      Message message = Message.fromJson(
                        snapshot.data!.docs[i].data(),
                      );

                      if (widget.user.data!.user!.id.toString() !=
                          message.senderId.toString()) {
                        return ReceiverMsgItemWidget(
                          message: message,
                          recieverPhoto: widget.providerImage ?? "",
                        );
                      } else {
                        return SenderMsgItemWidget(
                          message: message,
                          senderPhoto: widget.userImage ?? "",
                        );
                      }
                      //  }
                    }),
              );
            }),
        SendMessageWidget(
            scrollController: scrollController,
            providerId: widget.providerId,
            userId: widget.userId,
            user: widget.user,
            providerImage: widget.providerImage,
            providerName: widget.providerName),
      ]),
    );
  }
}
