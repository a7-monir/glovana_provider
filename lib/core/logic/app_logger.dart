import 'dart:convert';

import 'package:flutter/foundation.dart';

enum AppLogLevel { debug, info, warning, error }

class AppLogger {
  AppLogger._();

  static const _jsonEncoder = JsonEncoder.withIndent('  ');
  static const _hiddenValue = '***';
  static const _hiddenKeys = {
    'authorization',
    'password',
    'token',
    'access_token',
    'refresh_token',
    'fcm_token',
    'otp',
    'accpass',
    'identitytoken',
    'idtoken',
    'accesstoken',
  };

  static void debug(String message, {String tag = 'APP', Object? data}) {
    if (!kDebugMode) {
      return;
    }
    _write(AppLogLevel.debug, tag, message, data: data);
  }

  static void info(String message, {String tag = 'APP', Object? data}) {
    _write(AppLogLevel.info, tag, message, data: data);
  }

  static void warning(String message, {String tag = 'APP', Object? data}) {
    _write(AppLogLevel.warning, tag, message, data: data);
  }

  static void error(
    String message, {
    String tag = 'APP',
    Object? error,
    StackTrace? stackTrace,
    Object? data,
  }) {
    _write(
      AppLogLevel.error,
      tag,
      message,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );
  }

  static dynamic sanitize(dynamic value, {String? key}) {
    final normalizedKey = key?.toLowerCase().trim() ?? '';

    if (_shouldHide(normalizedKey)) {
      return _maskSecret(value);
    }

    if (_looksLikePhoneKey(normalizedKey) && value is String) {
      return _maskPhone(value);
    }

    if (value is Map) {
      return value.map<String, dynamic>((entryKey, entryValue) {
        return MapEntry(
          entryKey.toString(),
          sanitize(entryValue, key: entryKey.toString()),
        );
      });
    }

    if (value is Iterable) {
      return value.map((item) => sanitize(item)).toList(growable: false);
    }

    if (value is String) {
      if (value.startsWith('Bearer ')) {
        return 'Bearer ${_maskSecret(value.substring(7))}';
      }
      return _truncate(value);
    }

    return value;
  }

  static String pretty(dynamic value) {
    final sanitized = sanitize(value);

    if (sanitized == null) {
      return 'null';
    }

    if (sanitized is String) {
      return _truncate(sanitized);
    }

    try {
      return _truncate(_jsonEncoder.convert(sanitized));
    } catch (_) {
      return _truncate(sanitized.toString());
    }
  }

  static String summarizeError(Object error) {
    final message = error.toString().trim();
    if (message.isEmpty) {
      return 'Unknown error';
    }
    return _truncate(message, maxLength: 240);
  }

  static String maskPhone(String value) => _maskPhone(value);

  static void _write(
    AppLogLevel level,
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Object? data,
  }) {
    final buffer = StringBuffer(
      '[${DateTime.now().toIso8601String()}] '
      '[${_label(level)}] '
      '[$tag] '
      '$message',
    );

    if (data != null) {
      buffer.write('\n${pretty(data)}');
    }

    if (error != null) {
      buffer.write('\nError: ${summarizeError(error)}');
    }

    if (stackTrace != null && kDebugMode) {
      final stackLines = stackTrace.toString().trim().split('\n');
      final preview = stackLines.take(6).join('\n');
      if (preview.isNotEmpty) {
        buffer.write('\nStack:\n$preview');
      }
    }

    debugPrint(buffer.toString());
  }

  static bool _shouldHide(String key) {
    if (key.isEmpty) {
      return false;
    }

    return _hiddenKeys.contains(key) ||
        key.contains('otp') ||
        key.endsWith('_token') ||
        key.contains('password');
  }

  static bool _looksLikePhoneKey(String key) {
    return key == 'phone' ||
        key == 'phone_number' ||
        key == 'phonenumber' ||
        key == 'numbers';
  }

  static String _maskSecret(Object? value) {
    final text = value?.toString() ?? '';
    if (text.isEmpty) {
      return _hiddenValue;
    }

    if (text.length <= 4) {
      return _hiddenValue;
    }

    return '***${text.substring(text.length - 4)}';
  }

  static String _maskPhone(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length <= 4) {
      return '***';
    }

    return '${digitsOnly.substring(0, 3)}***${digitsOnly.substring(digitsOnly.length - 2)}';
  }

  static String _truncate(String value, {int maxLength = 700}) {
    if (value.length <= maxLength) {
      return value;
    }

    return '${value.substring(0, maxLength)}...';
  }

  static String _label(AppLogLevel level) {
    switch (level) {
      case AppLogLevel.debug:
        return 'DEBUG';
      case AppLogLevel.info:
        return 'INFO';
      case AppLogLevel.warning:
        return 'WARN';
      case AppLogLevel.error:
        return 'ERROR';
    }
  }
}
