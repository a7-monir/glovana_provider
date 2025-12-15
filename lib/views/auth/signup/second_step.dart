import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/core/design/app_button.dart';
import 'package:glovana_provider/core/design/app_circle_icon.dart';
import 'package:glovana_provider/core/design/app_failed.dart';
import 'package:glovana_provider/core/design/app_image.dart';
import 'package:glovana_provider/core/design/app_input.dart';
import 'package:glovana_provider/core/design/dialogs.dart';
import 'package:glovana_provider/core/logic/helper_methods.dart';
import 'package:glovana_provider/core/logic/input_validator.dart';
import 'package:glovana_provider/features/services/bloc.dart';
import 'package:kiwi/kiwi.dart';

import '../../../core/logic/cache_helper.dart';
import '../../../features/provider_profile/bloc.dart';
import '../../../generated/locale_keys.g.dart';
import 'first_step.dart';
import 'last_step.dart';

class SecondStepSignUpView extends StatefulWidget {
  final FirstStepModel firstStepModel;
  final bool isSalon;

  const SecondStepSignUpView({
    super.key,
    required this.firstStepModel,
    required this.isSalon,
  });

  @override
  State<SecondStepSignUpView> createState() => _SecondStepSignUpViewState();
}

final _workNumberController = TextEditingController();
bool isWorkValid = true;

class _SecondStepSignUpViewState extends State<SecondStepSignUpView> {
  @override
  void initState() {
    super.initState();
    _workNumberController.addListener(() {
      final isValid = _workNumberController.text.isNotEmpty;
      if (isWorkValid != isValid) {
        setState(() {
          isWorkValid = isValid;
        });
      }
    });
  }

  final _pricePerHourController = TextEditingController();

  final servicesBloc = KiwiContainer().resolve<GetServicesBloc>()
    ..add(GetServicesEvent());

  Map<String, dynamic> days = {
    "Always": {
      "enabled": false,
      "times": [
        {"from": "", "to": ""},
      ],
    },
    "Sunday": {
      "enabled": false,
      "times": [
        {"from": "", "to": ""},
      ],
    },
    "Monday": {
      "enabled": false,
      "times": [
        {"from": "", "to": ""},
      ],
    },
    "Tuesday": {
      "enabled": false,
      "times": [
        {"from": "", "to": ""},
      ],
    },
    "Wednesday": {
      "enabled": false,
      "times": [
        {"from": "", "to": ""},
      ],
    },
    "Thursday": {
      "enabled": false,
      "times": [
        {"from": "", "to": ""},
      ],
    },
    "Friday": {
      "enabled": false,
      "times": [
        {"from": "", "to": ""},
      ],
    },
    "Saturday": {
      "enabled": false,
      "times": [
        {"from": "", "to": ""},
      ],
    },
  };

  String? currentSelected;

  Widget _buildTimeRow(
    String day,
    Map<String, dynamic> dayData,
    Map<String, dynamic> timeSlot,
    int index,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Text(
            day,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: AppInput(
              marginBottom: 0,
              withShadow: false,
              isValid: false,
              filledColor: AppTheme.secondaryHeaderColor,
              validator: (value) {
                if (dayData["enabled"] && value!.isEmpty) {
                  return "Required";
                }
                return null;
              },
              hint: "From",
              controller: TextEditingController(text: timeSlot["from"]),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    timeSlot["from"] =
                        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                  });
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: AppImage('convert_arrow.png', height: 25.h, width: 50.w),
          ),
          Expanded(
            child: AppInput(
              marginBottom: 0,
              filledColor: AppTheme.secondaryHeaderColor,
              withShadow: false,
              validator: (value) {
                if (dayData["enabled"] && value!.isEmpty) {
                  return "Required";
                }
                return null;
              },
              hint: "To",
              controller: TextEditingController(text: timeSlot["to"]),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    timeSlot["to"] =
                        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toggleDaySelection(String day) {
    if (day == "Always") {
      // Toggle Always days when "Always" is selected
      bool newValue = !days["Always"]!["enabled"];
      days["Always"]!["enabled"] = newValue;

      // Set Always other days to the same value as "Always"
      days.forEach((key, value) {
        if (key != "Always") {
          days[key]!["enabled"] = newValue;
        }
      });
    } else {
      days[day]!["enabled"] = !days[day]!["enabled"];

      bool allEnabled = true;
      days.forEach((key, value) {
        if (key != "Always" && !days[key]!["enabled"]) {
          allEnabled = false;
        }
      });
      days["Always"]!["enabled"] = allEnabled;
    }

    currentSelected = day;
  }

  List<ServiceWithPrice> _selectedServicesWithPrices = [];
  List<Service2> _selectedServices = []; // For service booking type
  List<Service2> allServices = [];

  void _showMultiSelect(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("select_services".tr()),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allServices.length,
                  itemBuilder: (context, index) {
                    final service = allServices[index];
                    return CheckboxListTile(
                      title: Text(service.name),
                      checkColor: AppTheme.bgLightColor,
                      activeColor: AppTheme.primary,
                      value: _selectedServices.contains(service),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            _selectedServices.add(service);
                          } else {
                            _selectedServices.remove(service);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(LocaleKeys.cancel.tr()),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  child: Text(LocaleKeys.confirm.tr()),
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      setState(() {});
    });
  }

  void _showServicePriceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(LocaleKeys.selectServicesWithPrices.tr()),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    // Selected services section
                    if (_selectedServicesWithPrices.isNotEmpty) ...[
                      Text(LocaleKeys.selectedServices.tr()),
                      SizedBox(
                        height: 120.h,
                        child: ListView.builder(
                          itemCount: _selectedServicesWithPrices.length,
                          itemBuilder: (context, index) {
                            final serviceWithPrice =
                                _selectedServicesWithPrices[index];
                            return Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(serviceWithPrice.service.name),
                                  ),
                                  Text("${serviceWithPrice.price}"),
                                  IconButton(
                                    onPressed: () {
                                      setDialogState(() {
                                        _selectedServicesWithPrices.removeAt(
                                          index,
                                        );
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const Divider(),
                    ],

                    // Available services section
                    Text(LocaleKeys.availableServices.tr()),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: allServices.length,
                        itemBuilder: (context, index) {
                          final service = allServices[index];
                          final isSelected = _selectedServicesWithPrices.any(
                            (s) => s.service.id == service.id,
                          );

                          if (isSelected) {
                            return const SizedBox.shrink();
                          }

                          return Row(
                            children: [
                              Expanded(child: Text(service.name)),
                              AppButton(
                                text: LocaleKeys.addPrice.tr(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppTheme.primary,
                                ),
                                onPress: () => _showPriceInputDialog(
                                  context,
                                  service,
                                  setDialogState,
                                ),
                              ),
                            ],
                            // title: Text(service.name ),
                            // trailing: SizedBox(
                            //   width: 100,
                            //   child: ElevatedButton(
                            //     onPressed: () => _showPriceInputDialog(
                            //       context,
                            //       service,
                            //       setDialogState,
                            //     ),
                            //     child: Text("add_price".tr()),
                            //   ),
                            // ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text("cancel".tr()),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  child: Text("confirm".tr()),
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      setState(() {});
    });
  }

  void _showPriceInputDialog(
    BuildContext context,
    Service2 service,
    Function setDialogState,
  ) {
    final priceController = TextEditingController();
    final priceFormKey = GlobalKey<FormState>();
    showMyDialog(
      child: Column(
        children: [
          Text("${LocaleKeys.enterPriceFor.tr()} ${service.name}"),
          Form(
            key: priceFormKey,
            child: AppInput(
              withShadow: false,
              controller: priceController,
              hint: LocaleKeys.enterPrice.tr(),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.pleaseEnterPrice.tr();
                }
                if (double.tryParse(value) == null ||
                    double.parse(value) <= 0) {
                  return LocaleKeys.pleaseEnterValidPrice.tr();
                }
                return null;
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(LocaleKeys.cancel.tr()),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    if (priceFormKey.currentState!.validate()) {
                      final price = double.parse(priceController.text);
                      setDialogState(() {
                        _selectedServicesWithPrices.add(
                          ServiceWithPrice(
                            service: service,
                            price: price,
                            isActive: 1,
                          ),
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text(LocaleKeys.add.tr().tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: '${LocaleKeys.hi.tr()} ${CacheHelper.name}',
        centerTitle: false,
      ),

      body: Form(
        key: formKey,
        autovalidateMode: validateMode,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 65.sp,
                    height: 8.sp,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.33),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  Container(
                    width: 65.sp,
                    height: 8.sp,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  Container(
                    width: 65.sp,
                    height: 8.sp,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.33),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              AppInput(
                withShadow: true,
                fixedPositionedLabel: LocaleKeys.workNumber.tr(),
                controller: _workNumberController,
                validator: (v) => InputValidator.requiredValidator(
                  value: v!,
                  itemName: LocaleKeys.workNumber.tr(),
                ),
                keyboardType: TextInputType.number,
                marginBottom: 43.h,
              ),
              Divider(height: 2.h),
              SizedBox(height: 24.h),
              Text(
                LocaleKeys.workingHours.tr(),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
              ),

              SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: days.keys.map((day) {
                    return GestureDetector(
                      onTap: () {
                        _toggleDaySelection(day);
                        setState(() {});
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Opacity(
                          opacity: days[day]!["enabled"] ? 1 : 0.4,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.sp,
                              vertical: 3.sp,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryHeaderColor,
                              boxShadow: [
                                AppTheme.mainShadow,
                                AppTheme.whiteShadow,
                              ],
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Text(day),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 18.h),
              Column(
                children: [
                  if (days["Always"]?["enabled"] == true)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: days["Always"]!["times"].map<Widget>((
                        timeSlot,
                      ) {
                        final index = days["Always"]!["times"].indexOf(
                          timeSlot,
                        );
                        return _buildTimeRow(
                          "Always",
                          days["Always"]!,
                          timeSlot,
                          index,
                        );
                      }).toList(),
                    )
                  else
                    Column(
                      children: days.keys.map((day) {
                        final dayData = days[day]!;
                        if (!dayData["enabled"] || day == "Always") {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: dayData["times"].map<Widget>((timeSlot) {
                            final index = dayData["times"].indexOf(timeSlot);
                            return _buildTimeRow(day, dayData, timeSlot, index);
                          }).toList(),
                        );
                      }).toList(),
                    ),
                ],
              ),
              SizedBox(height: 30.h),
              Divider(height: 2),
              SizedBox(height: 20.h),

              Text(LocaleKeys.WhatYourService.tr()),
              SizedBox(height: 10.h),
              BlocConsumer(
                bloc: servicesBloc,
                listener: (context, state) {
                  if (state is GetServicesSuccessState) {
                    allServices = state.list;
                  }
                },
                builder: (context, state) {
                  if (state is GetServicesFailedState) {
                    return AppFailed(
                      response: state.response,
                      isSmallShape: true,
                      onPress: () => servicesBloc.add(GetServicesEvent()),
                    );
                  } else if (state is GetServicesSuccessState) {
                    return InkWell(
                      onTap: () => widget.firstStepModel.bookingType == "hourly"
                          ? _showMultiSelect(context)
                          : _showServicePriceDialog(context),
                      child: Row(
                        children: [
                          AppCircleIcon(img: 'plus.png', bgRadius: 18.r),
                          SizedBox(width: 8.w),
                          if (widget.firstStepModel.bookingType ==
                              "hourly") ...[
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _selectedServices
                                      .map(
                                        (serviceWithPrice) => Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 4.h,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 4.w,
                                            ),
                                            margin: EdgeInsetsDirectional.only(
                                              end: 8.w,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppTheme.hoverColor,
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                              boxShadow: [AppTheme.mainShadow],
                                            ),
                                            child: Row(
                                              children: [
                                                Text(serviceWithPrice.name),

                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                  onPressed: () {
                                                    setState(() {
                                                      _selectedServices
                                                          .remove(
                                                            serviceWithPrice,
                                                          );
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    size: 20.sp,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ] else ...[
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _selectedServicesWithPrices
                                      .map(
                                        (serviceWithPrice) => Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 4.h,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 4.w,
                                            ),
                                            margin: EdgeInsetsDirectional.only(
                                              end: 8.w,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppTheme.hoverColor,
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                              boxShadow: [AppTheme.mainShadow],
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  serviceWithPrice.service.name,
                                                ),
                                                SizedBox(width: 4.w),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 4.w,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15.r,
                                                        ),
                                                    color: AppTheme.canvasColor,
                                                  ),
                                                  child: Text(
                                                    "${serviceWithPrice.price} ${LocaleKeys.jod.tr()}",
                                                  ),
                                                ),
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                  onPressed: () {
                                                    setState(() {
                                                      _selectedServicesWithPrices
                                                          .remove(
                                                            serviceWithPrice,
                                                          );
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    size: 20.sp,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              SizedBox(height: 32.h),
              Text(
                widget.firstStepModel.bookingType != "hourly"
                    ? LocaleKeys.setTheMaximumNumberOfBookingsPerHour.tr()
                    : LocaleKeys.howMuchDoYouChargePerHour.tr(),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 16.h),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: AppInput(
                        withShadow: true,
                        marginBottom: 0,
                        controller: _pricePerHourController,
                        keyboardType: TextInputType.number,
                        validator: (v) => InputValidator.requiredValidator(
                          value: v!,
                          itemName: 'price',
                        ),
                      ),
                    ),
                    if (widget.firstStepModel.bookingType == "hourly") ...[
                      SizedBox(width: 8.w),
                      Text(
                        LocaleKeys.jodHour.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          fontFamily: getFontFamily(FontFamilyType.inter),
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: AppButton(
                  text: LocaleKeys.Continue.tr(),
                  onPress: () {
                    if (formKey.currentState!.validate()) {
                      final hasEnabledDays = days.entries
                          .where((entry) => entry.key != "All")
                          .any((entry) => entry.value["enabled"] == true);

                      if (!hasEnabledDays) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please select at least one day"),
                          ),
                        );
                        return;
                      }
                      List<Map<String, String>> availability = [];

                      final alwaysData = days["Always"];
                      final weekDays = [
                        "Sunday",
                        "Monday",
                        "Tuesday",
                        "Wednesday",
                        "Thursday",
                        "Friday",
                        "Saturday",
                      ];
                      if (alwaysData != null && alwaysData["enabled"] == true) {
                        for (var day in weekDays) {
                          for (var time in alwaysData["times"]) {
                            availability.add({
                              "day_of_week": day,
                              "start_time": time["from"] ?? "",
                              "end_time": time["to"] ?? "",
                            });
                          }
                        }
                      } else {
                        for (var entry in days.entries) {
                          final key = entry.key;
                          final value = entry.value;

                          if (key != "Always" && value["enabled"] == true) {
                            for (var time in value["times"]) {
                              availability.add({
                                "day_of_week": key,
                                "start_time": time["from"] ?? "",
                                "end_time": time["to"] ?? "",
                              });
                            }
                          }
                        }
                      }
                      final model = SecondStepModel(
                        firstStepModel: widget.firstStepModel,
                        workNumber:_workNumberController.text,
                        pricePerHour: double.parse(
                          _pricePerHourController.text,
                        ),
                        serviceWithPrice: _selectedServicesWithPrices
                            .map((service) => service.toMap())
                            .toList(),
                        service:widget.firstStepModel.bookingType ==
                            "hourly"? _selectedServices
                            .map((service) => service.id)
                            .toList():_selectedServicesWithPrices
                            .map((service) => service.service.id)
                            .toList(),
                        availability: availability,
                      );
                      navigateTo(
                        LastStepSingUpView(
                          secondStepModel: model,
                          isSalon: widget.isSalon,
                        ),
                      );
                    } else {
                      validateMode = AutovalidateMode.onUserInteraction;
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceWithPrice {
  final Service2 service;
  final double price;
  final int isActive;

  ServiceWithPrice({
    required this.service,
    required this.price,
    this.isActive = 1,
  });

  Map<String, dynamic> toMap() {
    return {'service_id': service.id, 'price': price, 'is_active': isActive};
  }
}

class SecondStepModel {
  final FirstStepModel firstStepModel;
  final double pricePerHour;
  final String workNumber;
  final List<Map<String, dynamic>> serviceWithPrice;
  final List<int> service;
  List<Map<String, String>> availability;

  SecondStepModel({
    required this.firstStepModel,
    required this.pricePerHour,
    required this.workNumber,
    required this.serviceWithPrice,
    required this.service,
    required this.availability,
  });
}
