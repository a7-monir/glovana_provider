import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/dio_helper.dart';

part 'events.dart';

part 'model.dart';

part 'states.dart';

class NotificationsBloc extends Bloc<GetNotificationsEvents, GetNotificationsStates> {
  final DioHelper _dio;

  NotificationsBloc(this._dio) : super(GetNotificationsStates()) {
    on<GetNotificationsEvent>(_getData);
  }

  void _getData(GetNotificationsEvent event, Emitter<GetNotificationsStates> emit) async {
    if (event.withLoading) emit(GetNotificationsLoadingState());

    final response = await _dio.get('provider/notifications');
    if (response.isSuccess) {
      final list = NotificationsModel.fromJson(response.data).list;
      emit(GetNotificationsSuccessState(list: list));
    } else {
      emit(GetNotificationsFailedState(response: response));
    }
  }
}
