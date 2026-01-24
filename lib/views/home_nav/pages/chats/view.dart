import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/core/logic/helper_methods.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:glovana_provider/core/design/app_styles.dart';
import 'package:glovana_provider/core/logic/cache_helper.dart';
import 'package:glovana_provider/views/auth/login/view.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/chat_details_screen.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/chat_utils.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/models/rooms_model.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/widgets/one_item_chat.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/widgets/search_chat_widget.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  List<Room> allRooms = [];
  List<Room> filteredRooms = [];
  String searchQuery = '';

  void filterRooms(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (searchQuery.isEmpty) {
        filteredRooms = List.from(allRooms);
      } else {
        filteredRooms = allRooms.where((room) {
          final userName = room.userName?.toLowerCase() ?? '';
          final lastMsg = room.lastMessage?.toLowerCase() ?? '';
          return userName.contains(searchQuery) || lastMsg.contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerId = CacheHelper.id.toString();

    return Scaffold(
      appBar: MainAppBar(
        title: LocaleKeys.chats.tr(),
        backgroundColor: const Color(0xffFFE9D8),
        withBack: false,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffFFE9D8),
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(30.r),
                  bottomEnd: Radius.circular(30.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w).copyWith(bottom: 15.h),
                child: SearchChatWidget(onSearchChanged: filterRooms),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: StreamBuilder(
                stream: ChatUtils.getRooms(providerId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                        style: AppStyles.black15BoldStyle,
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'no_data'.tr(),
                        style: AppStyles.black15BoldStyle.copyWith(
                          color: AppTheme.primary,
                        ),
                      ),
                    );
                  }


                  allRooms = snapshot.data!.docs
                      .map((d) => Room.fromJson(d.data(), docId: d.id))
                      .toList();

                  // Apply search filter
                  filteredRooms = searchQuery.isEmpty
                      ? List.from(allRooms)
                      : allRooms.where((room) {
                    final userName = room.userName?.toLowerCase() ?? '';
                    final lastMsg = room.lastMessage?.toLowerCase() ?? '';
                    return userName.contains(searchQuery) || lastMsg.contains(searchQuery);
                  }).toList();

                  if (filteredRooms.isEmpty) {
                    return Center(
                      child: Text(
                        'no_data'.tr(),
                        style: AppStyles.black15BoldStyle.copyWith(
                          color: AppTheme.primary,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredRooms.length,
                    itemBuilder: (context, index) {
                      final room = filteredRooms[index];

                      return OnePersonChatItem(
                        room: room,
                        onTap: () async {
                          final isLoggedIn = CacheHelper.isAuthed;
                          if (!isLoggedIn) {
                            navigateTo(const LoginView(), keepHistory: false);
                            return;
                          }
                          await ChatUtils.markMessagesAsRead(roomId: room.id!);

                          navigateTo(
                            ChatDetailsScreen(
                              providerId: CacheHelper.id.toString(),
                              providerName: CacheHelper.name,
                              providerImage: CacheHelper.photo.isEmpty ? null : CacheHelper.photo,
                              userId: room.userId ?? '0',
                              userName: room.userName ?? '',
                              userImage: room.userImageUrl ?? '',
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}