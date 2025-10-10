
import 'package:glovana_provider/features/payment_report/bloc.dart';
import 'package:glovana_provider/features/points/get/bloc.dart';
import 'package:glovana_provider/features/ratings/bloc.dart';
import 'package:glovana_provider/features/services/bloc.dart';
import 'package:glovana_provider/features/signup/bloc.dart';
import 'package:glovana_provider/features/static_page/bloc.dart';
import 'package:glovana_provider/features/toggle_lang/bloc.dart';
import 'package:glovana_provider/features/update_status/bloc.dart';
import 'package:glovana_provider/features/wallet/bloc.dart';
import 'package:kiwi/kiwi.dart';

import '../core/logic/dio_helper.dart';
import 'add_address/bloc.dart';
import 'address/bloc.dart';
import 'appointment_details/bloc.dart';
import 'appointments/bloc.dart';

import 'delivery/bloc.dart';
import 'edit_profile/bloc.dart';

import 'google_login/bloc.dart';
import 'login/bloc.dart';
import 'logout/bloc.dart';

void initKiwi() {
  final con = KiwiContainer();
  con.registerSingleton((c) => DioHelper());
  con.registerSingleton((c) => ToggleLangBloc());
  con.registerFactory((c) => LoginBloc(c.resolve<DioHelper>()));
  con.registerFactory((c) => SignupBloc(c.resolve<DioHelper>()));
  con.registerFactory((c) => EditProfileBloc(c.resolve<DioHelper>()));

  con.registerFactory((c) => GetAppointmentsBloc(c.resolve<DioHelper>()));
  con.registerFactory((c) => GetAddressBloc(c.resolve<DioHelper>()));

  con.registerFactory((c) => GetDeliveryBloc(c.resolve<DioHelper>()));
  con.registerFactory((c) => AddAddressBloc(c.resolve<DioHelper>()));

  con.registerFactory((c) => SocialLoginBloc(c.resolve<DioHelper>()));
  con.registerFactory((c) => GetWalletBloc(c.resolve<DioHelper>()));
  con.registerFactory((c) => GetPointsBloc(c.resolve<DioHelper>()));
  con.registerFactory((c) => GetStaticPageBloc(c.resolve<DioHelper>()));
  con.registerFactory((c) => SignOutBloc(c.resolve<DioHelper>()));
  con.registerFactory((c) => GetServicesBloc(c.resolve<DioHelper>()));
  con.registerFactory((c) => GetAppointmentDetailsBloc(c.resolve<DioHelper>()));
  con.registerFactory((c) => UpdateStatusBloc(c.resolve<DioHelper>()));
  con.registerFactory((c) => GetPaymentReportBloc(c.resolve<DioHelper>()));
  con.registerFactory((c) => GetRatingsBloc(c.resolve<DioHelper>()));
}
