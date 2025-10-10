import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/core/design/app_empty.dart';
import 'package:glovana_provider/core/design/app_failed.dart';
import 'package:glovana_provider/core/design/app_image.dart';
import 'package:glovana_provider/core/design/app_loading.dart';
import 'package:glovana_provider/core/logic/helper_methods.dart';
import 'package:glovana_provider/features/ratings/bloc.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:kiwi/kiwi.dart';

class RatingsView extends StatefulWidget {
  const RatingsView({super.key});

  @override
  State<RatingsView> createState() => _RatingsViewState();
}

class _RatingsViewState extends State<RatingsView> {
  final bloc = KiwiContainer().resolve<GetRatingsBloc>()
    ..add(GetRatingsEvent());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: LocaleKeys.ratings.tr()),
      body: BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          if (state is GetRatingsFailedState) {
            return AppFailed(
              response: state.response,
              onPress: () {
                bloc.add(GetRatingsEvent());
              },
            );
          } else if (state is GetRatingsSuccessState) {
            if(state.list.isEmpty)return AppEmpty(title: LocaleKeys.ratings.tr(),);
            return ListView.separated(
              itemBuilder: (context, index) => _Item(model: state.list[index]),
              separatorBuilder: (context, index) => SizedBox(height: 14.h),
              itemCount: state.list.length,
            );
          }
          return AppLoading();
        },
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final RatingModel model;

  const _Item({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: AppTheme.cardLightColor,
        border: Border.all(color: AppTheme.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(100.r),
                child: AppImage(model.user.photoUrl, height: 40.h, width: 40.h),
              ),
              SizedBox(width: 12.w),
              Text(model.user.name),
              const Spacer(),
              RatingBarIndicator(
                rating: model.rating,
                itemBuilder: (context, index) =>
                    Icon(Icons.star, color: Colors.yellow),
                itemCount: 5,
                itemSize: 20.w,
                direction: Axis.horizontal,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (model.review.isNotEmpty)
            Text(
              model.review,
              style: TextStyle(
                fontSize: 11.sp,
                fontFamily: getFontFamily(FontFamilyType.inter),
                color: AppTheme.hintTextColor,
              ),
            ),
        ],
      ),
    );
  }
}
