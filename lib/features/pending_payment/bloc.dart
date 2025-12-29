import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/logic/dio_helper.dart';
import '../appointments/bloc.dart';

part 'events.dart';


part 'states.dart';

class GetPendingPaymentBloc extends Bloc<GetPendingPaymentEvents, GetPendingPaymentStates> {
  final DioHelper _dio;

  GetPendingPaymentBloc(this._dio) : super(GetPendingPaymentStates()) {
    on<GetPendingPaymentEvent>(_getData);
  }


  void _getData(GetPendingPaymentEvent event,
      Emitter<GetPendingPaymentStates> emit,) async {
    emit(GetPendingPaymentLoadingState());
    final response = await _dio.get("provider/pending-payment-confirmation",

    );
    if (response.isSuccess) {
      final list = List.from(response.data['data']['appointments']).map((e) => Appointment.fromJson(e)).toList();
      emit(GetPendingPaymentSuccessState(list: list));
    } else {
      emit(GetPendingPaymentFailedState(response: response));
    }
  }
}
