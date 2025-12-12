import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class JorMallSmsService {
  Dio dio = Dio();

  JorMallSmsService() {
    dio.interceptors.add(PrettyDioLogger(requestHeader: true));
  }

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
            log(line.trim().substring(7).trim());
            return line
                .trim()
                .substring(7)
                .trim(); // Remove 'Bearer ' and extra spaces
          }
        }
        return "";
      }
    } catch (e) {
      print("Token error: $e");
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
        print('SMS sent: ${response.data}');
        return true;
      } else {
        print('Failed to send SMS: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending SMS: $e');
      return false;
    }
  }
}
