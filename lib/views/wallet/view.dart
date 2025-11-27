import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_refresh.dart';
import 'package:kiwi/kiwi.dart';

import '../../core/design/app_bar.dart';
import '../../core/design/app_empty.dart';
import '../../core/design/app_failed.dart';
import '../../core/design/app_loading.dart';
import '../../features/wallet/bloc.dart';
import '../../generated/locale_keys.g.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  final bloc = KiwiContainer().resolve<GetWalletBloc>()..add(GetWalletEvent());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: LocaleKeys.wallet.tr()),
      body: BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          if (state is GetWalletFailedState) {
            return AppFailed(
              response: state.response,
              onPress: () => bloc.add(GetWalletEvent()),
            );
          } else if (state is GetWalletSuccessState) {
            // ✅ هنا نضيف AppRefresh
            return AppRefresh(
              event: () async {
                bloc.add(GetWalletEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(), // ✅ مهم عشان AppRefresh يشتغل
                padding: EdgeInsets.symmetric(horizontal: 20.w)
                    .copyWith(top: 40.h, bottom: 16.h),
                child: Column(
                  children: [
                    Text(
                      LocaleKeys.wallet.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '${state.model.balance}',
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Divider(height: 2.h),
                    SizedBox(height: 20.h),
                    if (state.model.transactions.list.isEmpty) ...[
                      AppEmpty(title: LocaleKeys.transactions.tr()),
                    ] else ...[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.model.transactions.list.length,
                        itemBuilder: (context, index) {
                          final item = state.model.transactions.list[index];
                          final isIncome = item.typeOfTransaction == 1;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                              isIncome ? Colors.green[100] : Colors.red[100],
                              child: Icon(
                                isIncome
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: isIncome ? Colors.green : Colors.red,
                              ),
                            ),
                            title: Text('${item.amount} ${LocaleKeys.jod.tr()}'),
                            subtitle: Text(item.note),
                            trailing: Text(
                              item.createdAt.substring(0, 10),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          }
          return const AppLoading();
        },
      ),
    );
  }
}