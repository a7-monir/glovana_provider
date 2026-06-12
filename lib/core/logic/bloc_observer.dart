import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_logger.dart';
import 'helper_methods.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    AppLogger.debug('${bloc.runtimeType} created', tag: 'BLOC');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    final transition =
        '${change.currentState.runtimeType} -> ${change.nextState.runtimeType}';

    if (change.nextState.runtimeType.toString().contains('Failed')) {
      AppLogger.warning(
        '${bloc.runtimeType} state changed to failure',
        tag: 'BLOC',
        data: {'transition': transition},
      );
    } else {
      AppLogger.debug(
        '${bloc.runtimeType} state changed',
        tag: 'BLOC',
        data: {'transition': transition},
      );
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    AppLogger.error(
      '${bloc.runtimeType} emitted an uncaught error',
      tag: 'BLOC',
      error: error,
      stackTrace: stackTrace,
    );
    showUnexpectedError();
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    AppLogger.debug('${bloc.runtimeType} closed', tag: 'BLOC');
  }
}
