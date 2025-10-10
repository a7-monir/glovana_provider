import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:kiwi/kiwi.dart';

import '../../core/design/app_bar.dart';
import '../../core/design/app_button.dart';
import '../../core/design/app_input.dart';
import '../../core/logic/helper_methods.dart';
import '../../core/logic/input_validator.dart';
import '../../features/edit_profile/bloc.dart';
import '../../generated/locale_keys.g.dart';
import '../home_nav/pages/profile/components/photo.dart';
import '../home_nav/view.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final bloc = KiwiContainer().resolve<EditProfileBloc>();

  @override
  void initState() {
    super.initState();
    bloc.phoneController.addListener(() {
      final phone = bloc.phoneController.text.trim();
      final isValid = InputValidator.jordanNumberReg.hasMatch(phone);
      if (bloc.phoneValid != isValid) {
        setState(() {
          bloc.phoneValid = isValid;
        });
      }
    });
    bloc.emailController.addListener(() {
      final email = bloc.emailController.text.trim();
      final isValid = InputValidator.emailReg.hasMatch(email);
      if (bloc.emailValid != isValid) {
        setState(() {
          bloc.emailValid = isValid;
        });
      }
    });
    bloc.firstNameController.addListener(() {
      final name = bloc.firstNameController.text;
      final isValid = name.isNotEmpty;
      if (bloc.firstNameValid != isValid) {
        setState(() {
          bloc.firstNameValid = isValid;
        });
      }
    });
    bloc.lastNameController.addListener(() {
      final name = bloc.lastNameController.text;
      final isValid = name.isNotEmpty;
      if (bloc.lastNameValid != isValid) {
        setState(() {
          bloc.lastNameValid = isValid;
        });
      }
    });
  }

  @override
  void dispose() {
    bloc.firstNameController.dispose();
    bloc.lastNameController.dispose();
    bloc.phoneController.dispose();
    bloc.emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: LocaleKeys.editProfile.tr()),
      body: Form(
        key: bloc.formKey,
        autovalidateMode: bloc.validateMode,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              ItemPhoto(canEdit: true,
              onChange: (v) {
                bloc.photo=v;
              },
              ),
              SizedBox(height: 30.h),
              Row(
                children: [
                  Expanded(
                    child: AppInput(
                      fixedPositionedLabel: LocaleKeys.firstName.tr(),
                      isCenterTitle: true,
                      controller: bloc.firstNameController,
                      isValid: bloc.firstNameValid,
                      marginBottom: 32.h,
                      validator:
                          (v) => InputValidator.requiredValidator(
                            value: v!,
                            itemName: LocaleKeys.firstName.tr(),
                          ),
                    ),
                  ),
                  SizedBox(width: 32.w),
                  Expanded(
                    child: AppInput(
                      fixedPositionedLabel: LocaleKeys.lastName.tr(),
                      isCenterTitle: true,
                      controller: bloc.lastNameController,
                      isValid: bloc.lastNameValid,
                      validator:
                          (v) => InputValidator.requiredValidator(
                            value: v!,
                            itemName: LocaleKeys.lastName.tr(),
                          ),
                    ),
                  ),
                ],
              ),
              AppInput(
                fixedPositionedLabel: LocaleKeys.phoneNo.tr(),
                keyboardType: TextInputType.phone,
                inputType: InputType.phone,
                controller: bloc.phoneController,
                isValid: bloc.phoneValid,
                validator: (v) => InputValidator.validatePhone(v!),
              ),
              AppInput(
                fixedPositionedLabel: LocaleKeys.emailAddress.tr(),
                keyboardType: TextInputType.emailAddress,
                controller: bloc.emailController,
                isValid: bloc.emailValid,
                marginBottom: 40.h,
                validator: (v) => InputValidator.emailValidator(v!),
              ),
              BlocConsumer(
                bloc: bloc,
                listener: (context, state) {
                  if(state is EditProfileSuccessState){
                    navigateTo(HomeNavView(pageIndex: 2,),keepHistory: false);
                  }
                },
                builder: (context, state) {
                  return AppButton(
                    text: LocaleKeys.confirm.tr(),
                    isLoading: state is EditProfileLoadingState,
                    onPress: () {
                      if (bloc.formKey.currentState!.validate()) {
                        bloc.add(EditProfileEvent());
                      } else {
                        bloc.validateMode = AutovalidateMode.onUserInteraction;
                        setState(() {});
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
