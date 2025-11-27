import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/core/design/app_image.dart';
import 'package:glovana_provider/core/design/main_gradient_item.dart';
import 'package:glovana_provider/core/logic/cache_helper.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:glovana_provider/sheets/delete_account/view.dart';
import 'package:kiwi/kiwi.dart';

import '../../features/provider_profile/bloc.dart';
import '../../features/provider_update_status/bloc.dart';
import '../../features/toggle_lang/bloc.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String selectedLang = CacheHelper.lang;

  final langBloc = KiwiContainer().resolve<ToggleLangBloc>();


  final List<String> list = ['en', 'ar'];
  final List<String> textList = [
    LocaleKeys.english.tr(),
    LocaleKeys.arabic.tr(),
  ];


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainGradientItem(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: MainAppBar(title: LocaleKeys.settings.tr()),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
            ).copyWith(top: 60.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.language.tr(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTapDown: (TapDownDetails details) async {
                    final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject()
                    as RenderBox;
                    await showMenu(
                      context: context,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      menuPadding: EdgeInsets.zero,
                      constraints: BoxConstraints(maxWidth: 200.w),
                      position: RelativeRect.fromRect(
                        details.globalPosition & Size(0.h, 0.h),
                        Offset.zero & overlay.size,
                      ),
                      items: [
                        ...List.generate(
                          list.length,
                              (index) => PopupMenuItem(
                            height: 40.h,
                            value: list[index],
                            padding: EdgeInsets.zero,
                            onTap: selectedLang != list[index]
                                ? () {
                              selectedLang = list[index];
                              langBloc.add(
                                ToggleLangEvent(selectedLang),
                              );
                              setState(() {});
                            }
                                : null,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: selectedLang == list[index]
                                    ? AppTheme.containerColor
                                    : null,
                                borderRadius: selectedLang == list[index]
                                    ? BorderRadius.circular(10.r)
                                    : null,
                                boxShadow: [
                                  if (selectedLang == list[index])
                                    AppTheme.mainShadow,
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    textList[index],
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  Icon(
                                    selectedLang == list[index]
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_off,
                                    size: 16.h,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: AppTheme.cardLightColor,
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [AppTheme.mainShadow, AppTheme.whiteShadow],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          CacheHelper.lang == 'en'
                              ? LocaleKeys.english.tr()
                              : LocaleKeys.arabic.tr(),
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        AppImage('arrow_down.png', height: 24.h, width: 24.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                GestureDetector(
                  onTap: () => showModalBottomSheet(context: context,
                    isScrollControlled: true,
                    builder: (context) => DeleteAccountSheet(),),
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                        color: AppTheme.canvasColor,
                        borderRadius: BorderRadius.circular(30.r),
                        boxShadow: [
                          AppTheme.mainShadow,
                          AppTheme.whiteShadow,
                        ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocaleKeys.submitDeactivationRequest.tr(),
                          style: TextStyle(

                          ),
                        ),

                        Icon(Icons.delete,color: Colors.red,size: 20.r,)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

      ],
    );
  }
}

class BuildToggleButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const BuildToggleButton({
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            if (isActive)
              BoxShadow(
                offset: Offset(0, -4),
                blurRadius: 20.r,
                color: Colors.white.withValues(alpha: .72),
                blurStyle: BlurStyle.inner,
              ),
          ],
          color: isActive
              ? Theme.of(context).primaryColor
              : Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive
                ? Theme.of(context).secondaryHeaderColor
                : Theme.of(context).primaryColor.withValues(alpha: .4),
          ),
        ),
      ),
    );
  }
}
