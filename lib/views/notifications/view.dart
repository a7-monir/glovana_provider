import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';

import '../../core/design/app_bar.dart';
import '../../core/design/app_empty.dart';
import '../../core/design/app_failed.dart';
import '../../core/design/app_shimmer.dart';
import '../../features/notifications/bloc.dart';
import '../../generated/locale_keys.g.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final bloc = KiwiContainer().resolve<NotificationsBloc>()
    ..add(GetNotificationsEvent());

  // void showFakeNotification() {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //   AndroidNotificationDetails(
  //     'test_channel',
  //     'Test Notifications',
  //     channelDescription: 'Just for demo',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //
  //   const NotificationDetails platformChannelSpecifics =
  //   NotificationDetails(android: androidPlatformChannelSpecifics);
  //   FirebaseMessaging
  //
  //   // flutterLocalNotificationsPlugin.show(
  //   //   0,
  //   //   'Fake Push Notification',
  //   //   'You clicked the button!',
  //   //   platformChannelSpecifics,
  //   // );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: SecondAppBar(title: LocaleKeys.notifications.tr()),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                if (state is GetNotificationsFailedState) {
                  return AppFailed(
                    response: state.response,
                    onPress: () => bloc.add(GetNotificationsEvent()),
                  );
                } else if (state is GetNotificationsSuccessState) {
                  if (state.list.isEmpty) {
                    return AppEmpty(title: LocaleKeys.notifications.tr());
                  }
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 12.h),
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final item = state.list[index];
                      return _Item(model: item);
                    },
                    itemCount: state.list.length,
                  );
                }
                return _Loading();
              },
            ),
          ),
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  final NotificationData model;

  const _Item({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Text(
                    model.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Text(
                    model.body,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
                Text(
                  model.createdAt,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsetsDirectional.all(24.r).copyWith(top: 0),
        itemBuilder: (context, index) => Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 12.w,
            vertical: 16.h,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              CircleAvatar(radius: 28.r),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 18.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 14.h,
                    width: 190.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemCount: 3,
      ),
    );
  }
}
