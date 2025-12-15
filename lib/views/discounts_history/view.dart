import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:glovana_provider/core/design/app_bar.dart';
import 'package:glovana_provider/core/design/app_failed.dart';
import 'package:glovana_provider/core/design/app_loading.dart';
import 'package:glovana_provider/core/logic/helper_methods.dart';
import 'package:glovana_provider/features/delete_discount/bloc.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:kiwi/kiwi.dart';

import '../../core/design/app_empty.dart';
import '../../features/get_discount/bloc.dart';

class DiscountsHistoryView extends StatefulWidget {
  final int providerId;

  const DiscountsHistoryView({super.key, required this.providerId});

  @override
  State<DiscountsHistoryView> createState() => _DiscountsHistoryViewState();
}

class _DiscountsHistoryViewState extends State<DiscountsHistoryView> {
  final bloc = KiwiContainer().resolve<GetDiscountsBloc>();
  //795970357


  @override
  void initState() {
    super.initState();
    bloc.add(GetDiscountsEvent(providerTypeId: widget.providerId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondAppBar(title: LocaleKeys.discounts.tr()),
      body: SafeArea(
        child: BlocBuilder(
          bloc: bloc,
          builder: (context, state) {
            if (state is GetDiscountsFailedState) {
              return AppFailed(
                onPress: () => bloc.add(
                  GetDiscountsEvent(providerTypeId: widget.providerId),
                ),
              );
            } else if (state is GetDiscountsSuccessState) {
              if (state.list.isEmpty) {
                return AppEmpty(title: LocaleKeys.discounts.tr());
              }
              return ListView.separated(
                padding: EdgeInsets.all(14.r),
                itemBuilder: (context, index) =>
                    _Item(model: state.list[index],
                    onSuccess: () {
                      bloc.add(GetDiscountsEvent(providerTypeId: widget.providerId));
                    },),
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemCount: state.list.length,
              );
            }
            return AppLoading();
          },
        ),
      ),
    );
  }
}

class _Item extends StatefulWidget {
  final Discounts model;
  final VoidCallback onSuccess;

  const _Item({super.key, required this.model, required this.onSuccess});

  @override
  State<_Item> createState() => _ItemState();
}

class _ItemState extends State<_Item> {
  final bloc = KiwiContainer().resolve<DeleteDiscountBloc>();

  int selectedId=0;
  @override
  void initState() {
    super.initState();
    selectedId=widget.model.id;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.primary),
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
                    Text(widget.model.name, style: TextStyle(fontSize: 16.sp)),
                    Text(
                      widget.model.description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: getFontFamily(FontFamilyType.inter),
                        color: AppTheme.hintTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text("${widget.model.percentage} %"),
              SizedBox(width: 2.w),
              BlocConsumer<DeleteDiscountBloc, DeleteDiscountStates>(
                bloc: bloc,
                buildWhen: (previous, current) =>
                current is DeleteDiscountLoadingState ||
                    current is DeleteDiscountFailedState ||
                    current is DeleteDiscountSuccessState,

                listener: (context, deleteState) {
                  if (deleteState is DeleteDiscountSuccessState) {
                    print("111111");
                    widget.onSuccess(); // ✅ هتشتغل
                  }
                },

                builder: (context, deleteState) {
                  if (deleteState is DeleteDiscountLoadingState) {
                    return SizedBox(
                      height: 12.h,
                      width: 12.h,
                      child: AppLoading(),
                    );
                  }

                  return GestureDetector(
                    onTap: () {
                      bloc.add(DeleteDiscountEvent(id: widget.model.id));
                    },
                    child: const Icon(Icons.delete, color: Colors.red),
                  );
                },
              ),
            ],
          ),
          Text(
            '${LocaleKeys.from.tr()}: ${DateFormat("dd MMM y").format(DateTime.parse(widget.model.startDate))}, ${LocaleKeys.to.tr()}: ${DateFormat("dd MMM y").format(DateTime.parse(widget.model.endDate))}',
          ),
          SizedBox(height: 8.h),
          Wrap(
            children: List.generate(
              widget.model.services.length,
              (index) => Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.r),
                  color: AppTheme.secondaryHeaderColor,
                ),
                child: Text(widget.model.services[index].name),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
