import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import '../../../core/design/app_button.dart';
import '../../../core/design/app_circle_icon.dart';
import '../../../core/design/app_input.dart';
import '../../../core/logic/cache_helper.dart';
import '../../../core/logic/helper_methods.dart';
import '../../../core/logic/input_validator.dart';
import '../../../features/google_login/bloc.dart';
import '../../../features/login/bloc.dart';
import '../../../generated/locale_keys.g.dart';
import '../../home_nav/view.dart';
import '../components/auth_header.dart';
import '../components/choose_lang_item.dart';
import '../components/have_account.dart';
import '../components/with_section.dart';
import '../done_complete_profile.dart';
import '../forgot_password/view.dart';
import '../otp/view.dart';
import '../signup/view.dart';

part '../components/social_section.dart';

part '../components/switch_button_section.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final bloc = KiwiContainer().resolve<LoginBloc>();
  //final socialLoginBloc = KiwiContainer().resolve<SocialLoginBloc>();

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
    bloc.passwordController.addListener(() {
      final password = bloc.passwordController.text;
      final isValid = password.length >= 8;
      if (bloc.passwordValid != isValid) {
        setState(() {
          bloc.passwordValid = isValid;
        });
      }
    });
  }



  bool isLogin = true;
  late String phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: bloc.formKey,
        autovalidateMode: bloc.validateMode,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Center(child: AuthHeader(isLogin: true)),
                    ChooseLangItem(onChange: () => navigateTo(LoginView(),keepHistory: false),),
                  ],
                ),
                SizedBox(height: 60.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: AppInput(
                    fixedPositionedLabel: LocaleKeys.phoneNo.tr(),
                    keyboardType: TextInputType.phone,
                    inputType: InputType.phone,
                    controller: bloc.phoneController,
                    isValid: bloc.phoneValid,
                    validator: (v) => InputValidator.validatePhone(v!),
                    onChanged: (value) {

                      phone=value;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: AppInput(
                    fixedPositionedLabel: LocaleKeys.password.tr(),
                    inputType: InputType.password,
                    controller: bloc.passwordController,
                    isValid: bloc.passwordValid,
                    validator: (v) => InputValidator.passwordValidator(
                      v!,
                      lengthRequired: true,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => navigateTo(ForgotPasswordView()),
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(end: 14.w),
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(
                        LocaleKeys.forgotPassword.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.h),
                BlocConsumer(
                  bloc: bloc,
                  listener: (context, state) {
                    if (state is LoginSuccessState) {
                      navigateTo(
                        VerifyOtpScreen(
                          phone: phone,
                          onSuccess: () {
                            CacheHelper.setToken(state.token);
                            CacheHelper.saveData(state.model);
                            CacheHelper.saveBanInfo(bloc.banInfo!);
                            if(state.model.activate==3||state.model.activate==2){
                              navigateTo(DoneCompleteProfileView(), keepHistory: false);
                            }else{
                              navigateTo(HomeNavView());
                            }

                          },
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return AppButton(
                      text: LocaleKeys.login.tr(),
                      isLoading: state is LoginLoadingState,
                      padding: EdgeInsets.symmetric(horizontal: 64.w),
                      onPress: () {
                        if (bloc.formKey.currentState!.validate()) {
                          bloc.add(LoginEvent());
                        } else {
                          bloc.validateMode =
                              AutovalidateMode.onUserInteraction;
                          setState(() {});
                        }
                      },
                    );
                  },
                ),

                // WithSection(isLogin: true),
                // SizedBox(height: 32.h),
                // SocialSignInButtons(
                //   isGoogleLoading:
                //       socialState is SocialLoginLoadingState &&
                //       socialLoginBloc.isGoogle,
                //   isAppleLoading:
                //       socialState is SocialLoginLoadingState &&
                //       !socialLoginBloc.isGoogle,
                //   onGoogleSignIn: () {
                //     signInWithGoogle().then((value) {
                //       socialLoginBloc.photoUrl = value?.googleUser.photoUrl;
                //       socialLoginBloc.googleId = value?.googleUser.id;
                //       socialLoginBloc.name = value?.googleUser.displayName;
                //       socialLoginBloc.email = value?.googleUser.email;
                //       socialLoginBloc.accessToken =
                //           value?.googleAuth.accessToken ??
                //           value?.googleAuth.idToken;
                //       socialLoginBloc.add(SocialLoginEvent(isGoogle: true));
                //     });
                //   },
                //   onAppleSignIn: () {
                //     signInWithApple().then((value) {
                //       socialLoginBloc.appleId =
                //           value?.appleAuth.userIdentifier;
                //       socialLoginBloc.email = value?.appleAuth.email;
                //       socialLoginBloc.name =
                //           '${value?.appleAuth.givenName ?? ''} ${value?.appleAuth.familyName ?? ''}';
                //       socialLoginBloc.accessToken =
                //           value?.appleAuth.identityToken;
                //
                //       socialLoginBloc.add(
                //         SocialLoginEvent(isGoogle: false),
                //       );
                //     });
                //   },
                // ),
                SizedBox(height: 43.h),
                HaveAccountSection(isLogin: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
