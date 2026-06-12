import 'package:dio/dio.dart';

import 'app_logger.dart';

class JorMallSmsService {
  Dio dio = Dio();

  // Replace with your credentials
  String accName = 'glovana';
  String accPass = 'hA3mY0hF0o';
  String senderId = 'Glovana'; // registered with JorMall

  Future<String?> generateToken() async {
    try {
      final response = await dio.get(
        'https://www.josms.net/sms/api/GenerateToken.cfm?accname=$accName&accpass=$accPass',
      );

      if (response.statusCode == 200) {
        final data = response.data.toString();
        final lines = data.split('\n');
        for (final line in lines) {
          if (line.trim().startsWith('Bearer ')) {
            AppLogger.info('SMS provider token generated', tag: 'SMS');
            return line
                .trim()
                .substring(7)
                .trim(); // Remove 'Bearer ' and extra spaces
          }
        }
        return "";
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to generate SMS provider token',
        tag: 'SMS',
        error: e,
        stackTrace: stackTrace,
      );
    }

    return null;
  }

  String removeZeroAtIndex3(String number) {
    if (number.length > 3 && number[3] == '0') {
      return number.substring(0, 3) + number.substring(4);
    }
    return number;
  }

  Future<bool> sendOtpSms({
    required String token,
    required String phoneNumber,
    required String otpCode,
  }) async {
    final message = 'Your OTP code is $otpCode';

    //phoneNumber = removeZeroAtIndex3(phoneNumber);

    final url =
        'https://www.josms.net/SMSServices/Clients/Prof/SingleSMS3/SMSService.asmx/SendSMS'
        '?senderid=$senderId&numbers=$phoneNumber&msg=$message';

    try {
      AppLogger.info(
        'Sending OTP SMS',
        tag: 'SMS',
        data: {'phone': phoneNumber},
      );
      final response = await dio.post(
        url,
        data: {
          'senderid': senderId,
          'numbers': phoneNumber,
          'msg': message,
          'id': '${DateTime.now().millisecondsSinceEpoch}',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200) {
        AppLogger.info(
          'SMS provider response received',
          tag: 'SMS',
          data: {'body': response.data.toString()},
        );
        return true;
      } else {
        AppLogger.warning(
          'SMS provider returned non-success status',
          tag: 'SMS',
          data: {'statusCode': response.statusCode},
        );
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to send OTP SMS',
        tag: 'SMS',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
