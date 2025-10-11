
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_input.dart';
import 'package:glovana_provider/core/design/system_padding.dart';
import 'package:glovana_provider/core/logic/input_validator.dart';
import 'package:kiwi/kiwi.dart';

import '../../../core/design/app_button.dart';
import '../../core/design/base_sheet.dart';
import '../../generated/locale_keys.g.dart';
import 'bloc/bloc.dart';

class DeleteAccountSheet extends StatefulWidget {
  const DeleteAccountSheet({super.key});

  @override
  State<DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<DeleteAccountSheet> {
  final bloc = KiwiContainer().resolve<DeleteAccountBloc>();
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SystemPadding(
      child: BaseSheet(
        title: LocaleKeys.deleteAccount.tr(),
        isTitleRed: true,
        isBigTitle: true,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: validateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LocaleKeys.areYouSureYouWantDeleteAccount.tr(),
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 10.h),
                AppInput(
                  fixedPositionedLabel: LocaleKeys.reason.tr(),
                  controller: bloc.reason,
                  isValid: false,
                  withShadow: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: AppTheme.primary)
                  ),
                  validator: (v) =>InputValidator.requiredValidator(value: v!, itemName: LocaleKeys.reason.tr()) ,
                  maxLines: 3,),
                SizedBox(height: 32.h),
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder(
                          bloc: bloc,
                          builder: (context, state) {
                            return AppButton(
                              text: LocaleKeys.yesDelete.tr(),
                              type: ButtonType.outlined,
                              isLoading: state is DeleteAccountLoadingState,
                              onPress: () {
                                if(formKey.currentState!.validate()){
                                  bloc.add(DeleteAccountEvent());
                                }else {
                                  validateMode=AutovalidateMode.onUserInteraction;
                                  setState(() {});
                                }
                
                              },
                            );
                          }),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppButton(
                        text: LocaleKeys.cancel.tr(),
                        isSecondary: false,
                        onPress: () => Navigator.pop(context),
                      ),
                    ),
                
                
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
