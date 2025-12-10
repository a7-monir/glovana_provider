import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/features/reset_password/bloc.dart';
import 'package:glovana_provider/views/auth/login/view.dart';
import 'package:kiwi/kiwi.dart';

import '../../../core/design/app_button.dart';
import '../../../core/design/app_image.dart';
import '../../../core/design/app_input.dart';
import '../../../core/logic/helper_methods.dart';
import '../../../core/logic/input_validator.dart';
import '../../../generated/locale_keys.g.dart';

class ChangePasswordView extends StatefulWidget {
  final String phone;

  const ChangePasswordView({super.key, required this.phone});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final bloc = KiwiContainer().resolve<ResetPasswordBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Form(
          key: bloc.formKey,
          autovalidateMode: bloc.validateMode,
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
                LocaleKeys.pleaseEnterYourNewPassword.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: Theme.of(context).hintColor,
                  fontFamily: getFontFamily(FontFamilyType.inter),
                ),
              ),
              SizedBox(height: 24.h),
              AppInput(
                fixedPositionedLabel: LocaleKeys.password.tr(),
                hint: LocaleKeys.password.tr(),
                inputType: InputType.password,
                controller: bloc.passwordController,
                validator: (v) =>
                    InputValidator.passwordValidator(v!, lengthRequired: true),
              ),
              AppInput(
                fixedPositionedLabel: LocaleKeys.confirmPassword.tr(),
                hint: LocaleKeys.confirmPassword.tr(),
                inputType: InputType.password,
                controller:bloc.confirmPasswordController ,
                validator: (v) => InputValidator.confirmPasswordValidator(
                  v!,
                  bloc.passwordController.text,

                ),
              ),

              SizedBox(height: 32.h),

              BlocConsumer(
                bloc: bloc,
                listener: (context, state) {
                  if(state is ResetPasswordSuccessState){
                    showMessage(state.msg);
                   navigateTo(LoginView(),keepHistory: false);
                  }
                },
                builder: (context, state) {
                  return AppButton(text: LocaleKeys.confirm.tr(),
                    isLoading: state is ResetPasswordLoadingState,
                    onPress: () {
                      if (bloc.formKey.currentState!.validate()) {
                        bloc.add(ResetPasswordEvent(phone: widget.phone));
                      } else {
                        bloc.validateMode = AutovalidateMode.onUserInteraction;
                        setState(() {});
                      }
                    },);
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}
