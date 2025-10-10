import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/dio_helper.dart';

part 'events.dart';
part 'model.dart';
part 'states.dart';

class GetWalletBloc extends Bloc<GetWalletEvents, GetWalletStates> {
  final DioHelper _dio;

  GetWalletBloc(this._dio) : super(GetWalletStates()) {
    on<GetWalletEvent>(_getData);
  }

  void _getData(GetWalletEvent event, Emitter<GetWalletStates> emit) async {
    emit(GetWalletLoadingState());
    final response = await _dio.get("provider/wallet/transactions");
    if (response.isSuccess) {
      final model = WalletModel.fromJson(response.data['data']);
      emit(GetWalletSuccessState(model: model));
    } else {
      emit(GetWalletFailedState(response: response));
    }
  }
}
