import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/dio_helper.dart';

part 'events.dart';
part 'model.dart';
part 'states.dart';

class GetPaymentReportBloc extends Bloc<GetPaymentReportEvents, GetPaymentReportStates> {
  final DioHelper _dio;

  GetPaymentReportBloc(this._dio) : super(GetPaymentReportStates()) {
    on<GetPaymentReportEvent>(_getData);
  }

  void _getData(GetPaymentReportEvent event, Emitter<GetPaymentReportStates> emit) async {
    emit(GetPaymentReportLoadingState());
    final response = await _dio.get("provider/appointments/provider/payment-report");
    if (response.isSuccess) {
      final model = PaymentReportData.fromJson(response.data).data;
      emit(GetPaymentReportSuccessState(model: model));
    } else {
      emit(GetPaymentReportFailedState(response: response));
    }
  }
}
