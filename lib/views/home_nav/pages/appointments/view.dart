import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  bool isAscending = false;
  List<Appointment> selectedList = [];

  bool get hasDateFilter => bloc.startDate != null && bloc.endDate != null;

  String get selectedDateLabel {
    if (!hasDateFilter) return '';
    if (bloc.startDate == bloc.endDate) {
      return bloc.startDate!;
    }
    return '${bloc.startDate} - ${bloc.endDate}';
  }

  void loadAppointments({bool withLoading = true}) {
    bloc.add(GetAppointmentsEvent(withLoading: withLoading));
    bloc.add(GetAllAppointmentsEvent(withLoading: withLoading));
  }

  void applyStatusFilter(AppointmentStatus? status) {
    if (bloc.status == status) return;
    setState(() {
      bloc.status = status;
    });
    loadAppointments();
  }

  void clearDateFilter() {
    if (!hasDateFilter) return;
    setState(() {
      bloc.startDate = null;
      bloc.endDate = null;
    });
    loadAppointments();
  }

  Future<void> selectDate() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      locale: context.locale,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDate: DateTime.tryParse(bloc.startDate ?? '') ?? now,
    );

    if (result == null) return;

    final formattedDate = DateFormat("yyyy-MM-dd", "en").format(result);
    setState(() {
      bloc.startDate = formattedDate;
      bloc.endDate = formattedDate;
    });
    loadAppointments();
  }

  void sortAppointments(List<Appointment> list) {
    list.sort((a, b) {
      final dateA =
          DateTime.tryParse(a.date) ?? DateTime.fromMillisecondsSinceEpoch(0);
      final dateB =
          DateTime.tryParse(b.date) ?? DateTime.fromMillisecondsSinceEpoch(0);
      return isAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });
  }

  @override
  void initState() {
    super.initState();
    bloc.status = null;
    loadAppointments();
  }

  final updateStatusBloc = KiwiContainer().resolve<ProviderUpdateStatusBloc>();
  int? status, providerId;
  final profileBloc = KiwiContainer().resolve<GetProviderProfileBloc>()
    ..add(GetProviderProfileEvent());

  bool isSalon = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: bloc,

      listener: (context, state) {
        if (state is GetAllAppointmentsSuccessState) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocConsumer(
              bloc: profileBloc,
              listener: (context, state) {
                if (state is GetProviderProfileSuccessState) {
                  if (state.model.providerTypes.isNotEmpty) {
                    status = state.model.providerTypes.first.status;
                    providerId = state.model.providerTypes.first.id;
                    isSalon =
                        (state.model.providerTypes.isNotEmpty &&
                        state.model.providerTypes.first.type.bookingType ==
                            'service');
                    setState(() {});
                  }
                }
              },
              builder: (context, state) {
                if (state is GetProviderProfileSuccessState) {
                  return Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 14.w,
                    ).copyWith(bottom: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (state.model.providerTypes.isNotEmpty &&
                                  state
                                          .model
                                          .providerTypes
                                          .first
                                          .type
                                          .bookingType ==
                                      'service')
                              ? LocaleKeys.stopReceivingAllOrders.tr()
                              : LocaleKeys.stopsInstantRequestsOnly.tr(),
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
                } else {
                  return SizedBox.shrink();
                }
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
                    title: "${LocaleKeys.all.tr()} ${bloc.allList.length}",
                    isSelected: bloc.status == null,
                    onTap: () => applyStatusFilter(null),
                  ),
                  SizedBox(width: 16.w),
                  if (!isSalon) ...[
                    ItemTap(
                      title: "${LocaleKeys.pending.tr()} ${bloc.pendingLength}",
                      isSelected: bloc.status == AppointmentStatus.pending,
                      onTap: () => applyStatusFilter(AppointmentStatus.pending),
                    ),
                    SizedBox(width: 16.w),
                  ],
                  ItemTap(
                    title: "${LocaleKeys.accepted.tr()} ${bloc.acceptLength}",
                    isSelected: bloc.status == AppointmentStatus.confirmed,
                    onTap: () => applyStatusFilter(AppointmentStatus.confirmed),
                  ),
                  SizedBox(width: 16.w),
                  ItemTap(
                    title: "${LocaleKeys.inWay.tr()} ${bloc.inWayLength}",
                    isSelected: bloc.status == AppointmentStatus.onTheWay,
                    onTap: () => applyStatusFilter(AppointmentStatus.onTheWay),
                  ),
                  SizedBox(width: 16.w),
                  ItemTap(
                    title:
                        "${LocaleKeys.userArrive.tr()} ${bloc.userArriveLength}",
                    isSelected: bloc.status == AppointmentStatus.arrivedUser,
                    onTap: () =>
                        applyStatusFilter(AppointmentStatus.arrivedUser),
                  ),
                  SizedBox(width: 16.w),

                  ItemTap(
                    title:
                        "${LocaleKeys.startWork.tr()} ${bloc.startWorkLength}",
                    isSelected: bloc.status == AppointmentStatus.startWork,
                    onTap: () => applyStatusFilter(AppointmentStatus.startWork),
                  ),
                  SizedBox(width: 16.w),
                  ItemTap(
                    title:
                        "${LocaleKeys.completed.tr()} ${bloc.completedLength}",
                    isSelected: bloc.status == AppointmentStatus.completed,
                    onTap: () => applyStatusFilter(AppointmentStatus.completed),
                  ),
                  SizedBox(width: 16.w),
                  ItemTap(
                    title: "${LocaleKeys.canceled.tr()} ${bloc.canceledLength}",
                    isSelected: bloc.status == AppointmentStatus.canceled,
                    onTap: () => applyStatusFilter(AppointmentStatus.canceled),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (selectedList.isNotEmpty) {
                            setState(() {
                              isAscending = !isAscending;
                              sortAppointments(selectedList);
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              LocaleKeys.recently.tr(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              isAscending
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              size: 18.r,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (hasDateFilter)
                        TextButton(
                          onPressed: clearDateFilter,
                          child: Text(LocaleKeys.clear.tr()),
                        ),
                      AppCircleIcon(
                        img: 'calender.png',
                        bgRadius: 36.r,
                        radius: 22.r,
                        onTap: selectDate,
                      ),
                    ],
                  ),
                  if (hasDateFilter) ...[
                    SizedBox(height: 12.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range_rounded,
                            size: 20.r,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              '${LocaleKeys.date.tr()}: $selectedDateLabel',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: clearDateFilter,
                            child: Icon(
                              Icons.close_rounded,
                              size: 20.r,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                    selectedList = [...state.list];
                    sortAppointments(selectedList);
                  }
                },
                builder: (context, state) {
                  if (state is GetAppointmentsFailedState) {
                    return AppFailed(
                      response: state.response,
                      onPress: () {
                        loadAppointments();
                      },
                    );
                  } else if (state is GetAppointmentsSuccessState) {
                    if (state.list.isEmpty) {
                      return AppRefresh(
                        event: () {
                          loadAppointments();
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
                        loadAppointments();
                      },
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              vertical: 16.h,
                              horizontal: 40.w,
                            ),
                            itemBuilder: (context, index) => _Item(
                              model: selectedList[index],
                              onSuccess: () {
                                loadAppointments(withLoading: false);
                              },
                            ),
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
  final VoidCallback onSuccess;

  const _Item({required this.model, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          navigateTo(AppointmentDetailsView(model: model)).then((value) {
            onSuccess();
          }),
      child: model.isInstant
          ? Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: LinearGradient(
                  colors: [
                    Color(0xffFFDAD4),
                    Color(0xffFFFFFF),
                    Color(0xffFFDAD4),
                  ],
                ),
              ),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
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
                        SizedBox(width: 8.w),
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
                        VerticalDivider(width: 4.w),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.appointmentType.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  color: Theme.of(context).hintColor,
                                  fontFamily: getFontFamily(
                                    FontFamilyType.inter,
                                  ),
                                ),
                              ),
                              Text(
                                model.providerType.name,
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
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 55.w),
                    child: Divider(height: 20.h, thickness: 2),
                  ),
                  Text(
                    LocaleKeys.instant.tr().toUpperCase(),
                    style: TextStyle(fontSize: 36.sp),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
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
            )
          : Container(
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
                                      fontFamily: getFontFamily(
                                        FontFamilyType.inter,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  DateFormat.d().format(
                                    DateTime.parse(model.date),
                                  ),
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
                                    fontFamily: getFontFamily(
                                      FontFamilyType.inter,
                                    ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  fontFamily: getFontFamily(
                                    FontFamilyType.inter,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        color: Theme.of(
                                          context,
                                        ).secondaryHeaderColor,
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          boxShadow: [AppTheme.mainShadow, AppTheme.whiteShadow],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Theme.of(context).dividerColor.withValues(alpha: 0.2),
          ),
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).canvasColor,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? Theme.of(context).secondaryHeaderColor : null,
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
    final minutes = secondsLeft ~/ 60;
    final seconds = secondsLeft % 60;
    final formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return Text(
      '${LocaleKeys.timeToAccept.tr()} 00:$formattedTime',
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }
}
