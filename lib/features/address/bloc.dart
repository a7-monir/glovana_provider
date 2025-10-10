import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/cache_helper.dart';
import '../../../core/logic/dio_helper.dart';

part 'events.dart';

part 'model.dart';

part 'states.dart';

class GetAddressBloc extends Bloc<GetAddressEvents, GetAddressStates> {
  final DioHelper _dio;

  GetAddressBloc(this._dio) : super(GetAddressStates()) {
    on<GetAddressEvent>(_getData);
  }

  void _getData(GetAddressEvent event,
      Emitter<GetAddressStates> emit,) async {
    emit(GetAddressLoadingState());
    final response = await _dio.get("user/addresses");
    if (response.isSuccess) {
      final list=AddressData.fromJson(response.data).list;
      emit(GetAddressSuccessState(list: list));
    } else {
      emit(GetAddressFailedState(response: response));
    }
  }
}
