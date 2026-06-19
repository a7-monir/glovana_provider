import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:kiwi/kiwi.dart';

import '../../core/app_theme.dart';
import '../../core/design/app_empty.dart';
import '../../core/design/app_failed.dart';
import '../../core/design/app_shimmer.dart';
import '../../core/design/main_gradient_item.dart';
import '../../core/logic/helper_methods.dart';
import '../../features/appointments/bloc.dart';
import '../appointment_details/view.dart';
import '../home_nav/pages/appointments/view.dart';

class AppointmentHistory extends StatefulWidget {
  const AppointmentHistory({super.key});

  @override
  State<AppointmentHistory> createState() => _AppointmentHistoryState();
}

class _AppointmentHistoryState extends State<AppointmentHistory> {
  final bloc = KiwiContainer().resolve<GetAppointmentsBloc>();
  @override
  void initState() {
    super.initState();
    bloc.status = AppointmentStatus.completed;
    bloc.add(GetAppointmentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        MainGradientItem(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: MainAppBar(
            title: LocaleKeys.appointmentsHistory.tr(),

          ),
          body: Column(
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.w).copyWith(top: 30.h),
                child: Row(
                  children: [
                    Expanded(
                      child: ItemTap(
                        title: LocaleKeys.completed.tr(),
                        isSelected: bloc.status == AppointmentStatus.completed,
                        onTap: () {
                          if (bloc.status != AppointmentStatus.completed) {
                            bloc.status = AppointmentStatus.completed;
                            bloc.add(GetAppointmentsEvent());
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 30.w),
                    Expanded(
                      child: ItemTap(
                        title: LocaleKeys.canceled.tr(),
                        isSelected: bloc.status == AppointmentStatus.canceled,
                        onTap: () {
                          if (bloc.status != AppointmentStatus.canceled) {
                            bloc.status = AppointmentStatus.canceled;
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
        ),
      ],
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
              SizedBox(width: 15.w),
              VerticalDivider(width: 2.w),
              SizedBox(width: 15.w),
              Column(
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${model.totalPrices.toString()} ${LocaleKeys.jod.tr()}",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 24.sp,
                        ),
                      ),

                    ],
                  ),
                ],
              ),
              SizedBox(width: 10.w),
              if(model.reasonOfCancel.isNotEmpty)...[
                VerticalDivider(width: 2.w),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    children: [
                      Text(LocaleKeys.reason.tr(),
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400
                        ),),
                      SizedBox(height: 4.h),
                      Text(model.reasonOfCancel,
                        style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400
                        ),),
                    ],
                  ),
                )
              ]


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
