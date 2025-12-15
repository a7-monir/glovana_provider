import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/core/design/app_button.dart';
import 'package:glovana_provider/core/design/app_input.dart';
import 'package:glovana_provider/core/logic/cache_helper.dart';
import 'package:glovana_provider/core/logic/input_validator.dart';
import 'package:glovana_provider/features/types/bloc.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:glovana_provider/views/auth/signup/second_step.dart';
import 'package:kiwi/kiwi.dart';

import '../../../core/app_theme.dart';
import '../../../core/design/app_drop_down.dart';
import '../../../core/design/app_failed.dart';
import '../../../core/design/app_image.dart';
import '../../../core/logic/helper_methods.dart';
import '../../../features/delivery/bloc.dart';
import '../../../features/services/bloc.dart';
import '../../location/view.dart';

class FirstStepSignUpView extends StatefulWidget {
  TypeModel? typeModel;
  final bool fromRegister;

  FirstStepSignUpView({super.key, this.typeModel, this.fromRegister = true});

  @override
  State<FirstStepSignUpView> createState() => _FirstStepSignUpViewState();
}

class _FirstStepSignUpViewState extends State<FirstStepSignUpView> {
  final typesBloc = KiwiContainer().resolve<TypesBloc>();

  final nickNameController = TextEditingController();
  bool isNickNameValid = true;
  bool isDescriptionValid = true;
  final descriptionController = TextEditingController();
  bool isCityValid = true;

  final cityController = TextEditingController();
  double? latitude;
  double? longitude;
  String? addressFromPicker;
  int? deliveryId;
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();
  final deliveryBloc = KiwiContainer().resolve<GetDeliveryBloc>()
    ..add(GetDeliveryEvent());

  @override
  void initState() {
    super.initState();

    if (!widget.fromRegister) {
      typesBloc.add(GetTypesEvent());
    }
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
    cityController.addListener(() {
      final isValid = cityController.text.isNotEmpty;
      if (isCityValid != isValid) {
        setState(() {
          isCityValid = isValid;
        });
      }
    });
  }

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
              if(!widget.fromRegister)
              BlocBuilder(
                bloc: typesBloc,
                builder: (context, state) {
                  if (state is GetServicesFailedState) {
                    return AppFailed(
                      isSmallShape: true,
                      response: state.response,
                      onPress: () {
                        typesBloc.add(GetTypesEvent());
                      },
                    );
                  }
                  return AppDropDown(
                    title: LocaleKeys.workType.tr(),
                    list: typesBloc.list.map((e) => e.name).toList(),
                    isLoading: state is GetTypesLoadingState,
                    validator: (v) => InputValidator.requiredValidator(
                      value: v!,
                      itemName: LocaleKeys.workType.tr(),
                    ),
                    hint: '',
                    onChoose: (value) {
                      widget.typeModel = TypeModel(
                        id: typesBloc.list[value].id,
                        name: typesBloc.list[value].name,
                        bookingType: typesBloc.list[value].bookingType,
                      );
                      //bloc.deliveryId = deliveryBloc.list[value].id;
                    },
                  );
                },
              ),
              SizedBox(height: 10.h),
              AppInput(
                fixedPositionedLabel: LocaleKeys.yourWorkName.tr(),
                controller: nickNameController,
                validator: (v) => InputValidator.requiredValidator(
                  value: v!,
                  itemName: LocaleKeys.yourWorkName.tr(),
                ),

                marginBottom: 32.h,
              ),
              AppInput(
                fixedPositionedLabel: LocaleKeys.addYorJobDescription.tr(),
                controller: descriptionController,
                maxLines: 4,
                validator: (v) => InputValidator.requiredValidator(
                  value: v!,
                  itemName: LocaleKeys.description.tr(),
                ),
              ),
              Text(
                LocaleKeys.address.tr(),
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              ),
              GestureDetector(
                onTap: () {
                  navigateTo(LocationView(withButton: true)).then((value) {
                    latitude = value.location.latitude;
                    longitude = value.location.longitude;
                    addressFromPicker = value.description;
                    setState(() {});
                  });
                },
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    AppImage(
                      'map.png',
                      height: 166.h,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                          bottomStart: Radius.circular(15.r),
                          bottomEnd: Radius.circular(15.r),
                        ),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [AppTheme.mainShadow],
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
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Text(
                                  LocaleKeys.change.tr(),
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.addLocation.tr(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                AppImage('add.png', height: 22.h, width: 22.h),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              AppInput(
                fixedPositionedLabel: LocaleKeys.city.tr(),
                controller: cityController,
                validator: (v) => InputValidator.requiredValidator(
                  value: v!,
                  itemName: LocaleKeys.city.tr(),
                ),

                marginBottom: 32.h,
              ),
              BlocBuilder(
                bloc: deliveryBloc,
                builder: (context, state) {
                  if (state is GetDeliveryFailedState) {
                    return AppFailed(
                      isSmallShape: true,
                      response: state.response,
                      onPress: () {
                        deliveryBloc.add(GetDeliveryEvent());
                      },
                    );
                  }
                  return AppDropDown(
                    title: LocaleKeys.deliveryArea.tr(),
                    list: deliveryBloc.list.map((e) => e.place).toList(),
                    isLoading: state is GetDeliveryLoadingState,
                    validator: (v) => InputValidator.requiredValidator(
                      value: v!,
                      itemName: LocaleKeys.deliveryArea.tr(),
                    ),
                    hint: '',
                    onChoose: (value) {
                      deliveryId = deliveryBloc.list[value].id;
                    },
                  );
                },
              ),


            ],
          ),
        ),
      ),
      bottomNavigationBar:   AppButton(
        text: LocaleKeys.Continue.tr(),
        type: ButtonType.bottomNav,
        onPress: () {
          if (formKey.currentState!.validate()) {
            if (longitude != null &&
                latitude != null &&
                addressFromPicker != null &&
                widget.typeModel != null) {
              final model = FirstStepModel(
                nickName: nickNameController.text,
                bookingType: widget.typeModel!.bookingType,
                description: descriptionController.text,
                address: cityController.text,
                city: cityController.text,
                addressFromPicker: addressFromPicker!,
                typeId: widget.typeModel!.id,
                lat: latitude!,
                lng: longitude!,
              );
              navigateTo(
                SecondStepSignUpView(
                  firstStepModel: model,
                  isSalon:
                  widget.typeModel!.name.toLowerCase() ==
                      'saloon'||widget.typeModel!.name.toLowerCase() ==
                      'salon',
                ),
              );
            } else {
              showMessage(
                LocaleKeys.youMustChooseAddress.tr(),
                type: MessageType.warning,
              );
            }
          }
          validateMode = AutovalidateMode.onUserInteraction;
          setState(() {});
        },
      ),
    );
  }
}

class FirstStepModel {
  final String nickName,
      bookingType,
      address,
      city,
      addressFromPicker,
      description;
  final int typeId;
  final double lat, lng;

  FirstStepModel({
    required this.nickName,
    required this.bookingType,
    required this.address,
    required this.city,
    required this.addressFromPicker,
    required this.typeId,
    required this.lat,
    required this.lng,
    required this.description,
  });
}
