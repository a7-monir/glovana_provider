import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/logic/cache_helper.dart';

import 'package:glovana_provider/views/home_nav/pages/appointments/view.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/chat_utils.dart';
import 'package:glovana_provider/views/home_nav/pages/chat/models/rooms_model.dart';
import 'package:glovana_provider/views/home_nav/pages/chats/view.dart';
import 'package:glovana_provider/views/home_nav/pages/profile/view.dart';


import '../../core/app_theme.dart';
import '../../core/design/app_image.dart';
import '../../generated/locale_keys.g.dart';


class HomeNavView extends StatefulWidget {
  final int? pageIndex;

  const HomeNavView({super.key, this.pageIndex});

  @override
  State<HomeNavView> createState() => _HomeNavViewState();
}

class _HomeNavViewState extends State<HomeNavView> {
  int _selectedIndex = 0;
  var pages = [];

  @override
  void initState() {
    pages = [
      const AppointmentsView(),
      const ChatsView(),
      const ProfileView(),
    ];
    if (widget.pageIndex != null && widget.pageIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = widget.pageIndex!;
      });
    }

    super.initState();
  }

  List<String> title = [
    LocaleKeys.appointments,
    LocaleKeys.chats,
    LocaleKeys.profile,
  ];

  List<String> icons = [
    'calender.png',
    'chat.png',
    'user.png',
  ];

  List<Room> allRooms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Container(
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: AppTheme.containerColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.r,
              offset: const Offset(0, -4),
              color: Colors.black.withValues(alpha: .25),
            ),
          ],
        ),
        child: StreamBuilder(
            stream: ChatUtils.getRooms(CacheHelper.id.toString()),
          builder: (context, snapshot) {
            allRooms = snapshot.data!.docs
                .map((d) => Room.fromJson(d.data(), docId: d.id))
                .toList();
            return SafeArea(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    title.length,
                        (index) => InkWell(
                      onTap: () {
                        _selectedIndex = index;
                        setState(() {});
                      },
                      child: NavBarItem(
                        title: title[index].tr(),
                        icon: icons[index],
                        isActive: _selectedIndex == index,
                        isLabelVisible: index==1&&allRooms.any((element) => element.unreadCountProvider>0,),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ),
      body: pages[_selectedIndex],
    );
  }
}

class NavBarItem extends StatelessWidget {
  const NavBarItem({
    super.key,
    required this.title,
    required this.icon,
    required this.isActive,

    required this.isLabelVisible,
  });

  final String title, icon;
  final bool isActive,isLabelVisible;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : null,
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: [
          if (isActive)
            BoxShadow(
              blurRadius: 4.r,
              offset: const Offset(0, 4),
              color: Colors.black.withValues(alpha: .25),
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Badge(
            smallSize: 8.r,
            isLabelVisible: isLabelVisible,
           // backgroundColor: withBadge?:t,
            child: SizedBox(
              width: 35.w,
              child: AppImage(
                icon,
                height: 24.r,
                width: 24.r,
                color:
                isActive
                    ? Theme.of(context).secondaryHeaderColor
                    : Theme.of(context).primaryColor,
              ),
            ),
          ),
          if (isActive) ...[
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
