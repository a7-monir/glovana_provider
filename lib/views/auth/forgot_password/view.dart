import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/core/design/app_button.dart';
import 'package:glovana_provider/core/design/app_image.dart';
import 'package:glovana_provider/core/logic/helper_methods.dart';
import 'package:glovana_provider/features/check_phone/bloc.dart';
import 'package:glovana_provider/views/auth/otp/view.dart';
import 'package:kiwi/kiwi.dart';

import '../../../core/design/app_input.dart';
import '../../../core/logic/input_validator.dart';
import '../../../generated/locale_keys.g.dart';
import '../change_password/view.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final bloc = KiwiContainer().resolve<CheckPhoneBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondAppBar(),
      body: Form(
        key: bloc.formKey,
        autovalidateMode: bloc.validateMode,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.h),
              AppImage('logo.png', height: 90.h, width: 90.h),
              SizedBox(height: 24.h),
              Text(
                LocaleKeys.resetPassword.tr(),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp),
              ),
              SizedBox(height: 12.h),
              Text(
                LocaleKeys.pleaseEnterYourPhoneToResetYourPassword.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: Theme.of(context).hintColor,
                  fontFamily: getFontFamily(FontFamilyType.inter),
                ),
              ),
              SizedBox(height: 24.h),
              AppInput(
                fixedPositionedLabel: LocaleKeys.phoneNo.tr(),
                keyboardType: TextInputType.phone,
                inputType: InputType.phone,
                controller: bloc.phoneController,
                validator: (v) => InputValidator.validatePhone(v!),
              ),
              SizedBox(height: 32.h),
              BlocConsumer(
                bloc: bloc,
                listener: (context, state) {
                  if (state is CheckPhoneSuccessState) {
                    navigateTo(
                      VerifyOtpScreen(
                        phone: bloc.phoneController.text,
                        onSuccess: () {
                          navigateTo(
                            ChangePasswordView(
                              phone: bloc.phoneController.text,
                            ),
                            replacement: true
                          );
                        },
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return AppButton(
                    text: LocaleKeys.Continue.tr(),
                    isLoading: state is CheckPhoneLoadingState,
                    onPress: () {
                      if (bloc.formKey.currentState!.validate()) {
                        bloc.add(CheckPhoneEvent());
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
