import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/dio_helper.dart';

part 'events.dart';
part 'model.dart';
part 'states.dart';

class GetProviderProfileBloc extends Bloc<GetProviderProfileEvents, GetProviderProfileStates> {
  final DioHelper _dio;

  GetProviderProfileBloc(this._dio) : super(GetProviderProfileStates()) {
    on<GetProviderProfileEvent>(_getData);
  }

  void _getData(GetProviderProfileEvent event, Emitter<GetProviderProfileStates> emit) async {
    emit(GetProviderProfileLoadingState());
    final response = await _dio.get("provider/providerProfile");
    if (response.isSuccess) {
      final model = ProviderProfileData.fromJson(response.data).data.provider;
      emit(GetProviderProfileSuccessState(model: model));
    } else {
      emit(GetProviderProfileFailedState(response: response));
    }
  }
}
