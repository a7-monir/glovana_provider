import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/core/design/app_empty.dart';
import 'package:glovana_provider/core/design/app_failed.dart';
import 'package:glovana_provider/core/design/app_image.dart';
import 'package:glovana_provider/core/design/app_loading.dart';
import 'package:glovana_provider/core/logic/helper_methods.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:kiwi/kiwi.dart';

import '../../features/payment_report/bloc.dart';

class PaymentReportView extends StatefulWidget {
  const PaymentReportView({super.key});

  @override
  State<PaymentReportView> createState() => _PaymentReportViewState();
}

class _PaymentReportViewState extends State<PaymentReportView> {
  final bloc = KiwiContainer().resolve<GetPaymentReportBloc>()
    ..add(GetPaymentReportEvent());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: LocaleKeys.paymentReport.tr()),
      body: BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          if (state is GetPaymentReportFailedState) {
            return AppFailed(
              response: state.response,
              onPress: () {
                bloc.add(GetPaymentReportEvent());
              },
            );
          } else if (state is GetPaymentReportSuccessState) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 18.w).copyWith(bottom: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ItemGrid(
                            title: LocaleKeys.totalAppointments.tr(),
                            value: state.model.totalAppointments.toString(),
                            icon: 'calender.png',
                            color: Color(0xffD3DCFF),
                            iconColor: Color(0xff354790),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: ItemGrid(
                            title: LocaleKeys.totalAmount.tr(),
                            value:
                                "${state.model.totalAmount.toStringAsFixed(2)} ${LocaleKeys.jod.tr()}",
                            icon: 'dollar2.png',
                            color: Color(0xffC5FDC5),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: ItemGrid(
                            title: LocaleKeys.totalCommission.tr(),
                            value:
                                "${state.model.totalCommission.toStringAsFixed(2)} ${LocaleKeys.jod.tr()}",
                            icon: '%.png',
                            color: Color(0xffFAEFAE),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: ItemGrid(
                            title: LocaleKeys.yourEarnings.tr(),
                            value:
                                "${state.model.totalProviderEarnings.toStringAsFixed(2)} ${LocaleKeys.jod.tr()}",
                            icon: 'wallet_in.png',
                            color: Color(0xffF1C5F2),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 36.h),
                    Text(
                      LocaleKeys.appointmentList.tr(),
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox( height: 16.h),
                    if(state.model.appointments.isNotEmpty)
                    ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ItemList(model: state.model.appointments[index],),
                      separatorBuilder: (context, index) => SizedBox(height: 16.h,),
                      itemCount: state.model.appointments.length,
                    ),
                    if(state.model.appointments.isEmpty)
                      AppEmpty(title: LocaleKeys.appointmentList.tr(),)
                  ],
                ),
              ),
            );
          }
          return AppLoading();
        },
      ),
    );
  }
}

class ItemGrid extends StatelessWidget {
  final String title, value, icon;
  final Color color;
  final Color? iconColor;

  const ItemGrid({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      constraints: BoxConstraints(minHeight: 140.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          AppImage(icon, height: 22.h, width: 22.h, color: iconColor),
          SizedBox(height: 18.h),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}
class ItemList extends StatelessWidget {
  final PaymentAppointment model;
  const ItemList({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppTheme.canvasColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          AppTheme.mainShadow
        ]

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('#${model.id}',style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20.sp,
                color: AppTheme.hintTextColor,
                fontFamily: getFontFamily(FontFamilyType.inter),
              ),),
              Text(DateFormat("d / MMMM / y h:mm a", "ar").format(DateTime.parse(model.date)),style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 8.sp,
                color: AppTheme.hintTextColor,

              ),),
            ],
          ),
          SizedBox(height:4.h),
          Row(
            children: [
              Expanded(
                child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${LocaleKeys.totalCommission.tr()} ${model.commission} ${LocaleKeys.jod.tr()}',style: TextStyle(fontSize: 11.sp,
                    fontWeight: FontWeight.w400
                    ),),
                    SizedBox(height: 2.h),
                    Text('${LocaleKeys.yourEarnings.tr()} ${model.providerEarnings} ${LocaleKeys.jod.tr()}',style: TextStyle(fontSize: 11.sp,
                    fontWeight: FontWeight.w400
                    ),),
                  ],
                ),
              ),
              Text('${model.total} ${LocaleKeys.jod.tr()}',style: TextStyle(fontSize: 20.sp,
                  fontWeight: FontWeight.w400
              ),),
            ],
          )
        ],
      ),
    );
  }
}

