import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import '../../../core/design/app_button.dart';
import '../../../core/logic/helper_methods.dart';
import '../core/design/base_sheet.dart';
import '../features/logout/bloc.dart';
import '../generated/locale_keys.g.dart';
import '../views/auth/login/view.dart';

class LogoutSheet extends StatefulWidget {
  final VoidCallback? onSuccess;

  const LogoutSheet({super.key, this.onSuccess});

  @override
  State<LogoutSheet> createState() => _LogoutSheetState();
}

class _LogoutSheetState extends State<LogoutSheet> {
  final bloc = KiwiContainer().resolve<SignOutBloc>();

  @override
  Widget build(BuildContext context) {
    return BaseSheet(
      title: LocaleKeys.logout.tr(),
      isTitleRed: true,
      isBigTitle: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.areYouSureYouWantLogout.tr(),
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(height: 32.h),
          Row(
            children: [
              Expanded(
                child: BlocConsumer(
                  bloc: bloc,
                  listener: (context, state) {
                    if (state is SignOutSuccessState) {
                      navigateTo(LoginView(), keepHistory: false);
                    }
                  },
                  builder:
                      (context, state) => AppButton(
                        text: LocaleKeys.yesLogout.tr(),
                        isLoading: state is SignOutLoadingState,
                        type: ButtonType.outlined,
                        onPress: () => bloc.add(SignOutEvent()),
                      ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppButton(
                  text: LocaleKeys.cancel.tr(),
                  onPress: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
