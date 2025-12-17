
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/core/design/app_empty.dart';
import 'package:glovana_provider/core/logic/cache_helper.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/widgets/one_item_chat.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/widgets/search_chat_widget.dart';


import 'chat_utils.dart';
import 'models/rooms_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //User? userResponseModel;

  List<Room> allRooms = [];
  List<Room> filteredRooms = [];
  String searchQuery = '';

  // @override
  // void initState() {
  //   StorageHelper.getUserData().then((value) {
  //     userResponseModel = value;
  //     setState(() {});
  //   });
  //   super.initState();
  // }

  void filterRooms(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (searchQuery.isEmpty) {
        filteredRooms = List.from(allRooms);
      } else {
        filteredRooms = allRooms.where((room) {
          return room.providerName!.toLowerCase().contains(searchQuery) ||
              (room.lastMessage?.toLowerCase().contains(searchQuery) ?? false);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: LocaleKeys.chats.tr(), centerTitle: true,),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            SearchChatWidget(onSearchChanged: filterRooms),
            SizedBox(height: 16.h),
            CacheHelper.id != 0
                ? StreamBuilder(
                    stream: ChatUtils.getRooms(CacheHelper.id.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }
                      if (snapshot.hasData) {
                        // Update allRooms and filteredRooms when new data arrives
                        allRooms = snapshot.data!.docs
                            .map((doc) => Room.fromJson(doc.data()))
                            .toList();

                        if (searchQuery.isEmpty) {
                          filteredRooms = List.from(allRooms);
                        }

                        if (filteredRooms.isEmpty) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: AppEmpty(title: LocaleKeys.chats.tr()),
                          );
                        }

                        return Expanded(
                          child: ListView.builder(
                            itemCount: filteredRooms.length,
                            itemBuilder: (context, index) {
                              Room room = filteredRooms[index];
                              return OnePersonChatItem(
                                room: room,
                                onTap: () async {
                                  // if (userResponseModel != null) {
                                  //   PersistentNavBarNavigator.pushNewScreen(
                                  //     context,
                                  //     screen: ChatDetailsScreen(
                                  //       user: userResponseModel,
                                  //       userImage: room.userImageUrl.toString(),
                                  //       providerName:
                                  //           userResponseModel.data?.user?.name
                                  //               .toString() ??
                                  //           "",
                                  //       userName: room.userName.toString(),
                                  //       userId: room.userId.toString(),
                                  //       providerId:
                                  //           userResponseModel.data?.user?.id
                                  //               .toString() ??
                                  //           "",
                                  //       providerImage: userResponseModel
                                  //           .data
                                  //           ?.user
                                  //           ?.photoUrl
                                  //           .toString(),
                                  //     ),
                                  //     withNavBar: false,
                                  //     pageTransitionAnimation:
                                  //         PageTransitionAnimation.cupertino,
                                  //   );
                                  // } else {
                                  //   navigateTo(LoginView(), keepHistory: false);
                                  // }
                                },
                              );
                            },
                          ),
                        );
                      }
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(child: Text("no data")),
                      );
                    },
                  )
                : SizedBox.fromSize(),
          ],
        ),
      ),
    );
  }
}
