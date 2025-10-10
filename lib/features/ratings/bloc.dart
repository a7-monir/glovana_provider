import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/dio_helper.dart';

part 'events.dart';
part 'model.dart';
part 'states.dart';

class GetRatingsBloc extends Bloc<GetRatingsEvents, GetRatingsStates> {
  final DioHelper _dio;

  GetRatingsBloc(this._dio) : super(GetRatingsStates()) {
    on<GetRatingsEvent>(_getData);
  }

  void _getData(GetRatingsEvent event, Emitter<GetRatingsStates> emit) async {
    emit(GetRatingsLoadingState());
    final response = await _dio.get("provider/ratings");
    if (response.isSuccess) {
      final list = RatingData.fromJson(response.data).data;
      emit(GetRatingsSuccessState(list: list));
    } else {
      emit(GetRatingsFailedState(response: response));
    }
  }
}
