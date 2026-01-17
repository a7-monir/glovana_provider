import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/dio_helper.dart';

part 'events.dart';
part 'model.dart';
part 'states.dart';

class GetSettingsBloc extends Bloc<GetSettingsEvents, GetSettingsStates> {
  final DioHelper _dio;

  GetSettingsBloc(this._dio) : super(GetSettingsStates()) {
    on<GetSettingsEvent>(_getData);
  }

  num minPoints=0;
  num pointsValue=0;
  num whatsAppNumber=0;
  void _getData(GetSettingsEvent event, Emitter<GetSettingsStates> emit) async {
    emit(GetSettingsLoadingState());
    final response = await _dio.get("user/settings");
    if (response.isSuccess) {
      final model = SettingsModel.fromJson(response.data);

      //  getMinPointsValue(SettingsModel model) {
      //   final item = model.data.firstWhere(
      //         (e) => e.key == 'number_of_points_to_convert_to_money',
      //     orElse: () => Data.fromJson({}),
      //   );
      //   return item.value;
      // }
       getWhatsappNumber(SettingsModel model) {
        final item = model.data.firstWhere(
              (e) => e.key == 'whatsapp_number',
          orElse: () => Data.fromJson({}),
        );
        return item.value;
      }
      // getPointsValue(SettingsModel model) {
      //   final item = model.data.firstWhere(
      //         (e) => e.key == 'one_point_equal_money',
      //     orElse: () => Data.fromJson({}),
      //   );
      //   return item.value;
      // }
      // minPoints= getMinPointsValue(model);
      // pointsValue= getPointsValue(model);
      whatsAppNumber= getWhatsappNumber(model);
      print("+++++++++++++++++");
      print(minPoints);
      print(pointsValue);

      emit(GetSettingsSuccessState(model: model));
    } else {
      emit(GetSettingsFailedState(response: response));
    }
  }
}
