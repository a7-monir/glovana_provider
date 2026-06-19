import 'package:kiwi/kiwi.dart';

import 'cache_helper.dart';
import 'dio_helper.dart';

class ProviderAccountStatusResult {
  final bool isSuccess;
  final int activate;
  final String? errorMessage;

  const ProviderAccountStatusResult({
    required this.isSuccess,
    required this.activate,
    this.errorMessage,
  });

  bool get needsApproval => ProviderAccountStatusHelper.needsApproval(activate);

  bool get isActive => !needsApproval;
}

class ProviderAccountStatusHelper {
  static bool needsApproval(int activate) => activate == 2 || activate == 3;

  static Future<ProviderAccountStatusResult> refresh() async {
    if (!CacheHelper.isAuthed) {
      return const ProviderAccountStatusResult(isSuccess: false, activate: 0);
    }

    final response = await KiwiContainer().resolve<DioHelper>().get(
      'provider/providerProfile',
    );

    if (!response.isSuccess) {
      return ProviderAccountStatusResult(
        isSuccess: false,
        activate: CacheHelper.activate,
        errorMessage: response.msg,
      );
    }

    final responseData = response.data;
    final data =
        responseData is Map && responseData['data'] is Map
            ? responseData['data'] as Map
            : null;
    final provider = data?['provider'];

    final activate = _parseActivate(
      provider is Map ? provider['activate'] : null,
    );

    await CacheHelper.setActivate(activate);

    return ProviderAccountStatusResult(isSuccess: true, activate: activate);
  }

  static int _parseActivate(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? CacheHelper.activate;
    }

    return CacheHelper.activate;
  }
}
