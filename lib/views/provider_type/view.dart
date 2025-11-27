import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/core/design/app_failed.dart';
import 'package:glovana_provider/core/design/app_loading.dart';
import 'package:glovana_provider/core/logic/cache_helper.dart';
import 'package:glovana_provider/core/logic/helper_methods.dart';
import 'package:glovana_provider/features/provider_profile/bloc.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:glovana_provider/views/auth/signup/first_step.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiwi/kiwi.dart';

import '../../core/design/app_button.dart';
import '../../core/design/app_circle_icon.dart';
import '../../core/design/app_image.dart';
import '../../core/design/app_input.dart';
import '../../core/design/base_sheet.dart';
import '../../core/design/dialogs.dart';
import '../../core/logic/input_validator.dart';
import '../../features/complete_data_update/bloc.dart';
import '../../features/services/bloc.dart';
import '../auth/signup/last_step.dart';
import '../auth/signup/second_step.dart';
import '../location/view.dart';

class ProviderTypeView extends StatefulWidget {
  const ProviderTypeView({super.key});

  @override
  State<ProviderTypeView> createState() => _ProviderTypeViewState();
}

class _ProviderTypeViewState extends State<ProviderTypeView> {
  final bloc = KiwiContainer().resolve<GetProviderProfileBloc>()
    ..add(GetProviderProfileEvent());

  final updateBloc = KiwiContainer().resolve<CompleteDataUpdateBloc>();
  final servicesBloc = KiwiContainer().resolve<GetServicesBloc>();
  final nickNameController = TextEditingController();
  bool isNickNameValid = true;
  bool isDescriptionValid = true;
  final descriptionController = TextEditingController();
  final _workNumberController = TextEditingController();
  bool isWorkValid = true;
  double? latitude;
  double? longitude;
  String? addressFromPicker;
  int selectedIndex = 0;
  final _pricePerHourController = TextEditingController();

  File? _images;
  List<File> _gallery = [];
  bool canEdit = false;

  String? _imageFromApi;
  List<String> _galleryFromApi = [];

  File? _identityPhoto;
  String? _identityPhotoApi;
  File? _practicePhoto;
  String? _practicePhotoApi;

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
  String bookingType = '';
  int typeId = 0;
  int providerId = 0;

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

  void _toggleDaySelection(String day) {
    if (day == "Always") {
      bool newValue = !days["Always"]!["enabled"];
      days["Always"]!["enabled"] = newValue;

      // ✅ لما يتفعّل Always نحط له slot افتراضي لو فاضي
      if (newValue && (days["Always"]!["times"] as List).isEmpty) {
        days["Always"]!["times"] = [
          {"from": "", "to": ""},
        ];
      }

      // ✅ وتنعكس على باقي الأيام
      days.forEach((key, value) {
        if (key != "Always") {
          days[key]!["enabled"] = newValue;

          // لو مفعّل ومفيش مواعيد، نحط واحد فاضي
          if (newValue && (days[key]!["times"] as List).isEmpty) {
            days[key]!["times"] = [
              {"from": "", "to": ""},
            ];
          }
        }
      });
    } else {
      days[day]!["enabled"] = !days[day]!["enabled"];

      // ✅ لو يوم اتفعل ومفيش مواعيد، نحط slot
      if (days[day]!["enabled"] && (days[day]!["times"] as List).isEmpty) {
        days[day]!["times"] = [
          {"from": "", "to": ""},
        ];
      }

      bool allEnabled = true;
      days.forEach((key, value) {
        if (key != "Always" && !days[key]!["enabled"]) {
          allEnabled = false;
        }
      });
      days["Always"]!["enabled"] = allEnabled;
    }

    currentSelected = day;
    setState(() {});
  }

  void loadAvailabilities(List<Availabilities> apiList) {
    days.forEach((key, value) {
      days[key]!["enabled"] = false;
      days[key]!["times"] = [];
    });

    for (var item in apiList) {
      if (days.containsKey(item.dayOfWeek)) {
        days[item.dayOfWeek]!["enabled"] = true;
        days[item.dayOfWeek]!["times"].add({
          "from": item.startTime,
          "to": item.endTime,
        });
      }
    }

    bool allEnabled = true;
    days.forEach((key, value) {
      if (key != "Always" && !value["enabled"]) {
        allEnabled = false;
      }
    });
    days["Always"]!["enabled"] = allEnabled;

    setState(() {});
  }

  List<ServiceWithPrice> _selectedServicesWithPrices = [];
  List<Service2> allServices = [];

  void loadSelectedServicesFromResponse(
    List<ProviderServices> providerServicesJson,
  ) {
    _selectedServicesWithPrices.clear();

    for (var item in providerServicesJson) {
      final service = item.service;
      final double price = double.parse(item.price);
      final int isActive = item.isActive;

      _selectedServicesWithPrices.add(
        ServiceWithPrice(service: service, price: price, isActive: isActive),
      );
    }

    setState(() {});
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _images = File(pickedFile.path);
        });
      }
    } catch (e) {
      showMessage('failed_to_pick_images');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final pickedFile = await _picker.pickMultiImage(
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _gallery.addAll(pickedFile.map((file) => File(file.path)).toList());
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("failed_to_take_photo".tr())));
    }
  }

  // New method to pick identity photo
  Future<void> _pickIdentityPhoto() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _identityPhoto = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick identity photo".tr())),
      );
    }
  }

  Future<void> _takeIdentityPhoto() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _identityPhoto = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to take identity photo".tr())),
      );
    }
  }

  // New method to pick practice license
  Future<void> _pickPracticePhoto() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _practicePhoto = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick practice license".tr())),
      );
    }
  }

  Future<void> _takePracticePhoto() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _practicePhoto = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick practice license".tr())),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    nickNameController.addListener(() {
      final name = nickNameController.text.trim();
      final isValid = name.isNotEmpty;
      if (isNickNameValid != isValid) {
        setState(() {
          isNickNameValid = isValid;
        });
      }
    });

    descriptionController.addListener(() {
      final desc = descriptionController.text.trim();
      final isValid = desc.isNotEmpty;
      if (isNickNameValid != isValid) {
        setState(() {
          isNickNameValid = isValid;
        });
      }
    });
    _workNumberController.addListener(() {
      final isValid = _workNumberController.text.isNotEmpty;
      if (isWorkValid != isValid) {
        setState(() {
          isWorkValid = isValid;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: MainAppBar(title: LocaleKeys.providerType.tr()),
      body: SafeArea(
        child: BlocConsumer(
          bloc: bloc,
          buildWhen: (previous, current) =>
              current is GetProviderProfileSuccessState ||
              current is GetProviderProfileFailedState ||
              current is GetProviderProfileLoadingState,
          listener: (context, state) {
            if (state is GetProviderProfileSuccessState) {
              if (state.model.providerTypes.isNotEmpty) {
                canEdit = true;
                final model = state.model.providerTypes.first;
                providerId = model.id;
                typeId = model.typeId;
                bookingType = model.type.bookingType;
                nickNameController.text = model.name;
                descriptionController.text = model.description;
                latitude = model.lat.toDouble();
                longitude = model.lng.toDouble();
                addressFromPicker = model.address;
                if (model.images.isNotEmpty) {
                  _imageFromApi = model.images.first.photoUrl;
                }
                if (model.galleries.isNotEmpty) {
                  for (var item in model.galleries) {
                    final url = item.photoUrl;
                    if (url.isNotEmpty) {
                      _galleryFromApi.add(url);
                    }
                  }
                }
                if (model.identityPhoto.isNotEmpty) {
                  _identityPhotoApi = model.identityPhoto;
                }
                if (model.practiceLicense.isNotEmpty) {
                  _practicePhotoApi = model.practiceLicense;
                }
                loadAvailabilities(model.availabilities);
                loadSelectedServicesFromResponse(model.providerServices);
                servicesBloc.add(GetServicesEvent());
                _pricePerHourController.text = model.pricePerHour.toString();
                setState(() {});
              }
            }
          },
          builder: (context, state) {
            if (state is GetProviderProfileSuccessState &&
                state.model.providerTypes.isEmpty) {
              return Center(
                child: AppButton(
                  text: LocaleKeys.completeData.tr(),
                  isSecondary: false,
                  onPress: () =>
                      navigateTo(FirstStepSignUpView(fromRegister: false)),
                ),
              );
            }
            return DefaultTabController(
              length: 3,
              initialIndex: selectedIndex,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    TabBar(
                      tabAlignment: TabAlignment.center,
                      isScrollable: true,
                      onTap: (value) {
                        if (selectedIndex != value) {
                          selectedIndex = value;
                          setState(() {});
                        }
                      },
                      labelStyle: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.primary,
                        fontFamily: getFontFamily(FontFamilyType.abhayaLibre),
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.primary,
                        fontFamily: getFontFamily(FontFamilyType.abhayaLibre),
                      ),
                      tabs: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Tab(text: LocaleKeys.basicInformation.tr()),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Tab(text: LocaleKeys.details.tr()),
                        ),
        
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Tab(text: LocaleKeys.photos.tr()),
                        ),
                      ],
                    ),
        
                    Builder(
                      builder: (context) {
                        if (state is GetProviderProfileFailedState) {
                          return Expanded(
                            child: AppFailed(
                              response: state.response,
                              onPress: () {
                                bloc.add(GetProviderProfileEvent());
                              },
                            ),
                          );
                        } else if (state is GetProviderProfileSuccessState) {
                          return Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: selectedIndex == 0
                                  ? Column(
                                      children: [
                                        AppInput(
                                          fixedPositionedLabel: LocaleKeys
                                              .yourWorkName
                                              .tr(),
                                          controller: nickNameController,
                                          validator: (v) =>
                                              InputValidator.requiredValidator(
                                                value: v!,
                                                itemName: LocaleKeys.yourWorkName
                                                    .tr(),
                                              ),
        
                                          marginBottom: 32.h,
                                        ),
                                        AppInput(
                                          fixedPositionedLabel: LocaleKeys
                                              .addYorJobDescription
                                              .tr(),
                                          controller: descriptionController,
                                          maxLines: 4,
                                          validator: (v) =>
                                              InputValidator.requiredValidator(
                                                value: v!,
                                                itemName: LocaleKeys.description
                                                    .tr(),
                                              ),
                                        ),
                                        AppInput(
                                          withShadow: false,
                                          fixedPositionedLabel: LocaleKeys
                                              .workNumber
                                              .tr(),
                                          controller: _workNumberController,
                                          validator: (v) =>
                                              InputValidator.requiredValidator(
                                                value: v!,
                                                itemName: LocaleKeys.workNumber
                                                    .tr(),
                                              ),
                                          keyboardType: TextInputType.number,
                                          marginBottom: 43.h,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            navigateTo(
                                              LocationView(withButton: true),
                                            ).then((value) {
                                              latitude = value.location.latitude;
                                              longitude =
                                                  value.location.longitude;
                                              addressFromPicker =
                                                  value.description;
                                              setState(() {});
                                            });
                                          },
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional.bottomCenter,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadiusGeometry.circular(15.r),
                                                child: AppImage(
                                                  'map.png',
                                                  height: 166.h,
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(16.r),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadiusDirectional.only(
                                                        bottomStart:
                                                            Radius.circular(15.r),
                                                        bottomEnd:
                                                            Radius.circular(15.r),
                                                      ),
                                                  color: Theme.of(
                                                    context,
                                                  ).scaffoldBackgroundColor,
                                                  boxShadow: [
                                                    AppTheme.mainShadow,
                                                  ],
                                                ),
                                                child: addressFromPicker != null
                                                    ? Row(
                                                        children: [
                                                          AppImage(
                                                            'marker_fill.png',
                                                            height: 12.h,
                                                            width: 12.h,
                                                          ),
                                                          SizedBox(width: 2.w),
                                                          Expanded(
                                                            child: Text(
                                                              addressFromPicker!,
                                                              style: TextStyle(
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            LocaleKeys.change
                                                                .tr(),
                                                            style: TextStyle(
                                                              fontSize: 10.sp,
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            LocaleKeys.addLocation
                                                                .tr(),
                                                            style: TextStyle(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                            ),
                                                          ),
                                                          AppImage(
                                                            'add.png',
                                                            height: 22.h,
                                                            width: 22.h,
                                                          ),
                                                        ],
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : selectedIndex == 1
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          LocaleKeys.workingHours.tr(),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
        
                                        SingleChildScrollView(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 16.h,
                                          ),
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: days.keys.map((day) {
                                              return GestureDetector(
                                                onTap: () {
                                                  _toggleDaySelection(day);
                                                  setState(() {});
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8.w,
                                                  ),
                                                  child: Opacity(
                                                    opacity: days[day]!["enabled"]
                                                        ? 1
                                                        : 0.4,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 20.sp,
                                                            vertical: 3.sp,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .secondaryHeaderColor,
                                                        boxShadow: [
                                                          AppTheme.mainShadow,
                                                          AppTheme.whiteShadow,
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              30.r,
                                                            ),
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
                                            if (days["Always"]?["enabled"] ==
                                                true) ...[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: days["Always"]!["times"]
                                                    .map<Widget>((timeSlot) {
                                                      final index =
                                                          days["Always"]!["times"]
                                                              .indexOf(timeSlot);
                                                      return _buildTimeRow(
                                                        "Always",
                                                        days["Always"]!,
                                                        timeSlot,
                                                        index,
                                                      );
                                                    })
                                                    .toList(),
                                              ),
                                            ] else ...[
                                              Column(
                                                children: days.keys.map((day) {
                                                  final dayData = days[day]!;
                                                  if (!dayData["enabled"] ||
                                                      day == "Always") {
                                                    return const SizedBox.shrink();
                                                  }
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: dayData["times"]
                                                        .map<Widget>((timeSlot) {
                                                          final index =
                                                              dayData["times"]
                                                                  .indexOf(
                                                                    timeSlot,
                                                                  );
                                                          return _buildTimeRow(
                                                            day,
                                                            dayData,
                                                            timeSlot,
                                                            index,
                                                          );
                                                        })
                                                        .toList(),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        Divider(height: 2.h),
                                        SizedBox(height: 20.h),
                                        if (state
                                                .model
                                                .providerTypes
                                                .first
                                                .type
                                                .bookingType !=
                                            "hourly") ...[
                                          Text(LocaleKeys.WhatYourService.tr()),
                                          SizedBox(height: 10.h),
                                          BlocConsumer(
                                            bloc: servicesBloc,
                                            listener: (context, serviceState) {
                                              print('+++++++++++++++');
                                              if (serviceState
                                                  is GetServicesSuccessState) {
                                                allServices = servicesBloc.list;
                                                print('+++++++++++++++');
                                                print(allServices.length);
                                                print('+++++++++++++++');
                                              }
                                            },
                                            builder: (context, serviceState) {
                                              if (serviceState
                                                  is GetServicesFailedState) {
                                                return AppFailed(
                                                  response: serviceState.response,
                                                  isSmallShape: true,
                                                  onPress: () => servicesBloc.add(
                                                    GetServicesEvent(),
                                                  ),
                                                );
                                              } else if (serviceState
                                                  is GetServicesSuccessState) {
                                                return InkWell(
                                                  onTap: () =>
                                                      _showServicePriceDialog(
                                                        context,
                                                      ),
                                                  child: Row(
                                                    children: [
                                                      AppCircleIcon(
                                                        img: 'plus.png',
                                                        bgRadius: 18.r,
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      Expanded(
                                                        child: SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: _selectedServicesWithPrices
                                                                .map(
                                                                  (
                                                                    serviceWithPrice,
                                                                  ) => Padding(
                                                                    padding:
                                                                        EdgeInsets.symmetric(
                                                                          vertical:
                                                                              4.h,
                                                                        ),
                                                                    child: Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            4.w,
                                                                      ),
                                                                      margin:
                                                                          EdgeInsetsDirectional.only(
                                                                            end: 8
                                                                                .w,
                                                                          ),
                                                                      decoration: BoxDecoration(
                                                                        color: AppTheme
                                                                            .hoverColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              15.r,
                                                                            ),
                                                                        boxShadow: [
                                                                          AppTheme
                                                                              .mainShadow,
                                                                        ],
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                          Text(
                                                                            serviceWithPrice
                                                                                .service
                                                                                .name,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                4.w,
                                                                          ),
                                                                          Container(
                                                                            padding: EdgeInsets.symmetric(
                                                                              horizontal:
                                                                                  4.w,
                                                                            ),
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(
                                                                                15.r,
                                                                              ),
                                                                              color:
                                                                                  AppTheme.canvasColor,
                                                                            ),
                                                                            child: Text(
                                                                              "${serviceWithPrice.price} ${LocaleKeys.jod.tr()}",
                                                                            ),
                                                                          ),
                                                                          IconButton(
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            constraints:
                                                                                const BoxConstraints(),
                                                                            onPressed: () {
                                                                              setState(() {
                                                                                _selectedServicesWithPrices.remove(
                                                                                  serviceWithPrice,
                                                                                );
                                                                              });
                                                                            },
                                                                            icon: Icon(
                                                                              Icons.close,
                                                                              size:
                                                                                  20.sp,
                                                                              color:
                                                                                  Colors.red,
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
                                                  ),
                                                );
                                              }
                                              return SizedBox.shrink();
                                            },
                                          ),
                                          SizedBox(height: 32.h),
        
                                        ],
                                        Text(
                                          state
                                              .model
                                              .providerTypes
                                              .first
                                              .type
                                              .bookingType !=
                                              "hourly"
                                              ? LocaleKeys
                                              .setTheMaximumNumberOfBookingsPerHour
                                              .tr()
                                              : LocaleKeys
                                              .howMuchDoYouChargePerHour
                                              .tr(),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 100.w,
                                                child: AppInput(
                                                  withShadow: false,
                                                  marginBottom: 0,
                                                  controller:
                                                  _pricePerHourController,
                                                  keyboardType:
                                                  TextInputType.number,
                                                  validator: (v) =>
                                                      InputValidator.requiredValidator(
                                                        value: v!,
                                                        itemName: 'price',
                                                      ),
                                                ),
                                              ),
                                              if (state
                                                  .model
                                                  .providerTypes
                                                  .first
                                                  .type
                                                  .bookingType ==
                                                  "hourly") ...[
                                                SizedBox(width: 8.w),
        
                                                Text(
                                                  LocaleKeys.jodHour.tr(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 10,
                                                    fontFamily: getFontFamily(
                                                      FontFamilyType.inter,
                                                    ),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          LocaleKeys.addProfilePicture.tr(),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 150.w,
                                          child: Divider(height: 2),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          LocaleKeys.youCanChooseOnlyPhoto.tr(),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        InkWell(
                                          onTap: _pickImages,
                                          child:
                                              _images == null &&
                                                  _imageFromApi == null
                                              ? Stack(
                                                  alignment: AlignmentDirectional
                                                      .bottomCenter,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Color(0xffF2F2F2),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15.r,
                                                            ),
                                                      ),
                                                      child: AppImage(
                                                        'image.png',
                                                        height: 166.h,
                                                        width: MediaQuery.of(
                                                          context,
                                                        ).size.width,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                        16.r,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadiusDirectional.only(
                                                              bottomStart:
                                                                  Radius.circular(
                                                                    15.r,
                                                                  ),
                                                              bottomEnd:
                                                                  Radius.circular(
                                                                    15.r,
                                                                  ),
                                                            ),
                                                        color: Theme.of(
                                                          context,
                                                        ).scaffoldBackgroundColor,
                                                        boxShadow: [
                                                          AppTheme.mainShadow,
                                                        ],
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            LocaleKeys.uploadFile
                                                                .tr(),
                                                            style: TextStyle(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                            ),
                                                          ),
                                                          AppImage(
                                                            'add.png',
                                                            height: 22.h,
                                                            width: 22.h,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : _images != null
                                              ? ItemImage(
                                                  image: _images!.path,
                                                  onRemove: () {
                                                    _images = null;
                                                    setState(() {});
                                                  },
                                                )
                                              : ItemImage(
                                                  image: _imageFromApi!,
                                                  onRemove: () {
                                                    _imageFromApi = null;
                                                    setState(() {});
                                                  },
                                                ),
                                        ),
                                        SizedBox(height: 20.h),
                                        Text(
                                          LocaleKeys.galleryPhotos.tr(),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60.w,
                                          child: Divider(height: 2),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          LocaleKeys.youCanUploadYourWorkingPlace
                                              .tr(),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ItemPick(onTap: _takePhoto),
                                              if (_gallery.isNotEmpty ||
                                                  _galleryFromApi.isNotEmpty)
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.only(
                                                        start: 20.w,
                                                      ),
                                                  child: AllImagesItem(
                                                    imageList: _gallery.isNotEmpty
                                                        ? _gallery
                                                              .map((e) => e.path)
                                                              .toList()
                                                        : _galleryFromApi,
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled: true,
                                                        builder: (context) => StatefulBuilder(
                                                          builder: (context, setState2) => BaseSheet(
                                                            title: '',
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                                                children: List.generate(
                                                                  _gallery.isNotEmpty
                                                                      ? _gallery
                                                                            .length
                                                                      : _galleryFromApi
                                                                            .length,
                                                                  (
                                                                    index,
                                                                  ) => Padding(
                                                                    padding:
                                                                        EdgeInsets.only(
                                                                          bottom:
                                                                              12.h,
                                                                        ),
                                                                    child: Stack(
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadiusGeometry.circular(
                                                                                15.r,
                                                                              ),
                                                                          child: AppImage(
                                                                            _gallery.isNotEmpty
                                                                                ? _gallery[index].path
                                                                                : _galleryFromApi[index],
                                                                            height:
                                                                                150.h,
                                                                            width: MediaQuery.of(
                                                                              context,
                                                                            ).size.width,
                                                                            fit: BoxFit
                                                                                .cover,
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          top: 4,
                                                                          right:
                                                                              4,
                                                                          child: GestureDetector(
                                                                            onTap: () {
                                                                              if (_gallery.isNotEmpty) {
                                                                                _gallery.removeAt(
                                                                                  index,
                                                                                );
                                                                              } else {
                                                                                _galleryFromApi.removeAt(
                                                                                  index,
                                                                                );
                                                                              }
        
                                                                              if (_gallery.isEmpty &&
                                                                                  _galleryFromApi.isEmpty) {
                                                                                Navigator.pop(
                                                                                  context,
                                                                                );
                                                                              }
                                                                              setState(
                                                                                () {},
                                                                              );
                                                                              setState2(
                                                                                () {},
                                                                              );
                                                                            },
                                                                            child: Container(
                                                                              decoration: const BoxDecoration(
                                                                                color: AppTheme.canvasColor,
                                                                                shape: BoxShape.circle,
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.close,
                                                                                size: 20.sp,
                                                                                color: AppTheme.primary,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
        
                                        SizedBox(height: 20.h),
                                        Text(
                                          LocaleKeys.nationalID.tr(),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        if (_identityPhoto != null ||
                                            _identityPhotoApi != null)
                                          ItemImage(
                                            image: _identityPhoto != null
                                                ? _identityPhoto!.path
                                                : _identityPhotoApi!,
                                            onRemove: () {
                                              _identityPhoto = null;
                                              _identityPhotoApi = null;
                                              setState(() {});
                                            },
                                          ),
                                        if (_identityPhoto == null &&
                                            _identityPhotoApi == null)
                                          Center(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ItemPick(
                                                  onTap: _pickIdentityPhoto,
                                                ),
                                                SizedBox(width: 20.w),
                                                ItemTake(
                                                  onTap: _takeIdentityPhoto,
                                                ),
                                              ],
                                            ),
                                          ),
        
                                        SizedBox(height: 20.h),
                                        Text(
                                          LocaleKeys.commercialRegistration.tr(),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        if (_practicePhoto != null ||
                                            _practicePhotoApi != null)
                                          ItemImage(
                                            image: _practicePhoto != null
                                                ? _practicePhoto!.path
                                                : _practicePhotoApi!,
                                            onRemove: () {
                                              _practicePhoto = null;
                                              _practicePhotoApi = null;
                                              setState(() {});
                                            },
                                          ),
                                        if (_practicePhoto == null &&
                                            _practicePhotoApi == null)
                                          Center(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ItemPick(
                                                  onTap: _pickPracticePhoto,
                                                ),
                                                SizedBox(width: 20.w),
                                                ItemTake(
                                                  onTap: _takePracticePhoto,
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                            ),
                          );
                        }
                        return Expanded(child: AppLoading());
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: canEdit
          ? BlocConsumer(
              bloc: updateBloc,
              listener: (context, state) {
                if (state is CompleteDataUpdateSuccessState) {
                  Navigator.pop(context);
                  showMessage(state.msg, type: MessageType.success);
                }
              },
              builder: (context, state) {
                return AppButton(
                  text: CacheHelper.lang == 'en' ? 'edit' : 'تعديل',
                  isLoading: state is CompleteDataUpdateLoadingState,
                  type: ButtonType.bottomNav,
                  onPress: () {
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
                    final availabilityData = (availability)
                        .map(
                          (a) => Availability(
                            dayOfWeek: a['day_of_week'],
                            startTime: a['start_time'],
                            endTime: a['end_time'],
                          ),
                        )
                        .toList();

                    final providerType = ProviderType(
                      typeId: typeId,
                      name: nickNameController.text,
                      description: descriptionController.text,
                      lat: longitude ?? 0,
                      lng: longitude ?? 0,
                      address: addressFromPicker ?? '',
                      // widget.signUpData['address'],
                      pricePerHour: bookingType == "hourly"
                          ? double.parse(_pricePerHourController.text)
                          : 0.0,
                      servicesWithPrices: bookingType == "service"
                          ? _selectedServicesWithPrices
                                .map((service) => service.toMap())
                                .toList()
                          : null,
                      serviceIds: bookingType == "hourly"
                          ? null
                          : _selectedServicesWithPrices
                                .map((service) => service.service.id)
                                .toList(),
                      images: _images,
                      gallery: _gallery,
                      availability: availabilityData,
                      identityPhoto: _identityPhoto,
                      practicePhoto: _practicePhoto,
                    );
                    updateBloc.add(
                      CompleteDataUpdateEvent(
                        providerTypes: [providerType],
                        providerId: providerId,
                      ),
                    );
                  },
                );
              },
            )
          : SizedBox.shrink(),
    );
  }
}
