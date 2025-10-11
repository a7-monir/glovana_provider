import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:glovana_provider/views/home_nav/pages/appointments/view.dart';
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
        child: SafeArea(
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
                  ),
                ),
              ),
            ),
          ),
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
  });

  final String title, icon;
  final bool isActive;

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
          AppImage(
            icon,
            height: 24.r,
            width: 24.r,
            color:
            isActive
                ? Theme.of(context).secondaryHeaderColor
                : Theme.of(context).primaryColor,
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
