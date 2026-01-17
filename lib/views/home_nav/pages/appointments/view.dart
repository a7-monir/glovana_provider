import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_image.dart';
import 'package:glovana_provider/core/design/app_refresh.dart';
import 'package:glovana_provider/features/appointments/bloc.dart';
import 'package:glovana_provider/views/notifications/view.dart';
import 'package:kiwi/kiwi.dart';
import '../../../../core/app_theme.dart';
import '../../../../core/design/app_bar.dart';
import '../../../../core/design/app_circle_icon.dart';
import '../../../../core/design/app_empty.dart';
import '../../../../core/design/app_failed.dart';
import '../../../../core/design/app_shimmer.dart';
import '../../../../core/logic/helper_methods.dart';
import '../../../../features/provider_profile/bloc.dart';
import '../../../../features/provider_update_status/bloc.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../appointment_details/view.dart';
import '../../../setting/view.dart';

class AppointmentsView extends StatefulWidget {
  const AppointmentsView({super.key});

  @override
  State<AppointmentsView> createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<AppointmentsView> {
  final bloc = KiwiContainer().resolve<GetAppointmentsBloc>();

  Future<void> selectDateRange() async {
    final DateTime now = DateTime.now();
    final DateTime fiveYearsAgo = DateTime(now.year - 5);

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: fiveYearsAgo,
      lastDate: now,
      locale: const Locale('en'),
      helpText: 'Select Date Range',
      saveText: 'Done',
      builder: (context, child) {
        return child!;
      },
    );

    if (picked != null) {
      bloc.startDate = DateFormat("yyyy-MM-dd", "en").format(picked.start);
      bloc.endDate = DateFormat("yyyy-MM-dd", "en").format(picked.end);
      bloc.add(GetAppointmentsEvent());
    }
  }

  bool isAscending = false;



  @override
  void initState() {
    super.initState();
    bloc.status = AppointmentStatus.pending;
    bloc.add(GetAppointmentsEvent());
    bloc.add(GetAllAppointmentsEvent());
  }

  List<Appointment> selectedList = [];
  final updateStatusBloc = KiwiContainer().resolve<ProviderUpdateStatusBloc>();
  int? status, providerId;
  final profileBloc = KiwiContainer().resolve<GetProviderProfileBloc>()
    ..add(GetProviderProfileEvent());

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: bloc,

      listener: (context, state) {
        if(state is GetAllAppointmentsSuccessState){
          setState(() {});
        }
      },
      child: Scaffold(
        appBar: MainAppBar(
          title: LocaleKeys.appointments.tr(),
          withBack: false,
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.only(end: 16.w),
              child: AppCircleIcon(
                img: 'notification.png',
                onTap: () => navigateTo(NotificationsView()),
                radius: 20.h,
                bgRadius: 36.h,
                iconColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            BlocConsumer(
              bloc: profileBloc,
              listener: (context, state) {
                if (state is GetProviderProfileSuccessState) {
                  if (state.model.providerTypes.isNotEmpty) {
                    status = state.model.providerTypes.first.status;
                    providerId = state.model.providerTypes.first.id;
                    setState(() {});
                  }
                }
              },
              builder: (context, state) {
                if (state is GetProviderProfileSuccessState &&
                    state.model.providerTypes.isNotEmpty &&
                    state.model.providerTypes.first.type.bookingType !=
                        'service') {
                  return Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 14.w,
                    ).copyWith(bottom: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.stopReceivingAllOrders.tr(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        BlocConsumer(
                          bloc: updateStatusBloc,
                          listener: (context, state) {
                            if (state is ProviderUpdateStatusSuccessState) {
                              status = state.status;
                              setState(() {});
                            }
                          },
                          builder: (context, state) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.r),
                                color: Theme.of(context).cardColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 4.r,
                                    offset: const Offset(0, 4),
                                    //blurStyle: BlurStyle.
                                  ),
                                ],
                              ),
                              child: state is ProviderUpdateStatusLoadingState
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 30.w,
                                        vertical: 4.h,
                                      ),
                                      child: SizedBox(
                                        height: 16.h,
                                        width: 16.h,
                                        child: CircularProgressIndicator(
                                          color: AppTheme.primary,
                                          strokeWidth: 2.w,
                                        ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        BuildToggleButton(
                                          text: LocaleKeys.off.tr(),
                                          isActive: status == 2,
                                          onTap: () {
                                            if (status != 2) {
                                              updateStatusBloc.add(
                                                ProviderUpdateStatusEvent(
                                                  typeId: providerId!,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        BuildToggleButton(
                                          text: LocaleKeys.on.tr(),
                                          isActive: status == 1,
                                          onTap: () {
                                            if (status != 1) {
                                              updateStatusBloc.add(
                                                ProviderUpdateStatusEvent(
                                                  typeId: providerId!,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 14.w,
              ).copyWith(bottom: 20.h),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ItemTap(
                    title:
                        "${LocaleKeys.pending.tr()} ${bloc.pendingLength}",
                    isSelected: bloc.status == AppointmentStatus.pending,
                    onTap: () {
                      if (bloc.status != AppointmentStatus.pending) {
                        bloc.status = AppointmentStatus.pending;
                        bloc.startDate = null;
                        bloc.endDate = null;
                        bloc.add(GetAppointmentsEvent());
                        bloc.add(GetAllAppointmentsEvent());
                        setState(() {});
                      }
                    },
                  ),
                  SizedBox(width: 16.w),
                  ItemTap(
                    title:
                        "${LocaleKeys.accepted.tr()} ${bloc.acceptLength}",
                    isSelected: bloc.status == AppointmentStatus.confirmed,
                    onTap: () {
                      if (bloc.status != AppointmentStatus.confirmed) {
                        bloc.status = AppointmentStatus.confirmed;
                        bloc.startDate = null;
                        bloc.endDate = null;
                        bloc.add(GetAppointmentsEvent());
                        bloc.add(GetAllAppointmentsEvent());

                        setState(() {});
                      }
                    },
                  ),
                  SizedBox(width: 16.w),
                  ItemTap(
                    title:
                        "${LocaleKeys.userArrive.tr()} ${bloc.userArriveLength}",
                    isSelected: bloc.status == AppointmentStatus.arrivedUser,
                    onTap: () {
                      if (bloc.status != AppointmentStatus.arrivedUser) {
                        bloc.status = AppointmentStatus.arrivedUser;
                        bloc.startDate = null;
                        bloc.endDate = null;
                        bloc.add(GetAppointmentsEvent());
                        bloc.add(GetAllAppointmentsEvent());

                        setState(() {});
                      }
                    },
                  ),
                  SizedBox(width: 16.w),

                  ItemTap(
                    title:
                        "${LocaleKeys.startWork.tr()} ${bloc.startWorkLength}",
                    isSelected: bloc.status == AppointmentStatus.startWork,
                    onTap: () {
                      if (bloc.status != AppointmentStatus.startWork) {
                        bloc.status = AppointmentStatus.startWork;
                        bloc.startDate = null;
                        bloc.endDate = null;
                        bloc.add(GetAppointmentsEvent());
                        bloc.add(GetAllAppointmentsEvent());
                        setState(() {});
                      }
                    },
                  ),
                  SizedBox(width: 16.w),
                  ItemTap(
                    title:
                        "${LocaleKeys.inWay.tr()} ${bloc.inWayLength}",
                    isSelected: bloc.status == AppointmentStatus.onTheWay,
                    onTap: () {
                      if (bloc.status != AppointmentStatus.onTheWay) {
                        bloc.status = AppointmentStatus.onTheWay;
                        bloc.startDate = null;
                        bloc.endDate = null;
                        bloc.add(GetAppointmentsEvent());
                        bloc.add(GetAllAppointmentsEvent());
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (selectedList.isNotEmpty) {
                        isAscending = !isAscending;
                        selectedList.sort((a, b) {
                          final dateA = DateTime.parse(a.date);
                          final dateB = DateTime.parse(b.date);
                          return isAscending
                              ? dateA.compareTo(dateB)
                              : dateB.compareTo(dateA);
                        });
                        setState(() {});
                      }
                    },
                    child: Text(
                      LocaleKeys.recently.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AppImage('arrow_down.png', height: 12.h, width: 12.h),
                  SizedBox(width: 16.w),
                  if (bloc.startDate != null && bloc.endDate != null) ...[
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(text: LocaleKeys.date.tr()),
                            TextSpan(
                              text: " : ${bloc.startDate} ",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    SizedBox.shrink(),
                    Spacer(),
                  ],

                  GestureDetector(
                    onTap: () async {
                      final result = await showDatePicker(
                        context: context,
                        locale: Locale("en"),
                        firstDate: DateTime(1800),
                        lastDate: DateTime.now(),
                      );
                      if (result != null) {
                        bloc.startDate = DateFormat(
                          "yyyy-MM-dd",
                          "en",
                        ).format(result);
                        bloc.endDate = DateFormat(
                          "yyyy-MM-dd",
                          "en",
                        ).format(result);
                        bloc.add(GetAppointmentsEvent());
                      }
                    },
                    child: AppCircleIcon(
                      img: 'calender.png',
                      bgRadius: 36.r,
                      radius: 22.r,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Expanded(
              child: BlocConsumer(
                bloc: bloc,
                buildWhen: (previous, current) =>
                    current is GetAppointmentsSuccessState ||
                    current is GetAppointmentsFailedState ||
                    current is GetAppointmentsLoadingState,
                listener: (context, state) {
                  if (state is GetAppointmentsSuccessState) {
                    selectedList = state.list;
                  }
                },
                builder: (context, state) {
                  if (state is GetAppointmentsFailedState) {
                    return AppFailed(
                      response: state.response,
                      onPress: () {
                        bloc.add(GetAppointmentsEvent());
                      },
                    );
                  } else if (state is GetAppointmentsSuccessState) {
                    if (state.list.isEmpty) {
                      return AppRefresh(
                        event: () {
                          bloc.add(GetAllAppointmentsEvent());
                          bloc.add(GetAppointmentsEvent());
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 3,
                            ),
                            child: AppEmpty(
                              title: LocaleKeys.appointments.tr(),
                            ),
                          ),
                        ),
                      );
                    }
                    return AppRefresh(
                      event: () async {
                        bloc.add(GetAppointmentsEvent());
                        bloc.add(GetAllAppointmentsEvent());
                      },
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              vertical: 16.h,
                              horizontal: 40.w,
                            ),
                            itemBuilder: (context, index) =>
                                _Item(model: selectedList[index]),
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 23.h),
                            itemCount: selectedList.length,
                          );
                        },
                      ),
                    );
                  }
                  return _Loading();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final Appointment model;

  const _Item({required this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateTo(AppointmentDetailsView(model: model)),
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [AppTheme.mainShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${model.id}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: Theme.of(context).hintColor,
                          fontFamily: getFontFamily(FontFamilyType.inter),
                        ),
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Center(
                            child: Text(
                              DateFormat.MMM().format(
                                DateTime.parse(model.date),
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: Theme.of(context).hintColor,
                                fontFamily: getFontFamily(FontFamilyType.inter),
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            DateFormat.d().format(DateTime.parse(model.date)),
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 48.sp,
                              height: .8.h,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            DateFormat.EEEE().format(
                              DateTime.parse(model.date),
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: Theme.of(context).hintColor,
                              fontFamily: getFontFamily(FontFamilyType.inter),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.timing.tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      color: Theme.of(context).hintColor,
                                      fontFamily: getFontFamily(
                                        FontFamilyType.inter,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    DateFormat.jm().format(
                                      DateTime.parse(model.date),
                                    ),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.For.tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      color: Theme.of(context).hintColor,
                                      fontFamily: getFontFamily(
                                        FontFamilyType.inter,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    model.user.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 10.h),
                        Text(
                          LocaleKeys.appointmentType.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: Theme.of(context).hintColor,
                            fontFamily: getFontFamily(FontFamilyType.inter),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              model.providerType.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text(
                                LocaleKeys.view.tr(),
                                style: TextStyle(
                                  fontSize: 12.r,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (model.appointmentStatus == 1)
              MinuteCountdownText(appointment: model),
          ],
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 40.w),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => Container(
          height: 125.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Colors.grey,
          ),
        ),
        separatorBuilder: (context, index) => SizedBox(height: 23.h),
        itemCount: 3,
      ),
    );
  }
}

class ItemTap extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const ItemTap({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isSelected ? 1 : 0.4,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            boxShadow: [AppTheme.mainShadow, AppTheme.whiteShadow],
            borderRadius: BorderRadius.circular(10.r),
            color: AppTheme.hoverColor,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }
}

class MinuteCountdownText extends StatefulWidget {
  final Appointment appointment;

  const MinuteCountdownText({super.key, required this.appointment});

  @override
  State<MinuteCountdownText> createState() => _MinuteCountdownTextState();
}

class _MinuteCountdownTextState extends State<MinuteCountdownText> {
  late int secondsLeft;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    secondsLeft = widget.appointment.remainingFromTwoMinutes.inSeconds;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft <= 0) {
        t.cancel();
      } else {
        setState(() {
          secondsLeft--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (secondsLeft <= 0) return const SizedBox();

    return Text(
      '${LocaleKeys.timeToAccept.tr()} 00:$secondsLeft',
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }
}
