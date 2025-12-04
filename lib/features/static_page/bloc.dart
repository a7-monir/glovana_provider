import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/dio_helper.dart';

part 'events.dart';
part 'model.dart';
part 'states.dart';

class GetStaticPageBloc extends Bloc<GetStaticPageEvents, GetStaticPageStates> {
  final DioHelper _dio;

  GetStaticPageBloc(this._dio) : super(GetStaticPageStates()) {
    on<GetStaticPageEvent>(_getData);
  }

  void _getData(
    GetStaticPageEvent event,
    Emitter<GetStaticPageStates> emit,
  ) async {
    emit(GetStaticPageLoadingState());
    final response = await _dio.get("user/pages/${event.id}");
    if (response.isSuccess) {
      final model =response.data['data']!=null? PageData.fromJson(response.data['data']):null;
      emit(GetStaticPageSuccessState(model: model));
    } else {
      emit(GetStaticPageFailedState(response: response));
    }
  }
}
