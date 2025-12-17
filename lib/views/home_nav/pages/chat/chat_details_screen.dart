import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/core/design/app_styles.dart';
import 'package:glovana_provider/core/design/space_widget.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/widgets/reciever_message_item.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/widgets/send_message_item.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/widgets/sender_message_item.dart';
import 'chat_utils.dart';
import 'models/message_model.dart';
import 'models/rooms_model.dart';

import 'package:glovana_provider/core/logic/cache_helper.dart';



class ChatDetailsScreen extends StatefulWidget {
  final dynamic user;

  final String providerId;
  final String userId;
  final String? providerName;
  final String? userName;
  final String? providerImage;
  final String? userImage;

  const ChatDetailsScreen({
    super.key,
    this.user,
    required this.providerId,
    required this.userId,
    this.providerName,
    this.userName,
    this.providerImage,
    this.userImage,
  });

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final ScrollController scrollController = ScrollController();
  Room? room;

  @override
  void initState() {
    super.initState();
    _ensureRoom();
  }

  Future<void> _ensureRoom() async {
    final created = await ChatUtils.addRoom(
      room: Room(
        userId: widget.userId,
        providerId: widget.providerId,
        providerName: widget.providerName ?? '',
        userName: widget.userName,
        userImageUrl: widget.userImage ?? '',
        providerImageUrl: widget.providerImage ?? '',
        lastMessage: '',
        lastMessageType: '',
        lastMessageUserId: '',
        lastMessageDate: null,
        isReadUser: false,
        isReadProvider: false,
        createdAt: Timestamp.fromDate(DateTime.now()),
      ),
    );
    if (mounted) setState(() => room = created);
  }

  @override
  Widget build(BuildContext context) {
    final currentProviderId = CacheHelper.id.toString();

    return Scaffold(

      appBar: MainAppBar(
        backgroundColor: Color(0xffFFE9D8),
        titleWidget: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: (widget.userImage != null &&
                  widget.userImage!.isNotEmpty &&
                  widget.userImage != 'null')
                  ? CachedNetworkImage(
                imageUrl: widget.userImage!,
                height: 50.sp,
                width: 50.sp,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                errorWidget: (context, url, error) => const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              )
                  : const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
            const WidthSpace(8),
            Flexible(
              child: Text(
                widget.userName ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.black18BoldStyle.copyWith(fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ),

      // AppBar(
      //   backgroundColor: Colors.white,
      //   toolbarHeight: 90.h,
      //   elevation: 1,
      //   leadingWidth: 300.w,
      //   leading: Padding(
      //     padding: EdgeInsetsDirectional.only(start: 8.sp),
      //     child: Row(
      //       children: [
      //         InkWell(
      //           onTap: () => Navigator.pop(context),
      //           child: const Icon(Icons.arrow_back_ios, color: Colors.black),
      //         ),
      //         ClipRRect(
      //           borderRadius: BorderRadius.circular(50.r),
      //           child: (widget.userImage != null &&
      //               widget.userImage!.isNotEmpty &&
      //               widget.userImage != 'null')
      //               ? CachedNetworkImage(
      //             imageUrl: widget.userImage!,
      //             height: 50.sp,
      //             width: 50.sp,
      //             fit: BoxFit.cover,
      //             placeholder: (context, url) => const CircleAvatar(
      //               backgroundColor: Colors.grey,
      //               child: Icon(Icons.person, color: Colors.white),
      //             ),
      //             errorWidget: (context, url, error) => const CircleAvatar(
      //               backgroundColor: Colors.grey,
      //               child: Icon(Icons.person, color: Colors.white),
      //             ),
      //           )
      //               : const CircleAvatar(
      //             radius: 25,
      //             backgroundColor: Colors.grey,
      //             child: Icon(Icons.person, color: Colors.white),
      //           ),
      //         ),
      //         const WidthSpace(8),
      //         Flexible(
      //           child: Text(
      //             widget.userName ?? '',
      //             maxLines: 1,
      //             overflow: TextOverflow.ellipsis,
      //             style: AppStyles.black18BoldStyle.copyWith(fontSize: 16.sp),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 20.h,
              decoration: BoxDecoration(
                color: Color(0xffFFE9D8),
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(30.r),
                  bottomEnd: Radius.circular(30.r),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: ChatUtils.getRoomMessages(widget.userId, widget.providerId),
              builder: (context, snapshot) {
                final docs = snapshot.data?.docs ?? [];
        
                if (docs.isNotEmpty) {
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
                      ? const Center(child: CircularProgressIndicator())
                      : (snapshot.hasError || docs.isEmpty)
                      ? const SizedBox.shrink()
                      : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                    itemCount: docs.length,
                    itemBuilder: (context, i) {
                      final message = Message.fromJson(docs[i].data());
                      final senderId = (message.senderId ?? '').toString();
                      final isMe = senderId == currentProviderId;
        
                      return isMe
                          ? SenderMsgItemWidget(
                        message: message,
                        senderPhoto: widget.providerImage ?? '',
                      )
                          : ReceiverMsgItemWidget(
                        message: message,
                        recieverPhoto: widget.userImage ?? '',
                      );
                    },
                  ),
                );
              },
            ),
            // Send box
            SendMessageWidget(
              id: CacheHelper.id,
              name:CacheHelper.name ,
              scrollController: scrollController,
              userId: widget.userId,
              userImage: widget.userImage,
              userName: widget.userName,
            ),
          ],
        ),
      ),
    );
  }
}
