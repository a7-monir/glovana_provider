import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/core/design/app_failed.dart';
import 'package:glovana_provider/core/design/app_loading.dart';
import 'package:glovana_provider/core/logic/helper_methods.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:kiwi/kiwi.dart';

import '../../features/get_discount/bloc.dart';

class DiscountsHistoryView extends StatefulWidget {
  final int providerId;
  const DiscountsHistoryView({super.key, required this.providerId});

  @override
  State<DiscountsHistoryView> createState() => _DiscountsHistoryViewState();
}


class _DiscountsHistoryViewState extends State<DiscountsHistoryView> {
  final bloc = KiwiContainer().resolve<GetDiscountsBloc>();
  @override
  void initState() {
    super.initState();
    bloc.add(GetDiscountsEvent(providerTypeId: widget.providerId));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondAppBar(
        title: LocaleKeys.discounts.tr(),
      ),
      body: BlocBuilder(
        bloc: bloc,
  builder: (context, state) {
          if(state is GetDiscountsFailedState){
            return AppFailed(onPress: () =>   bloc.add(GetDiscountsEvent(providerTypeId: widget.providerId)));
          }else if (state is GetDiscountsSuccessState){
            return ListView.separated(itemBuilder: (context, index) => _Item(model: state.list[index]), separatorBuilder: (context, index) => SizedBox(height: 12.h,), itemCount: state.list.length);
          }
          return AppLoading();

  },
),
    );
  }
}
class _Item extends StatelessWidget {
  final Discounts model;
  const _Item({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.primary,
        ),
        borderRadius: BorderRadius.circular(12.r),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.name,style: TextStyle(
                      fontSize: 16.sp,
                    ),),
                    Text(model.description,style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: getFontFamily(FontFamilyType.inter),
                      color: AppTheme.hintTextColor,
                    ),),
                  ],
                ),
              ),
              Text("${model.percentage}%"),

            ],
          ),
          SizedBox(height: 8.h,),
          Wrap(children: List.generate(model.services.length, (index) => Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.r),
            color: AppTheme.secondaryHeaderColor,
          ),
            child: Text(model.services[index].name),

          ),),)
        ],
      ),
    );
  }
}

