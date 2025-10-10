import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/cache_helper.dart';
import '../../../core/logic/dio_helper.dart';
import '../address/bloc.dart';

part 'events.dart';

part 'model.dart';

part 'states.dart';

class GetDeliveryBloc extends Bloc<GetDeliveryEvents, GetDeliveryStates> {
  final DioHelper _dio;

  GetDeliveryBloc(this._dio) : super(GetDeliveryStates()) {
    on<GetDeliveryEvent>(_getData);
  }
  List<Delivery> list=[];
  void _getData(GetDeliveryEvent event,
      Emitter<GetDeliveryStates> emit,) async {
    emit(GetDeliveryLoadingState());
    final response = await _dio.get("user/deliveries");
    if (response.isSuccess) {
       list =List.from(response.data['data'] ?? []).map((e) => Delivery.fromJson(e)).toList();
      emit(GetDeliverySuccessState(list: list));
    } else {
      emit(GetDeliveryFailedState(response: response));
    }
  }
}
