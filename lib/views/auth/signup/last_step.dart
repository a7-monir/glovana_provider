import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_image.dart';
import 'package:glovana_provider/core/design/base_sheet.dart';
import 'package:glovana_provider/core/logic/helper_methods.dart';
import 'package:glovana_provider/views/auth/signup/second_step.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiwi/kiwi.dart';

import '../../../core/app_theme.dart';
import '../../../core/design/app_bar.dart';
import '../../../core/design/app_button.dart';
import '../../../core/logic/cache_helper.dart';
import '../../../features/complete_data/bloc.dart';
import '../../../generated/locale_keys.g.dart';
import '../done_complete_profile.dart';

class LastStepSingUpView extends StatefulWidget {
  final SecondStepModel secondStepModel;
  final bool isSalon;

  const LastStepSingUpView({super.key, required this.secondStepModel, required this.isSalon});

  @override
  State<LastStepSingUpView> createState() => _LastStepSingUpViewState();
}

class _LastStepSingUpViewState extends State<LastStepSingUpView> {
  final ImagePicker _picker = ImagePicker();
  final bloc = KiwiContainer().resolve<CompleteDataBloc>();
  File? _images;

  final List<File> _gallery = [];

  File? _identityPhoto;
  File? _practicePhoto;

  Future<void> _pickImages() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _images = File(pickedFile.path);
        });
      }
    } catch (e) {
      showMessage('failed_to_pick_images');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final pickedFile = await _picker.pickMultiImage(
        requestFullMetadata:  false,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      setState(() {
        _gallery.addAll(pickedFile.map((file) => File(file.path)).toList());
      });
        } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("failed_to_take_photo".tr())));
    }
  }

  // New method to pick identity photo
  Future<void> _pickIdentityPhoto() async {
    try {
      final pickedFile = await _picker.pickImage(
        requestFullMetadata: false,
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _identityPhoto = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick identity photo".tr())),
      );
    }
  }

  Future<void> _takeIdentityPhoto() async {
    try {
      final pickedFile = await _picker.pickImage(
        requestFullMetadata: false,
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _identityPhoto = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to take identity photo".tr())),
      );
    }
  }

  // New method to pick practice license
  Future<void> _pickPracticePhoto() async {
    try {
      final pickedFile = await _picker.pickImage(
        requestFullMetadata:  false,
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _practicePhoto = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick practice license".tr())),
      );
    }
  }

  Future<void> _takePracticePhoto() async {
    try {
      final pickedFile = await _picker.pickImage(
        requestFullMetadata: false,
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _practicePhoto = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick practice license".tr())),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    print("!!!!!!!!!!!${widget.secondStepModel.pricePerHour}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: '${LocaleKeys.hi.tr()} ${CacheHelper.name}',
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 65.sp,
                    height: 8.sp,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.33),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
        
                  Container(
                    width: 65.sp,
                    height: 8.sp,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.33),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  Container(
                    width: 65.sp,
                    height: 8.sp,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Text(
                LocaleKeys.addProfilePicture.tr(),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(width: 150.w, child: Divider(height: 2)),
              SizedBox(height: 2.h),
              Text(
                LocaleKeys.youCanChooseOnlyPhoto.tr(),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: _pickImages,
                child: _images == null
                    ? Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xffF2F2F2),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: AppImage(
                              'image.png',
                              height: 166.h,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.only(
                                bottomStart: Radius.circular(15.r),
                                bottomEnd: Radius.circular(15.r),
                              ),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              boxShadow: [AppTheme.mainShadow],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.uploadFile.tr(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                AppImage('add.png', height: 22.h, width: 22.h),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ItemImage(
                        image: _images!.path,
                        onRemove: () {
                          _images = null;
                          setState(() {});
                        },
                      ),
              ),
              SizedBox(height: 20.h),
              Text(
                LocaleKeys.galleryPhotos.tr(),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(width: 60.w, child: Divider(height: 2)),
              SizedBox(height: 2.h),
              Text(
                LocaleKeys.youCanUploadYourWorkingPlace.tr(),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 20.h),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ItemPick(onTap: _takePhoto),
                    if (_gallery.isNotEmpty)
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 20.w),
                        child: AllImagesItem(
                          imageList: _gallery.map((e) => e.path).toList(),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => StatefulBuilder(
                                builder: (context, setState2) => BaseSheet(
                                  title: '',
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: List.generate(
                                        _gallery.length,
                                        (index) => Padding(
                                          padding: EdgeInsets.only(bottom: 12.h),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadiusGeometry.circular(
                                                      15.r,
                                                    ),
                                                child: AppImage(
                                                  _gallery[index].path,
                                                  height: 150.h,
                                                  width: MediaQuery.of(
                                                    context,
                                                  ).size.width,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                top: 4,
                                                right: 4,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    _gallery.removeAt(index);
                                                    if (_gallery.isEmpty) {
                                                      Navigator.pop(context);
                                                    }
                                                    setState(() {});
                                                    setState2(() {});
                                                  },
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: AppTheme
                                                              .canvasColor,
                                                          shape: BoxShape.circle,
                                                        ),
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 20.sp,
                                                      color: AppTheme.primary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
        
              SizedBox(height: 20.h),
              Text(
                LocaleKeys.nationalID.tr(),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 10.h),
              if (_identityPhoto != null)
                ItemImage(
                  image: _identityPhoto!.path,
                  onRemove: () {
                    _identityPhoto = null;
                    setState(() {});
                  },
                ),
              if (_identityPhoto == null)
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ItemPick(onTap: _pickIdentityPhoto),
                      SizedBox(width: 20.w),
                      ItemTake(onTap: _takeIdentityPhoto),
                    ],
                  ),
                ),
        
              SizedBox(height: 20.h),
              if(widget.isSalon)...[
                Text(
                  LocaleKeys.commercialRegistration.tr(),
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10.h),
                if (_practicePhoto != null)
                  ItemImage(
                    image: _practicePhoto!.path,
                    onRemove: () {
                      _practicePhoto = null;
                      setState(() {});
                    },
                  ),
                if (_practicePhoto == null)
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ItemPick(onTap: _pickPracticePhoto),
                        SizedBox(width: 20.w),
                        ItemTake(onTap: _takePracticePhoto),
                      ],
                    ),
                  ),
              ],
        
        
              BlocConsumer(
                bloc: bloc,
                listener: (context, state) {
                  if (state is CompleteDataSuccessState) {
                    navigateTo(DoneCompleteProfileView(), keepHistory: false);
                  }
                },
                builder: (context, state) {
                  return Center(
                    child: AppButton(
                      text: LocaleKeys.submit.tr(),
                      type: ButtonType.outlined,
                      bgColor: Color(0xffFDF2E3),
                      textColor: Color(0xffCBA976),
                      padding: EdgeInsets.only(bottom: 40.h,top: 20.h),
                      isLoading: state is CompleteDataLoadingState,
                      onPress: () {
                        final availabilityData =
                            (widget.secondStepModel.availability)
                                .map(
                                  (a) => Availability(
                                    dayOfWeek: a['day_of_week'],
                                    startTime: a['start_time'],
                                    endTime: a['end_time'],
                                  ),
                                )
                                .toList();
        
                        // Create ProviderType object
                        final providerType = ProviderType(
                          typeId: widget.secondStepModel.firstStepModel.typeId,
                          name: widget.secondStepModel.firstStepModel.nickName,
                          bookingType: widget.secondStepModel.firstStepModel.bookingType,
                          // widget.signUpData['nickName'],
                          workNumber: widget.secondStepModel.workNumber,
                          description:
                              widget.secondStepModel.firstStepModel.description,
                          // widget.signUpData['description'],
                          lat: widget.secondStepModel.firstStepModel.lat,
                          //widget.signUpData['lat']?.toDouble() ?? 0.0,
                          lng: widget.secondStepModel.firstStepModel.lng,
                          //widget.signUpData['lng']?.toDouble() ?? 0.0,
                          address: widget
                              .secondStepModel
                              .firstStepModel
                              .addressFromPicker,
                          // widget.signUpData['address'],
                          pricePerHour:
                              widget.secondStepModel.firstStepModel.bookingType ==
                                  "hourly"
                              ? widget.secondStepModel.pricePerHour
                              : 0.0,
                          servicesWithPrices:
                              widget.secondStepModel.firstStepModel.bookingType ==
                                  "service"
                              ? List<Map<String, dynamic>>.from(
                                  widget.secondStepModel.serviceWithPrice,
                                )
                              : null,
                          serviceIds:
                              widget.secondStepModel.firstStepModel.bookingType ==
                                  "hourly"
                              ? List<int>.from(widget.secondStepModel.service)
                              : List<int>.from(widget.secondStepModel.service),
                          images: _images,
                          gallery: _gallery,
                          availability: availabilityData,
                          // Add new document fields
                          identityPhoto: _identityPhoto,
                          practicePhoto: _practicePhoto,
                        );
        
                         bloc.add(CompleteDataEvent(providerTypes: [providerType]));
                        // if (bloc.formKey.currentState!.validate() &&
                        //     (bloc.lat != null || bloc.lng != null)) {
                        //   bloc.add(AddAddressEvent());
                        // } else {
                        //   bloc.validateMode = AutovalidateMode.onUserInteraction;
                        //   setState(() {});
                        // }
                      },
                    ),
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

class ItemPick extends StatelessWidget {
  final VoidCallback onTap;

  const ItemPick({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              vertical: 12.h,
            ).copyWith(start: 15.w, end: 10.w),
            decoration: BoxDecoration(
              boxShadow: [AppTheme.mainShadow],
              shape: BoxShape.circle,
              color: AppTheme.canvasColor,
            ),
            child: AppImage('file.png', height: 48.h, width: 48.h),
          ),
          SizedBox(height: 8.h),
          Text(LocaleKeys.uploadFile.tr()),
        ],
      ),
    );
  }
}

class ItemTake extends StatelessWidget {
  final VoidCallback onTap;

  const ItemTake({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(12.r),
            decoration: BoxDecoration(
              boxShadow: [AppTheme.mainShadow],
              shape: BoxShape.circle,
              color: AppTheme.canvasColor,
            ),
            child: AppImage('camera.png', height: 48.h, width: 48.h),
          ),
          SizedBox(height: 8.h),
          Text(LocaleKeys.takePhotos.tr()),
        ],
      ),
    );
  }
}

class AllImagesItem extends StatelessWidget {
  final List<String> imageList;
  final VoidCallback onTap;

  const AllImagesItem({
    super.key,
    required this.imageList,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        decoration: BoxDecoration(
          color: AppTheme.canvasColor,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [AppTheme.mainShadow],
        ),
        child: Column(
          children: [
            Text('${imageList.length} ${LocaleKeys.photosAreSaved.tr()}'),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 2.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: AppTheme.primary,
              ),
              child: Text(
                LocaleKeys.view.tr(),
                style: TextStyle(color: AppTheme.canvasColor, fontSize: 11.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemImage extends StatelessWidget {
  final String image;
  final bool withBaseImageUrl;
  final VoidCallback onRemove;

  const ItemImage({super.key, required this.image, required this.onRemove,  this.withBaseImageUrl=false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(15.r),
          child: AppImage(
            image,
            withBaseImageUrl:withBaseImageUrl ,
            height: 160.h,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        Positioned(
          top: 4.h,
          right: 4.w,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.canvasColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 20.sp, color: AppTheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}
