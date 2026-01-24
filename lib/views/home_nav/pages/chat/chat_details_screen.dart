import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/core/design/app_styles.dart';
import 'package:glovana_provider/core/design/space_widget.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/widgets/reciever_message_item.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/widgets/send_message_item.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/widgets/sender_message_item.dart';
import 'chat_utils.dart';
import 'models/message_model.dart';
import 'models/rooms_model.dart';
import 'package:glovana_provider/core/logic/cache_helper.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String providerId;
  final String userId;
  final String? providerName;
  final String? userName;
  final String? providerImage;
  final String? userImage;

  const ChatDetailsScreen({
    super.key,
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

  @override
  void initState() {
    super.initState();
    _ensureRoom();
  }

  Future<void> _ensureRoom() async {
    final roomQuery = await FirebaseFirestore.instance
        .collection('rooms')
        .where('user_id', isEqualTo: widget.userId)
        .where('provider_id', isEqualTo: widget.providerId)
        .limit(1)
        .get();

    if (roomQuery.docs.isEmpty) {
      await ChatUtils.addRoom(
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
          isReadProvider: true,
          isActive: true,
          createdAt: Timestamp.fromDate(DateTime.now()),
        ),
      );
    }
  }

  Stream<Room?> _roomStream() {
    return FirebaseFirestore.instance
        .collection('rooms')
        .where('user_id', isEqualTo: widget.userId)
        .where('provider_id', isEqualTo: widget.providerId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return Room.fromJson(
            snapshot.docs.first.data(),
            docId: snapshot.docs.first.id,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final currentProviderId = CacheHelper.id.toString();

    return Scaffold(
      appBar: MainAppBar(
        backgroundColor: const Color(0xffFFE9D8),
        titleWidget: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child:
                  (widget.userImage != null &&
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 20.h,
              decoration: BoxDecoration(
                color: const Color(0xffFFE9D8),
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(30.r),
                  bottomEnd: Radius.circular(30.r),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<Room?>(
                stream: _roomStream(),
                builder: (context, roomSnapshot) {
                  final roomData = roomSnapshot.data;

                  if (roomData == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    children: [
                      Expanded(
                        child:
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: ChatUtils.getRoomMessages(
                                widget.userId,
                                widget.providerId,
                              ),
                              builder: (context, snapshot) {
                                final docs = snapshot.data?.docs ?? [];

                                if (docs.isNotEmpty) {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    if (scrollController.hasClients) {
                                      scrollController.animateTo(
                                        scrollController
                                            .position
                                            .maxScrollExtent,
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        curve: Curves.easeOut,
                                      );
                                    }
                                  });
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasError || docs.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                return ListView.builder(
                                  controller: scrollController,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 30,
                                  ),
                                  itemCount: docs.length,
                                  itemBuilder: (context, i) {
                                    final message = Message.fromJson(
                                      docs[i].data(),
                                    );
                                    final senderId = (message.senderId ?? '')
                                        .toString();

                                    final isMe =
                                        (senderId == currentProviderId &&
                                        message.userType == 'provider');
                                    return isMe
                                        ? SenderMsgItemWidget(
                                            message: message,
                                            senderPhoto:
                                                widget.providerImage ?? '',
                                          )
                                        : ReceiverMsgItemWidget(
                                          message: message,
                                          recieverPhoto:
                                              widget.userImage ?? '',
                                        );
                                  },
                                );
                              },
                            ),
                      ),

                      if (roomData.isActive == false)
                        Padding(
                          padding: EdgeInsets.all(16.sp),
                          child: Center(
                            child: Text(
                              LocaleKeys.chatEndedMessage.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      if (roomData.isActive == true)
                        SendMessageWidget(
                          id: CacheHelper.id,
                          name: CacheHelper.name,
                          scrollController: scrollController,
                          userId: widget.userId,
                          userImage: widget.userImage,
                          userName: widget.userName,
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
