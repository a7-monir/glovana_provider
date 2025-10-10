import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/cache_helper.dart';
import '../../../core/logic/dio_helper.dart';
import '../address/bloc.dart';
import '../provider_profile/bloc.dart';

part 'events.dart';

part 'model.dart';

part 'states.dart';

class GetServicesBloc extends Bloc<GetServicesEvents, GetServicesStates> {
  final DioHelper _dio;

  GetServicesBloc(this._dio) : super(GetServicesStates()) {
    on<GetServicesEvent>(_getData);
  }
  List<Service2> list=[];
  void _getData(GetServicesEvent event,
      Emitter<GetServicesStates> emit,) async {
    emit(GetServicesLoadingState());
    final response = await _dio.get("user/getServices");
    if (response.isSuccess) {
       list =List.from(response.data['data'] ?? []).map((e) => Service2.fromJson(e)).toList();
      emit(GetServicesSuccessState(list: list));
    } else {
      emit(GetServicesFailedState(response: response));
    }
  }
}
