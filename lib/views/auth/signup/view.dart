import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/features/types/bloc.dart';
import 'package:glovana_provider/views/static_page/view.dart';

import 'package:kiwi/kiwi.dart';

import '../../../core/design/app_button.dart';
import '../../../core/design/app_drop_down.dart';
import '../../../core/design/app_failed.dart';
import '../../../core/design/app_input.dart';
import '../../../core/logic/helper_methods.dart';
import '../../../core/logic/input_validator.dart';
import '../../../features/google_login/bloc.dart';
import '../../../features/services/bloc.dart';
import '../../../features/signup/bloc.dart';
import '../../../generated/locale_keys.g.dart';
import '../components/auth_header.dart';
import '../components/choose_lang_item.dart';
import '../components/have_account.dart';
import '../components/social_buttons.dart';
import '../components/with_section.dart';
import 'first_step.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final bloc = KiwiContainer().resolve<SignupBloc>();
  final socialLoginBloc = KiwiContainer().resolve<SocialLoginBloc>();
  final typesBloc = KiwiContainer().resolve<TypesBloc>()..add(GetTypesEvent());

  TypeModel? selectedModel;
  bool isAccept = false;

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

    bloc.passwordController.addListener(() {
      final password = bloc.passwordController.text;
      final isValid = password.length >= 8;
      if (bloc.passwordValid != isValid) {
        setState(() {
          bloc.passwordValid = isValid;
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
    bloc.passwordController.dispose();
    bloc.emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: socialLoginBloc,
      listener: (context, state) {
        if (state is SocialLoginSuccessState) {
          //navigateTo(CompleteProfileView());
        }
      },
      builder: (context, state) {
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
                        Center(child: AuthHeader(isLogin: false)),
                        ChooseLangItem(),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppInput(
                              fixedPositionedLabel: LocaleKeys.firstName.tr(),
                              isCenterTitle: true,
                              controller: bloc.firstNameController,
                              isValid: bloc.firstNameValid,
                              validator: (v) =>
                                  InputValidator.requiredValidator(
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
                              validator: (v) =>
                                  InputValidator.requiredValidator(
                                    value: v!,
                                    itemName: LocaleKeys.lastName.tr(),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: AppInput(
                        fixedPositionedLabel: LocaleKeys.phoneNo.tr(),
                        keyboardType: TextInputType.phone,
                        inputType: InputType.phone,
                        controller: bloc.phoneController,
                        isValid: bloc.phoneValid,
                        validator: (v) => InputValidator.validatePhone(v!),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: AppInput(
                        fixedPositionedLabel: LocaleKeys.emailAddress.tr(),
                        keyboardType: TextInputType.emailAddress,
                        controller: bloc.emailController,
                        isValid: bloc.emailValid,
                        validator: (v) => InputValidator.emailValidator(v!),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: AppInput(
                        fixedPositionedLabel: LocaleKeys.createPassword.tr(),
                        isPassword: true,
                        marginBottom: 32.h,
                        controller: bloc.passwordController,
                        isValid: bloc.passwordValid,
                        validator: (v) => InputValidator.passwordValidator(
                          v!,
                          lengthRequired: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: BlocBuilder(
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
                              selectedModel = TypeModel(
                                id: typesBloc.list[value].id,
                                name: typesBloc.list[value].name,
                                bookingType: typesBloc.list[value].bookingType,
                              );
                              //bloc.deliveryId = deliveryBloc.list[value].id;
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 14.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () => navigateTo(StaticPageView(id: 3, title: LocaleKeys.privacyPolicy.tr())),
                              child: Text(LocaleKeys.privacyPolicy.tr())),
                          Checkbox(
                            activeColor: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: .08),
                              fillColor: WidgetStateProperty. resolveWith<Color>((Set<WidgetState> states) {
                                if (states. contains(WidgetState. disabled)) {
                                  return Colors. transparent;
                                }
                                return Colors. transparent;
                              }),
                            checkColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            side: WidgetStateBorderSide.resolveWith(
                              (states) => BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),

                            value: isAccept,
                            onChanged: (value) {
                              isAccept = !isAccept;
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    BlocConsumer(
                      bloc: bloc,
                      listener: (context, state) {
                        if (state is SignupSuccessState) {
                          navigateTo(
                            FirstStepSignUpView(typeModel: selectedModel!),
                          );
                        }
                      },
                      builder: (context, state) {
                        return AppButton(
                          text: LocaleKeys.signUp.tr(),
                          padding: EdgeInsets.symmetric(horizontal: 64.w),
                          isLoading: state is SignupLoadingState,
                          onPress: () {
                            if (bloc.formKey.currentState!.validate()) {
                              if (isAccept) {
                                bloc.add(SignupEvent());
                              } else {
                                showMessage(
                                  LocaleKeys.mustAcceptWithName.tr(
                                    namedArgs: {
                                      'name': LocaleKeys.privacyPolicy,
                                    },

                                  ),
                                  type: MessageType.warning
                                );
                              }
                            } else {
                              bloc.validateMode =
                                  AutovalidateMode.onUserInteraction;
                              setState(() {});
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(height: 32.h),
                    WithSection(isLogin: false),
                    // SizedBox(height: 32.h),
                    // SocialSignInButtons(
                    //   isGoogleLoading:
                    //       state is SocialLoginLoadingState &&
                    //       socialLoginBloc.isGoogle,
                    //   isAppleLoading:
                    //       state is SocialLoginLoadingState &&
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
                    SizedBox(height: 40.h),
                    HaveAccountSection(isLogin: false),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
