import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/dio_helper.dart';

part 'events.dart';

part 'model.dart';

part 'states.dart';

class TypesBloc extends Bloc<GetTypesEvents, GetTypesStates> {
  final DioHelper _dio;

  TypesBloc(this._dio) : super(GetTypesStates()) {
    on<GetTypesEvent>(_getData);
  }
List<TypeModel> list=[];
  void _getData(GetTypesEvent event, Emitter<GetTypesStates> emit) async {
    if (event.withLoading) emit(GetTypesLoadingState());

    final response = await _dio.get('user/getTypes');
    if (response.isSuccess) {
       list = TypeData.fromJson(response.data).list;
      emit(GetTypesSuccessState(list: list));
    } else {
      emit(GetTypesFailedState(response: response));
    }
  }
}
