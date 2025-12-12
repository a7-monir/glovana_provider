import 'dart:async';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/core/logic/helper_methods.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:kiwi/kiwi.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/design/app_image.dart';
import '../../../features/send_otp/bloc.dart';
import '../../../features/verify_otp/bloc.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String phone;
  final Function() onSuccess;

  const VerifyOtpScreen({
    super.key,
    required this.phone,
    required this.onSuccess,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  String? currentText;

  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;

  bool startTimer = false;
  int countStarted = 0;
  String otp = "no code";
  final bloc = KiwiContainer().resolve<SendOtpBloc>();
  final verifyOtpBloc = KiwiContainer().resolve<VerifyOtpBloc>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    bloc.add(SendOtpEvent(phone: widget.phone));

    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: bloc,
      listener: (context, state) {
        if (state is SendOtpSuccessState) {
          otp = state.otp;
          log("otp: $otp");
        } else if (state is SendOtpFailedState) {
          showMessage(state.msg);
        }

      },
      builder: (context, state) {
        return Scaffold(
          appBar: SecondAppBar(),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h),
                Center(
                  child: AppImage('logo.png', height: 90.h, width: 90.h),
                ),
                SizedBox(height: 24.h),
                Text(
                  LocaleKeys.enterOtpCode.tr(),

                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "${LocaleKeys.enterOtpSentTo.tr()} ${widget.phone}",
                  // style: AppStyles.black15BoldStyle
                  //     .copyWith(color: const Color(0xff767676)),
                ),
                SizedBox(height: 16.h),
                BlocConsumer(
                  bloc: verifyOtpBloc,
                  listener: (context, state) {
                    if (state is VerifyOtpSuccessState) {
                      Navigator.pop(context);
                      widget.onSuccess();
                    }
                  },
                  builder: (context, state) {
                    return Directionality(
                      textDirection: TextDirection.ltr,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: PinCodeTextField(
                          appContext: context,
                          length: 4,
                          obscureText: false,
                          animationType: AnimationType.fade,
                          cursorColor: AppTheme.primary,
                          keyboardType: TextInputType.number,
                          useHapticFeedback: true,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(13.sp),
                            fieldHeight: 60.sp,
                            fieldWidth: 50.sp,
                            borderWidth: 0.97,
                            errorBorderWidth: 0.97,
                            activeBorderWidth: 0.97,
                            disabledBorderWidth: 0.97,
                            inactiveBorderWidth: 0.97,
                            selectedBorderWidth: 0.97,
                            selectedColor: AppTheme.primary,
                            selectedFillColor: AppTheme.primary.withValues(
                              alpha: 0.07,
                            ),
                            inactiveFillColor: Colors.white,
                            activeFillColor: AppTheme.primary.withValues(
                              alpha: 0.07,
                            ),
                            activeColor: AppTheme.primary,
                            inactiveColor: const Color(0xffDFE2E8),
                          ),
                          animationDuration: const Duration(milliseconds: 10),
                          enableActiveFill: true,
                          autoFocus: true,
                          errorAnimationController: errorController,
                          controller: verifyOtpBloc.codeController,
                          onCompleted: (v) {
                            verifyOtpBloc.add(VerifyOtpEvent(otp: otp));
                          },
                          onChanged: (value) {
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            return true;
                          },
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 44.h),
                countStarted >= 2
                    ? Text(
                        LocaleKeys.youCanNotResendRightNow.tr(),
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : const SizedBox.shrink(),
                SizedBox(height: 8.h),
                !startTimer && countStarted < 2
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LocaleKeys.didNotGetCode.tr(),
                            style: TextStyle(color: const Color(0xff767676)),
                          ),
                          SizedBox(width: 4.w),
                          InkWell(
                            onTap: () {
                              setState(() {
                                countStarted += 1;
                                startTimer = true;

                                bloc.add(SendOtpEvent(phone: widget.phone));
                              });
                            },
                            child: Text(
                              LocaleKeys.resend.tr(),
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                startTimer == true && countStarted < 2
                    ? TimerWidget(
                        preText: "${LocaleKeys.canResentCodeAround.tr()} ",
                        afterText: " ${LocaleKeys.minute.tr()}",
                        onTimerFinished: () {
                          setState(() {
                            startTimer = false;
                          });
                        },
                        initialSeconds: countStarted == 1 ? 60 : 180,
                      )
                    : const SizedBox.shrink(),
                SizedBox(height: 20.h),

                state is SendOtpLoadingState
                    // ||
                    // state.verifingOtpStatus ==
                    //     VerifingOtp.loading ||
                    // state.loginStatus == LoginStatus.loading
                    ? Center(
                        child: SizedBox(
                          width: 50.sp,
                          height: 50.sp,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TimerWidget extends StatefulWidget {
  final String preText;
  final String afterText;
  final int initialSeconds;
  final void Function() onTimerFinished;

  const TimerWidget({
    super.key,
    this.preText = "",
    this.afterText = "",
    required this.onTimerFinished,
    required this.initialSeconds,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;

  late int mainSeconds;

  @override
  void initState() {
    super.initState();
    mainSeconds = widget.initialSeconds;
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer if the widget is disposed
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (mainSeconds > 0) {
          mainSeconds--;
        } else {
          stopTimerAndCallback();

          widget.onTimerFinished();
        }
      });
    });
  }

  void stopTimerAndCallback() {
    _timer?.cancel();
    // Callback logic or additional action when countdown finishes
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final int minutes = mainSeconds ~/ 60;
    final int seconds = mainSeconds % 60;
    return Center(
      child: mainSeconds > 0
          ? Text(
              '${widget.preText}${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}${widget.afterText}',
              style: TextStyle(color: Colors.black),
            )
          : const SizedBox.shrink(),
    );
  }
}
