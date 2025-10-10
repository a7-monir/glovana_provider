import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/dio_helper.dart';

part 'events.dart';
part 'model.dart';
part 'states.dart';

class GetPointsBloc extends Bloc<GetPointsEvents, GetPointsStates> {
  final DioHelper _dio;

  GetPointsBloc(this._dio) : super(GetPointsStates()) {
    on<GetPointsEvent>(_getData);
  }

  void _getData(GetPointsEvent event, Emitter<GetPointsStates> emit) async {
    emit(GetPointsLoadingState());
    final response = await _dio.get("user/points");
    if (response.isSuccess) {
      final model = PointsModel.fromJson(response.data['data']);
      emit(GetPointsSuccessState(model: model));
    } else {
      emit(GetPointsFailedState(response: response));
    }
  }
}
