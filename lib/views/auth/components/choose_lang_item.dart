import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';

import '../../../core/app_theme.dart';
import '../../../core/design/app_image.dart';
import '../../../core/logic/cache_helper.dart';
import '../../../features/toggle_lang/bloc.dart';

class ChooseLangItem extends StatefulWidget {
  const ChooseLangItem({super.key});

  @override
  State<ChooseLangItem> createState() => _ChooseLangItemState();
}

class _ChooseLangItemState extends State<ChooseLangItem> {
  String selectedLang = CacheHelper.lang;

  final langBloc = KiwiContainer().resolve<ToggleLangBloc>();

  final List<String> list = ['en', 'ar'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) async {
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
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
                onTap:
                    selectedLang != list[index]
                        ? () {
                          selectedLang = list[index];
                          langBloc.add(ToggleLangEvent(selectedLang));
                          setState(() {});
                        }
                        : null,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  height: 40.h,
                  decoration: BoxDecoration(
                    color:
                        selectedLang == list[index]
                            ? AppTheme.containerColor
                            : null,
                    borderRadius:
                        selectedLang == list[index]
                            ? BorderRadius.circular(10.r)
                            : null,
                    boxShadow: [
                      if (selectedLang == list[index]) AppTheme.mainShadow,
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        list[index],
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
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 17.w, top: 40.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              CacheHelper.lang,
              style: TextStyle(
                fontSize: 14.sp,
                height: 2.h,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).primaryColor,
              ),
            ),
            AppImage(
              'arrow_down.png',
              height: 16.h,
              width: 16.h,
              color: AppTheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
