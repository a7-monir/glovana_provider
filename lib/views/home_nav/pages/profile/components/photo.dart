import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/design/app_image.dart';
import '../../../../../core/design/image_picker.dart';
import '../../../../../core/logic/cache_helper.dart';
import '../../../../../core/logic/helper_methods.dart';
import '../../../../edit_profile/view.dart';

class ItemPhoto extends StatefulWidget {
  final bool canEdit;

  final Function(String)?onChange;

  const ItemPhoto({super.key,  this.canEdit=false,  this.onChange,});

  @override
  State<ItemPhoto> createState() => _ItemPhotoState();
}

class _ItemPhotoState extends State<ItemPhoto> {
   String?photoUrl;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        if(widget.canEdit){
          AppAlert.init.imagePickerDialog(onSubmit: (file) {
            if(widget.onChange!=null){
              photoUrl=file.path;
              widget.onChange!(file.path);
              setState(() {

              });
            }

          },);
        }else{
          navigateTo(EditProfileView());
        }

      },
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            height: 190.h,
            width: 190.h,
            margin: EdgeInsets.only(top: 25.h),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.w),
            ),
            child: ClipOval(
              child: AppImage(
                photoUrl?? CacheHelper.photo,
                height: 190.h,
                width: 190.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
              border: Border.all(color: Colors.white, width: 2.w),
            ),

            child: ClipOval(
              child: AppImage(
                'pen.png',
                height: 15.h,
                width: 15.h,
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
