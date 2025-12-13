import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/cache_helper.dart';
import '../../../core/logic/dio_helper.dart';

part 'events.dart';

part 'model.dart';

part 'states.dart';


class GetDiscountsBloc extends Bloc<GetDiscountsEvents, GetDiscountsStates> {
  final DioHelper _dio;

  GetDiscountsBloc(this._dio) : super(GetDiscountsStates()) {
    on<GetDiscountsEvent>(_getData);
  }

  void _getData(GetDiscountsEvent event,
      Emitter<GetDiscountsStates> emit,) async {
    emit(GetDiscountsLoadingState());
    final response = await _dio.get("provider/discounts/provider-type/${event.providerTypeId}",
    );
    if (response.isSuccess) {
      final list = DiscountData.fromJson(response.data).data.discounts;
      emit(GetDiscountsSuccessState(list: list));
    } else {
      emit(GetDiscountsFailedState(response: response));
    }
  }
}
