import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/core/logic/helper_methods.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:glovana_provider/core/design/app_colors.dart';
import 'package:glovana_provider/core/design/app_styles.dart';
import 'package:glovana_provider/core/design/space_widget.dart';
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
          final providerName = room.providerName?.toLowerCase() ?? '';
          final lastMsg = room.lastMessage?.toLowerCase() ?? '';
          return providerName.contains(searchQuery) ||
              lastMsg.contains(searchQuery);
        }).toList();
      }
    });
  }

  // Future<void> _seedTestData() async {
  //   final providerId = CacheHelper.id.toString();
  //   const userId = 'test_user_1';
  //   final rooms = FirebaseFirestore.instance.collection('rooms');
  //
  //   final existing = await rooms
  //       .where('provider_id', isEqualTo: providerId)
  //       .where('user_id', isEqualTo: userId)
  //       .limit(1)
  //       .get();
  //
  //   if (existing.docs.isEmpty) {
  //     await rooms.add({
  //       'provider_id': providerId,
  //       'provider_name': CacheHelper.name.isEmpty ? 'Provider' : CacheHelper.name,
  //       'provider_image_url': CacheHelper.photo,
  //       'user_id': userId,
  //       'user_name': 'Test User',
  //       'last_message': 'Hello from seed',
  //       'last_message_type': 'text',
  //       'last_message_user_id': userId,
  //       'last_message_date': FieldValue.serverTimestamp(),
  //       'is_read_user': true,
  //       'is_read_provider': false,
  //     });
  //   }
  //
  //   await FirebaseFirestore.instance.collection('messages').add({
  //     'provider_id': providerId,
  //     'user_id': userId,
  //     'content': 'Ping ${DateTime.now()}',
  //     'type': 'text',
  //     'created_at': FieldValue.serverTimestamp(),
  //     'sent_at': FieldValue.serverTimestamp(),
  //     'sender_id': providerId, // <- make sure your Message model supports this
  //   });
  //
  //   if (mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Seeded test room & message')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final providerId = CacheHelper.id.toString();

    return Scaffold(
      appBar: MainAppBar(
        title: LocaleKeys.chats.tr(),
        backgroundColor: Color(0xffFFE9D8),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: _seedTestData,
      //   child: const Icon(Icons.bolt),
      // ),
      body: Column(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffFFE9D8),
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(30.r),
                  bottomEnd: Radius.circular(30.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                ).copyWith(bottom: 15.h),
                child: SearchChatWidget(onSearchChanged: filterRooms),
              ),
            ),
          ),

          const HeightSpace(16),
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
                      .map((d) => Room.fromJson(d.data()))
                      .toList();
                  filteredRooms = searchQuery.isEmpty
                      ? List.from(allRooms)
                      : allRooms.where((room) {
                          final providerName =
                              room.providerName?.toLowerCase() ?? '';
                          final lastMsg = room.lastMessage?.toLowerCase() ?? '';
                          return providerName.contains(searchQuery) ||
                              lastMsg.contains(searchQuery);
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
                        onTap: () {
                          final isLoggedIn = CacheHelper.isAuthed;
                          if (!isLoggedIn) {
                            navigateTo(const LoginView(), keepHistory: false);
                            return;
                          }
                          navigateTo(
                            ChatDetailsScreen(
                              providerId: CacheHelper.id.toString(),
                              providerName: CacheHelper.name,
                              providerImage: CacheHelper.photo.isEmpty
                                  ? null
                                  : CacheHelper.photo,
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
