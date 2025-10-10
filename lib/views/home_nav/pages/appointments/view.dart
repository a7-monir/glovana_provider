import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_image.dart';
import 'package:glovana_provider/features/appointments/bloc.dart';
import 'package:kiwi/kiwi.dart';
import '../../../../core/app_theme.dart';
import '../../../../core/design/app_bar.dart';
import '../../../../core/design/app_circle_icon.dart';
import '../../../../core/design/app_empty.dart';
import '../../../../core/design/app_failed.dart';
import '../../../../core/design/app_shimmer.dart';
import '../../../../core/logic/helper_methods.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../appointment_details/view.dart';

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

  @override
  void initState() {
    super.initState();
    bloc.status = AppointmentStatus.pending;
    bloc.add(GetAppointmentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: LocaleKeys.appointments.tr(),
        withBack: false,
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 16.w),
            child: AppCircleIcon(
              img: 'notification.png',
              radius: 20.h,
              bgRadius: 36.h,
              iconColor: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                Expanded(
                  child: ItemTap(
                    title: LocaleKeys.pending.tr(),
                    isSelected: bloc.status == AppointmentStatus.pending,
                    onTap: () {
                      if (bloc.status != AppointmentStatus.pending) {
                        bloc.status = AppointmentStatus.pending;
                        bloc.add(GetAppointmentsEvent());
                        setState(() {});
                      }
                    },
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ItemTap(
                    title: LocaleKeys.inWay.tr(),
                    isSelected: bloc.status == AppointmentStatus.onTheWay,
                    onTap: () {
                      if (bloc.status != AppointmentStatus.onTheWay) {
                        bloc.status = AppointmentStatus.onTheWay;
                        bloc.add(GetAppointmentsEvent());
                        setState(() {});
                      }
                    },
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ItemTap(
                    title: LocaleKeys.accepted.tr(),
                    isSelected: bloc.status == AppointmentStatus.confirmed,
                    onTap: () {
                      if (bloc.status != AppointmentStatus.confirmed) {
                        bloc.status = AppointmentStatus.confirmed;
                        bloc.add(GetAppointmentsEvent());
                        setState(() {});
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 14.w),
            child: GestureDetector(
              onTap: selectDateRange,
              child: Row(
                children: [
                  if (bloc.startDate != null && bloc.endDate != null) ...[
                    Text.rich(TextSpan(
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(text: LocaleKeys.from.tr()),
                          TextSpan(
                            text: ": ${bloc.startDate}",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: LocaleKeys.to.tr()),
                          TextSpan(
                            text: ': ${bloc.endDate}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ]))
                  ] else ...[
                    Text(
                      LocaleKeys.recently.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppImage('arrow_down.png',height: 12.h,width: 12.h,)
                  ],
                  Spacer(),
                  AppCircleIcon(img: 'calender.png',bgRadius: 36.r,radius: 22.r,)
                ],
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: BlocBuilder(
              bloc: bloc,
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
                    return AppEmpty(title: LocaleKeys.appointments.tr());
                  }
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 40.w,
                    ),
                    itemBuilder: (context, index) =>
                        _Item(model: state.list[index]),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 23.h),
                    itemCount: state.list.length,
                  );
                }
                return _Loading();
              },
            ),
          ),
        ],
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
        child: IntrinsicHeight(
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
                          DateFormat.MMM().format(DateTime.parse(model.date)),
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
                        DateFormat.EEEE().format(DateTime.parse(model.date)),
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
