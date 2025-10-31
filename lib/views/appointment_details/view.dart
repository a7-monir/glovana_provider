import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_button.dart';
import 'package:glovana_provider/core/design/app_failed.dart';
import 'package:glovana_provider/core/design/app_loading.dart';
import 'package:glovana_provider/core/logic/cache_helper.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kiwi/kiwi.dart';

import '../../core/app_theme.dart';
import '../../core/design/app_bar.dart';
import '../../core/design/app_image.dart';
import '../../core/design/main_gradient_item.dart';
import '../../core/logic/helper_methods.dart';
import '../../features/appointment_details/bloc.dart';
import '../../features/appointments/bloc.dart';
import '../../features/update_status/bloc.dart';
import '../../generated/locale_keys.g.dart';
import '../location/view.dart';

class AppointmentDetailsView extends StatefulWidget {
   Appointment model;

   AppointmentDetailsView({super.key, required this.model});

  @override
  State<AppointmentDetailsView> createState() => _AppointmentDetailsViewState();
}

class _AppointmentDetailsViewState extends State<AppointmentDetailsView> {
  final bloc = KiwiContainer().resolve<GetAppointmentDetailsBloc>();
  final updateStatusBloc = KiwiContainer().resolve<UpdateStatusBloc>();

  Map<int, List<AppointmentService>> _groupServicesByPerson(
    List<AppointmentService> appointmentServicesList,
  ) {
    Map<int, List<AppointmentService>> groupedServices = {};

    for (var service in appointmentServicesList) {
      int personNumber = service.personNumber;
      if (!groupedServices.containsKey(personNumber)) {
        groupedServices[personNumber] = [];
      }
      groupedServices[personNumber]!.add(service);
    }

    return groupedServices;
  }

  // Helper method to calculate total for a person
  double _calculatePersonTotal(List<AppointmentService> services) {
    double total = 0;
    for (var service in services) {
      total += double.tryParse(service.totalPrice ?? "0") ?? 0;
    }
    return total;
  }

  // Helper method to get unique customer count from services
  int _getUniqueCustomerCount(
    List<AppointmentService> appointmentServicesList,
  ) {
    Set<int> uniquePersons = {};
    for (var service in appointmentServicesList) {
      uniquePersons.add(service.personNumber);
    }

    return uniquePersons.length;
  }

  Widget _buildPersonServicesBreakdown(
    List<AppointmentService> appointmentServicesList,
  ) {
    final groupedServices = _groupServicesByPerson(appointmentServicesList);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: groupedServices.entries.map((entry) {
          final personNumber = entry.key;
          final services = entry.value;
          final personTotal = _calculatePersonTotal(services);

          return Container(
            padding: EdgeInsets.all(11.r),
            margin: EdgeInsetsDirectional.only(end: 16.w),
            decoration: BoxDecoration(
              color: AppTheme.hoverColor,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [AppTheme.mainShadow, AppTheme.whiteShadow],
            ),
            child: Column(
              children: [
                // Person header
                Text(
                  "${LocaleKeys.person.tr()} $personNumber",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Divider(height: 2.h),
                SizedBox(height: 16.h),
                // Services for this person
                ...services.asMap().entries.map((serviceEntry) {
                  final serviceIndex = serviceEntry.key;
                  final service = serviceEntry.value;
                  final isLastService = serviceIndex == services.length - 1;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 3.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppTheme.primary,
                          size: 11.sp,
                        ),
                        Text(
                          CacheHelper.lang == "ar"
                              ? (service.service.nameAr)
                              : (service.service.nameEn),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: 16.h),
                Divider(height: 2.h, color: AppTheme.primary),
                SizedBox(height: 16.h),
                Text(
                  "${personTotal.toStringAsFixed(2)} ${LocaleKeys.jod.tr()}",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    bloc.add(GetAppointmentDetailsEvent(id: widget.model.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      // buildWhen: (previous, current) =>
      //     current is GetAppointmentDetailsSuccessState ||
      //     current is GetAppointmentDetailsFailedState ||
      //     current is GetAppointmentDetailsLoadingState,
      bloc: bloc,
      listener: (context, state) {
        if (state is GetAppointmentDetailsSuccessState){
          print('++++++++++++++++++++++++++++++++');
          print( widget.model.appointmentStatus.toString());
          print(state.model.appointmentStatus.toString());
          print( widget.model.appointmentStatus.toString());

          widget.model=state.model;
          print('++++++++++++++++++++++++++++++++');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: MainAppBar(title: LocaleKeys.appointmentDetails.tr()),
          body: Builder(
            builder: (context) {
              if (state is GetAppointmentDetailsFailedState) {
                return AppFailed(
                  response: state.response,
                  onPress: () {
                    bloc.add(GetAppointmentDetailsEvent(id: widget.model.id));
                  },
                );
              } else if (state is GetAppointmentDetailsSuccessState) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: Text(
                          LocaleKeys.bookedAt.tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: Text(
                          DateFormat("d / MMMM / y h:mm a").format(DateTime.parse(state.model.createdAt)),
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 18.w),
                        child: Divider(height: 2.h,),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,vertical: 16.h
                        ),
                        child: Text(
                          '${LocaleKeys.appointmentNo.tr()} #${state.model.id}',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                        ).copyWith(bottom: 16.h),
                        child: Text(
                          LocaleKeys.serviceDetails.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      _InfoItem(
                        img: 'calender.png',
                        title: DateFormat(
                          'EEEE, MMMM d, y',
                        ).format(DateTime.parse(state.model.date)),
                      ),
                      _InfoItem(
                        img: 'clock.png',
                        title: DateFormat.jm().format(
                          DateTime.parse(state.model.date),
                        ),
                      ),
                      _InfoItem(img: 'user.png', title: state.model.user.name),
                      _InfoItem(
                        img: 'shop.png',
                        title: state.model.isHourly
                            ? LocaleKeys.hourly.tr()
                            : LocaleKeys.salon.tr(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                        ).copyWith(bottom: 16.h),
                        child: Text(
                          LocaleKeys.location.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      _InfoItem(
                        img: 'marker_fill.png',
                        title: state.model.address.address,
                      ),
                      if (state.model.isHourly)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 28.w,
                          ).copyWith(bottom: 16.h),
                          child: GestureDetector(
                            onTap: () => navigateTo(
                              LocationView(
                                initialLocation: LatLng(
                                  double.parse(state.model.address.lat),
                                  double.parse(state.model.address.lng),
                                ),
                              ),
                            ),
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  child: AppImage(
                                    'map.png',
                                    height: 166.h,
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(16.r),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadiusDirectional.only(
                                      bottomStart: Radius.circular(15.r),
                                      bottomEnd: Radius.circular(15.r),
                                    ),
                                    color: Theme.of(
                                      context,
                                    ).scaffoldBackgroundColor,
                                    boxShadow: [AppTheme.mainShadow],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        LocaleKeys.viewLocation.tr(),
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      if (!state.model.isHourly) ...[
                        _InfoItem(
                          img: 'customers.png',
                          title:
                              "${_getUniqueCustomerCount(state.model.appointmentServices)} ${LocaleKeys.customers.tr()}",
                        ),

                        _buildPersonServicesBreakdown(
                          state.model.appointmentServices,
                        ),
                        SizedBox(height: 16.h),
                      ],
                      if (state.model.note.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                          ).copyWith(bottom: 12.h),
                          child: Text(
                            LocaleKeys.clientNotes.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.all(8.r),
                          margin:  EdgeInsets.symmetric(horizontal: 18.w),
                          decoration: BoxDecoration(
                            boxShadow: [AppTheme.mainShadow],
                            color: AppTheme.hoverColor,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: AppTheme.primary),
                          ),
                          child: Text(state.model.note),
                        ),
                        SizedBox(height: 16.h),
                      ],

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                        ).copyWith(bottom: 12.h),
                        child: Text(
                          LocaleKeys.paymentDetails.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      if (state.model.totalPrices > 0)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                          ).copyWith(bottom: 16.h),
                          child: ItemSummary(
                            title: LocaleKeys.subTotal.tr(),
                            value: state.model.totalPrices.toString(),
                            withJod: false,
                          ),
                        ),
                      if (state.model.deliveryFee > 0)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                          ).copyWith(bottom: 16.h),
                          child: ItemSummary(
                            title: LocaleKeys.deliveryFee.tr(),
                            value: state.model.deliveryFee.toString(),
                            withJod: false,
                          ),
                        ),

                      if (state.model.totalDiscounts > 0)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                          ).copyWith(bottom: 16.h),
                          child: ItemSummary(
                            title: LocaleKeys.discount.tr(),
                            value: state.model.totalDiscounts.toString(),
                            withJod: false,
                          ),
                        ),
                      if (state.model.couponDiscount > 0)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                          ).copyWith(bottom: 16.h),
                          child: ItemSummary(
                            title: LocaleKeys.coupon.tr(),
                            value: state.model.couponDiscount.toString(),
                            withJod: false,
                          ),
                        ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: ItemSummary(
                          title: LocaleKeys.total.tr(),
                          value:
                              "${((state.model.totalPrices) - (state.model.totalDiscounts) - (state.model.couponDiscount) + (state.model.deliveryFee)).toStringAsFixed(2)} ${LocaleKeys.jod.tr()}",

                          isTotal: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                        ).copyWith(top: 20.h),
                        child: ItemSummary(
                          title: LocaleKeys.paymentMethod.tr(),
                          value: state.model.paymentType,

                          withJod: false,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return AppLoading();
            },
          ),
          bottomNavigationBar:
              //widget.model.appointmentStatus == 3 ||
                  widget.model.appointmentStatus == 7 ||
                  state is! GetAppointmentDetailsSuccessState
              ? SizedBox.shrink()
              :
          _buildStatusButtons(context),
        );
      },
    );
  }

  Widget _buildStatusButtons(BuildContext context) {
    final currentStatus = widget.model.appointmentStatus;
    List<StatusAction> actions = [];

    if (currentStatus == 1) {
      // Pending
      actions = [
        StatusAction(text: LocaleKeys.accept.tr(), status: 2),
        StatusAction(text: LocaleKeys.reject.tr(), status: 5),
      ];
    } else if (currentStatus == 2) {
      // Accepted
      actions = [
        StatusAction(text: LocaleKeys.onTheWay.tr(), status: 3),
        StatusAction(text: LocaleKeys.cancel.tr(), status: 5, ),
      ];
    }
    else if (currentStatus == 3) {
      // Accepted
      actions = [
        StatusAction(text: LocaleKeys.completed.tr(), status: 4),

      ];
    }
    else if (currentStatus == 6) {
      // Work Started - Provider can only cancel, completion is handled by user
      actions = [StatusAction(text: LocaleKeys.cancel.tr(), status: 5)];
    } else {
      // No actions for completed or cancelled appointments
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.all(16.sp),
      child: Row(
        children: [
          for (var action in actions) ...[
            if (action != actions.first) SizedBox(width: 16.w),
            Expanded(
              child: AppButton(
                text: action.text,
                isSecondary: action.status != 5,
                onPress: () => _updateStatus(
                  context,
                  action.status,
                  onDone: () {
                    bloc.add(GetAppointmentDetailsEvent(id: widget.model.id));
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _updateStatus(
    BuildContext context,
    int status, {
    required Function()? onDone,
  }) async {
    // Get the appropriate title and content based on status
    String dialogTitle;
    String dialogContent;

    switch (status) {
      case 2: // Accept
        dialogTitle = LocaleKeys.confirmAcceptTitle
            .tr(); //  "confirm_accept_title".tr();
        dialogContent = LocaleKeys.confirmAcceptMessage
            .tr(); //"confirm_accept_message".tr();
        break;
      case 3: // On the way
        dialogTitle = LocaleKeys.confirmOnWayTitle
            .tr(); //"confirm_on_way_title".tr();
        dialogContent =
            LocaleKeys.confirmOnWayMessage; //"confirm_on_way_message".tr();
        break;
      case 4: // Mark completed
        dialogTitle = LocaleKeys.confirmCompleteTitle
            .tr(); //confirm_complete_title".tr();
        dialogContent = LocaleKeys.confirmCompleteMessage
            .tr(); //"confirm_complete_message".tr();
        break;
      case 5: // Cancel/Reject
        dialogTitle = LocaleKeys.confirmCancelTitle
            .tr(); // "confirm_cancel_title".tr();
        dialogContent = LocaleKeys.confirmCancelMessage
            .tr(); // "confirm_cancel_message".tr();
        break;
      default:
        dialogTitle = LocaleKeys.confirmStatusChange.tr();
        dialogContent = LocaleKeys.areYouSureYouWantToChange.tr();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(dialogTitle),
        titleTextStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppTheme.primary,
          fontFamily: getFontFamily(FontFamilyType.aboreto),
        ),
        content: Text(dialogContent),
        contentTextStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: AppTheme.primary,
          fontFamily: getFontFamily(FontFamilyType.aboreto),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  isSecondary: false,
                  onPress: () => Navigator.pop(context),
                  text: LocaleKeys.cancel.tr(),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: BlocConsumer(
                  bloc: updateStatusBloc,
                  listener: (context, updateState) {
                    if (updateState is UpdateStatusSuccessState) {
                      onDone!();
                      Navigator.pop(context);
                    } else if (updateState is UpdateStatusFailedState) {
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, updateState) {
                    return AppButton(
                      isLoading: updateState is UpdateStatusLoadingState,
                      onPress: () {
                        updateStatusBloc.add(
                          UpdateStatusEvent(
                            id: widget.model.id,
                            newStatus: status,
                          ),
                        );
                      },
                      text: LocaleKeys.confirm.tr(),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String img, title;

  const _InfoItem({required this.img, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w).copyWith(bottom: 16.h),
      child: Row(
        children: [
          AppImage(img, height: 16.h, width: 16.h),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemPayment extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Widget? child;
  final bool isSelected;

  const ItemPayment({
    super.key,
    this.text = '',
    required this.onTap,
    this.child,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: text.isNotEmpty ? 8.h : 0,
        horizontal: 4.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
        ),
        color: AppTheme.containerColor,
        boxShadow: [AppTheme.mainShadow],
      ),
      child: text.isNotEmpty
          ? Center(
              child: Text(
                text.toUpperCase(),
                style: TextStyle(
                  fontFamily: getFontFamily(FontFamilyType.inter),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            )
          : child,
    );
  }
}

class ItemSummary extends StatelessWidget {
  final String title, value;
  final double? valueFontSize;
  final bool isTotal, withJod;

  const ItemSummary({
    super.key,
    required this.title,
    required this.value,
    this.isTotal = false,
    this.withJod = true,
    this.valueFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: isTotal ? 16.sp : 14.sp,
          ),
        ),
        Text(
          "$value ${withJod ? LocaleKeys.jod.tr() : ''}",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: valueFontSize ?? 12.sp,
          ),
        ),
      ],
    );
  }
}

class StatusAction {
  final String text;
  final int status;

  StatusAction({required this.text, required this.status});
}
