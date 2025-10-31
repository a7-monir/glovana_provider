import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/select_item.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../generated/locale_keys.g.dart';
import '../app_theme.dart';
import '../logic/helper_methods.dart';
import 'app_button.dart';


class AppAlert {
  static AppAlert get init => AppAlert._();

  AppAlert._();

  Future imagePickerDialog(
      {required Function(File file) onSubmit, bool withCrop = false}) async {
    FocusScope.of(navigatorKey.currentContext!).unfocus();
    final pick = ImagePicker();
    return showCupertinoModalPopup(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return CupertinoActionSheet(
              cancelButton: CupertinoButton(
                child: Text(LocaleKeys.cancel.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700
                    )),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                CupertinoButton(
                  child: Row(
                    children: <Widget>[
                      Icon(CupertinoIcons.photo_camera_solid,
                          color: AppTheme.primary),
                      const SizedBox(width: 20),
                      Text(LocaleKeys.camera.tr(),
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700
                          )),
                    ],
                  ),
                  onPressed: () async {
                    XFile? pickedFile = await pick.pickImage(
                      requestFullMetadata: false,
                        source: ImageSource.camera, maxWidth: 400);

                    late File rotatedImage;

                    if (pickedFile != null) {
                      rotatedImage = await FlutterExifRotation.rotateImage(
                          path: pickedFile.path);

                      pickedFile = XFile(rotatedImage.path);
                    }

                    if (withCrop == true && pickedFile != null) {
                      CroppedFile filePicked = CroppedFile(pickedFile.path);
                      ImageCropper cropper = ImageCropper();
                      filePicked = (await cropper.cropImage(
                        sourcePath: pickedFile.path,
                        // aspectRatioPresets: [CropAspectRatioPreset.square],
                        uiSettings: [
                          AndroidUiSettings(
                            toolbarTitle: 'Cropper',
                            toolbarWidgetColor: Colors.white,
                            toolbarColor: AppTheme.primary,
                            hideBottomControls: true,
                            initAspectRatio: CropAspectRatioPreset.original,
                          ),
                          IOSUiSettings(minimumAspectRatio: 1.0)
                        ],
                      ))!;
                      pickedFile = XFile(filePicked.path);
                    }
                    if (pickedFile != null) {
                      Navigator.pop(navigatorKey.currentContext!);
                      onSubmit(File(pickedFile.path));
                    }
                  },
                ),
                CupertinoButton(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.insert_photo, color: AppTheme.primary),
                        const SizedBox(width: 20),
                        Text(LocaleKeys.gallery.tr(),
                            style: TextStyle(),)
                      ],
                    ),
                    onPressed: () async {
                      XFile? pickedFile = await pick.pickImage(
                        requestFullMetadata: false,
                          source: ImageSource.gallery, maxWidth: 400);

                      late File rotatedImage;

                      if (pickedFile != null) {
                        rotatedImage = await FlutterExifRotation.rotateImage(
                            path: pickedFile.path);

                        pickedFile = XFile(rotatedImage.path);
                      }

                      if (withCrop == true && pickedFile != null) {
                        CroppedFile filePicked = CroppedFile(pickedFile.path);
                        ImageCropper cropper = ImageCropper();
                        filePicked = (await cropper.cropImage(
                          sourcePath: pickedFile.path,

                          uiSettings: [
                            AndroidUiSettings(
                              toolbarTitle: 'Cropper',
                              toolbarWidgetColor: Colors.white,
                              toolbarColor: AppTheme.primary,
                              hideBottomControls: true,
                              initAspectRatio: CropAspectRatioPreset.original,
                            ),
                            IOSUiSettings(minimumAspectRatio: 1.0)
                          ],
                        ))!;
                        pickedFile = XFile(filePicked.path);
                      }
                      if (pickedFile != null) {
                        Navigator.pop(navigatorKey.currentContext!);
                        onSubmit(File(pickedFile.path));
                      }
                    })
              ]);
        });
  }

  Future<dynamic> selectionOptions(
      {required dynamic item,
        required List<dynamic> items,
        required Function(dynamic item) onSelect,
        required String title,
        List<Widget>? startIcon}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    dynamic selecteItem = item;
    Timer? timer;
    String? search;
    return showCupertinoModalPopup(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return BottomSheet(
              enableDrag: false,
              shape: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(15.h)),
                  borderSide: BorderSide.none),
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, setState) {
                  return Container(
                      width: MediaQuery.of(context).size.width ,
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 200.h),
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      decoration: BoxDecoration(
                        //     color: context.theme.colorScheme.secondaryContainer,
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15.h)),
                      ),
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding:  EdgeInsets.symmetric(  horizontal: 20.w).copyWith(top: 44.h, bottom: 10.h,),
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width ,
                                    constraints:
                                    BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
                                    child: ListView(
                                        padding: EdgeInsets.only(top: 10.h),
                                        shrinkWrap: true,
                                        children: [
                                          ...List.generate(items.length, (index) {
                                            return SelectionItem(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  if (items[index] != item) {
                                                    onSelect(items[index]);
                                                  }
                                                },
                                                isSelect:
                                                items[index] == selecteItem,
                                                startWidget: startIcon?[index],
                                                title: items[index].name ?? "");
                                          }),
                                          const SizedBox(height: 30),
                                        ]))
                              ])));
                });
              },
              onClosing: () {});
        });
  }

  Future optionalSheet(
      String title,
      String firstTextBtn,
      void Function()? firstTapBtn,
      String secTextBtn,
      void Function()? secTapBtn,
      {Widget? subtitle}) async {
    FocusScope.of(navigatorKey.currentContext!).unfocus();
    return showCupertinoModalPopup(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return BottomSheet(
              enableDrag: false,
              shape: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(15.h)),
                  borderSide: BorderSide.none),
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, setState) {
                  return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, ),
                        SizedBox(height: 20.h),
                        subtitle ?? const SizedBox.shrink(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .4,
                                  child: AppButton(text: firstTextBtn, onPress: firstTapBtn,)),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .4,
                                  child: AppButton(text:secTextBtn, onPress:secTapBtn))
                            ])
                      ]);
                });
              },
              onClosing: () {});
        });
  }

  Future<void> customActionAlert(
      {required BuildContext context,
        required String title,
        required Widget child}) {
    return showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return BottomSheet(
              enableDrag: false,
              shape: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(15.h)),
                  borderSide: BorderSide.none),
              builder: (context) {
                return Container(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height - 350.h, minHeight: 100.h),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                    ),
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 20),
                                    Text(title),
                                    InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child:
                                        const Icon(Icons.close_sharp, size: 20))
                                  ]),
                              const Divider(height: 0),
                              child
                            ])));
              },
              onClosing: () {});
        });
  }

  Future optinalSheet(
      String title,
      String firstTextBtn,
      void Function()? firstTapBtn,
      String secTextBtn,
      void Function()? secTapBtn,
      {Widget? subtitle}) async {
    FocusScope.of(navigatorKey.currentContext!).unfocus();
    return showCupertinoModalPopup(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return BottomSheet(
              enableDrag: false,
              shape: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(15.h)),
                  borderSide: BorderSide.none),
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, setState) {
                  return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,),
                        SizedBox(height: 20.h),
                        subtitle ?? const SizedBox.shrink(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .4,
                                  child: AppButton(text: firstTextBtn,onPress:  firstTapBtn)),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .4,
                                  child: AppButton(text: secTextBtn,onPress:  secTapBtn)),
                            ])
                      ]);
                });
              },
              onClosing: () {});
        });
  }
}