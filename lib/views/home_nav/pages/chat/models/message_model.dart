import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? content;
  String? type;
  String? userType;
  Timestamp? sentAt;
  String? userId;

  String? senderId;
  String? providerId;
  Timestamp? createdAt;
  bool? isReadUser;
  bool? isReadProvider;

  static String? _readString(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') {
      return null;
    }

    return text;
  }

  static Timestamp _readTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value;
    }
    if (value is DateTime) {
      return Timestamp.fromDate(value);
    }
    return Timestamp.fromDate(DateTime.now());
  }

  static bool? _readBool(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }
    return null;
  }

  Message({
    this.content,
    this.type,
    this.userType,
    this.sentAt,
    this.userId,
    this.providerId,
    this.senderId,
    this.createdAt,
    this.isReadUser,
    this.isReadProvider,
  });

  Message.fromJson(Map<String, dynamic> json) {
    content = _readString(json['content']);
    type = _readString(json['type']);
    sentAt = _readTimestamp(json['sent_at']);
    userId = _readString(json['user_id']);
    userType = _readString(json['user_type']);
    providerId = _readString(json['provider_id']);
    senderId = _readString(json['sender_id']);
    createdAt = _readTimestamp(json['created_at']);
    isReadUser = _readBool(json['is_read_user']);
    isReadProvider = _readBool(json['is_read_provider']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['content'] = content;
    data['type'] = type;
    data['user_type'] = userType;
    data['sent_at'] = sentAt;
    data['user_id'] = userId;
    data['provider_id'] = providerId;
    data['created_at'] = createdAt;
    data['is_read_user'] = isReadUser;
    data['is_read_provider'] = isReadProvider;
    data['sender_id'] = senderId;
    return data;
  }
}
