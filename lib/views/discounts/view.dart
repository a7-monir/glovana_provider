import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_button.dart';
import 'package:glovana_provider/core/design/app_empty.dart';
import 'package:glovana_provider/core/design/app_failed.dart';
import 'package:glovana_provider/core/design/app_grid.dart';
import 'package:glovana_provider/core/design/app_input.dart';
import 'package:glovana_provider/core/design/app_loading.dart';
import 'package:glovana_provider/core/logic/helper_methods.dart';
import 'package:glovana_provider/core/logic/input_validator.dart';
import 'package:kiwi/kiwi.dart';

import '../../core/design/app_bar.dart';
import '../../core/design/main_gradient_item.dart';
import '../../features/add_discount/bloc.dart';
import '../../features/provider_profile/bloc.dart';
import '../../generated/locale_keys.g.dart';

class DiscountsView extends StatefulWidget {
  const DiscountsView({super.key});

  @override
  State<DiscountsView> createState() => _DiscountsViewState();
}

class _DiscountsViewState extends State<DiscountsView> {
  bool selectedValue = true; // put this in your state

  final List<int> selectedList = [];
  final getProviderProfileBloc =
      KiwiContainer().resolve<GetProviderProfileBloc>()
        ..add(GetProviderProfileEvent());
  final addDiscountBloc = KiwiContainer().resolve<AddDiscountBloc>();

  final discount = TextEditingController();
  String? startDate, endDate;
  int? providerId;

  Future<void> selectDateRange() async {
    final DateTime now = DateTime.now();
    final DateTime fiveYears = DateTime(now.year + 5);

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: fiveYears,
      locale: const Locale('en'),
      helpText: 'Select Date Range',
      saveText: 'Done',
      builder: (context, child) {
        return child!;
      },
    );

    if (picked != null) {
      startDate = DateFormat("yyyy-MM-dd", "en").format(picked.start);
      endDate = DateFormat("yyyy-MM-dd", "en").format(picked.end);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainGradientItem(),

        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: MainAppBar(title: LocaleKeys.discounts.tr()),
          body: BlocBuilder(
            bloc: getProviderProfileBloc,
            builder: (context, state) {
              if (state is GetProviderProfileFailedState) {
                return AppFailed(
                  onPress: () {
                    getProviderProfileBloc.add(GetProviderProfileEvent());
                  },
                );
              } else if (state is GetProviderProfileSuccessState) {
                providerId = state.model.id;
                if (state.model.providerTypes.isEmpty||(state.model.providerTypes.isNotEmpty&&state.model.providerTypes.first.providerServices.isEmpty)) {
                  return AppEmpty(title: LocaleKeys.providerType.tr());
                }
                return Form(
                  key: addDiscountBloc.formKey,
                  autovalidateMode: addDiscountBloc.validateMode,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          LocaleKeys.hereYouCanCreateGeneralDiscount.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11.sp),
                        ),
                        SizedBox(height: 10.h),
                        Divider(height: 2.h),
                        SizedBox(height: 20.h),
                        Text(
                          LocaleKeys.selectTheServiceYouLikeToApplyDiscountTo
                              .tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10.sp),
                        ),
                        SizedBox(height: 12.h),
                        AppInput(
                          fixedPositionedLabel: LocaleKeys.discountTitle.tr(),
                          controller: addDiscountBloc.name,
                          validator: (v) => InputValidator.requiredValidator(
                            value: v!,
                            itemName: LocaleKeys.discountTitle.tr(),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(color: AppTheme.primary),
                          ),
                        ),
                        AppInput(
                          fixedPositionedLabel: LocaleKeys.discountDescription
                              .tr(),
                          controller: addDiscountBloc.description,
                          validator: (v) => InputValidator.requiredValidator(
                            value: v!,
                            itemName: LocaleKeys.discountDescription.tr(),
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(color: AppTheme.primary),
                          ),
                        ),

                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                final allIds = state
                                    .model
                                    .providerTypes
                                    .first
                                    .providerServices
                                    .map((e) => e.service.id)
                                    .toList();

                                if (selectedList.length == allIds.length) {
                                  selectedList.clear();
                                } else {
                                  selectedList
                                    ..clear()
                                    ..addAll(allIds);
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Theme
                                    .of(context)
                                    .secondaryHeaderColor,
                                borderRadius: BorderRadius.circular(15.r),
                                boxShadow: [AppTheme.mainShadow],
                              ),
                              child: Text(
                                // selectedList.length ==
                                //     state
                                //         .model
                                //         .providerTypes
                                //         .first
                                //         .providerServices
                                //         .length
                                //     ? LocaleKeys.unselectAll.tr()
                                //     :
                                LocaleKeys.selectAll.tr(),
                                style: TextStyle(fontSize: 8.sp),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        AppGrid(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          spacing: 20.w,
                          runSpacing: 25.h,
                          itemCount: state
                              .model
                              .providerTypes
                              .first
                              .providerServices
                              .length,
                          crossCount: 2,
                          itemBuilder: (context, index) {
                            bool isSelected = selectedList.contains(
                              state
                                  .model
                                  .providerTypes
                                  .first
                                  .providerServices[index]
                                  .service
                                  .id,
                            );

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedList.remove(
                                      state
                                          .model
                                          .providerTypes
                                          .first
                                          .providerServices[index]
                                          .service
                                          .id,
                                    );
                                  } else {
                                    selectedList.add(
                                      state
                                          .model
                                          .providerTypes
                                          .first
                                          .providerServices[index]
                                          .service
                                          .id,
                                    );
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  boxShadow: [AppTheme.mainShadow],
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      state
                                          .model
                                          .providerTypes
                                          .first
                                          .providerServices[index]
                                          .service
                                          .name,
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                    Radio<bool>(
                                      value: true,
                                      groupValue: isSelected ? true : null,
                                      onChanged: (_) {
                                        setState(() {
                                          if (isSelected) {
                                            selectedList.remove(
                                              state
                                                  .model
                                                  .providerTypes
                                                  .first
                                                  .providerServices[index]
                                                  .service
                                                  .id,
                                            );
                                          } else {
                                            selectedList.add(
                                              state
                                                  .model
                                                  .providerTypes
                                                  .first
                                                  .providerServices[index]
                                                  .service
                                                  .id,
                                            );
                                          }
                                        });
                                      },
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 22.h),
                        Row(
                          children: [
                            Expanded(
                              child: AppInput(
                                fixedPositionedLabel: LocaleKeys.discount.tr(),
                                keyboardType: TextInputType.number,
                                controller: discount,
                                suffix: Icon(
                                  Icons.percent,
                                  size: 18.r,
                                  color: AppTheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: BorderSide(
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: AppInput(
                                fixedPositionedLabel: LocaleKeys.days.tr(),
                                suffix: Icon(
                                  Icons.calendar_month,
                                  size: 18.r,
                                  color: AppTheme.primary,
                                ),
                                onTap: selectDateRange,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: BorderSide(
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (startDate != null && endDate != null)
                          Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: Text(
                              '${LocaleKeys.from.tr()}: $startDate\n ${LocaleKeys.to.tr()}: $endDate',
                              style: TextStyle(fontSize: 11.sp),
                            ),
                          ),
                        SizedBox(height: 30.h),

                        BlocConsumer(
                          bloc: addDiscountBloc,
                          listener: (context, state) {
                            if (state is AddDiscountSuccessState) {
                              Navigator.pop(context);
                            }
                          },
                          builder: (context, state) {
                            return AppButton(
                              text: LocaleKeys.confirm.tr(),
                              isLoading: state is AddDiscountLoadingState,
                              onPress: () {
                                if (addDiscountBloc.formKey.currentState!
                                    .validate()) {
                                  if (selectedList.isEmpty) {
                                    showMessage(
                                      LocaleKeys.pleaseSelectService,
                                      type: MessageType.warning,
                                    );
                                  } else if (discount.text.isEmpty) {
                                    showMessage(
                                      LocaleKeys.pleaseSelectDiscountPercentage,
                                      type: MessageType.warning,
                                    );
                                  } else if (startDate == null ||
                                      endDate == null) {
                                    showMessage(
                                      LocaleKeys.pleaseSelectRangeOfDays,
                                      type: MessageType.warning,
                                    );
                                  } else {
                                    addDiscountBloc.add(
                                      AddDiscountEvent(
                                        providerId: providerId!,
                                        percentage: double.parse(discount.text),
                                        startDate: startDate!,
                                        endDate: endDate!,
                                        serviceIds: selectedList,
                                      ),
                                    );
                                  }
                                } else {
                                  addDiscountBloc.validateMode =
                                      AutovalidateMode.onUserInteraction;
                                  setState(() {});
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
              return AppLoading();
            },
          ),
        ),
      ],
    );
  }
}
