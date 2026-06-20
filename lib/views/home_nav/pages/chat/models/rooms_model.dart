import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String? id;
  String? userId;
  String? providerId;
  String? userName;
  String? providerName;
  String? userImageUrl;
  String? providerImageUrl;
  String? lastMessage;
  String? lastMessageType;
  String? lastMessageUserId;
  Timestamp? lastMessageDate;
  Timestamp? createdAt;
  bool? isReadUser;
  bool? isReadProvider;
  int unreadCountUser;
  bool isActive;
  int unreadCountProvider; // <-- جديد

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

  static bool _readBool(dynamic value, {required bool fallback}) {
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
    return fallback;
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value.trim()) ?? 0;
    }
    return 0;
  }

  Room({
    this.id,
    this.userId,
    this.providerId,
    this.userName,
    this.providerName,
    this.userImageUrl,
    this.providerImageUrl,
    this.lastMessage,
    this.lastMessageType,
    this.lastMessageUserId,
    this.lastMessageDate,
    this.isReadUser,
    this.isReadProvider,
    this.createdAt,
    this.isActive = true,
    this.unreadCountUser = 0,
    this.unreadCountProvider = 0, // <-- جديد
  });

  Room.fromJson(Map<String, dynamic> json, {String? docId})
    : id = _readString(docId ?? json['id']),
      userId = _readString(json['user_id']),
      providerId = _readString(json['provider_id']),
      userName = _readString(json['user_name']),
      providerName = _readString(json['provider_name']),
      userImageUrl = _readString(json['user_image_url']),
      providerImageUrl = _readString(json['provider_image_url']),
      lastMessage = _readString(json['last_message']),
      lastMessageType = _readString(json['last_message_type']),
      lastMessageUserId = _readString(json['last_message_user_id']),
      lastMessageDate = _readTimestamp(json['last_message_date']),
      createdAt = _readTimestamp(json['created_at']),
      isReadUser = _readBool(json['is_read_user'], fallback: true),
      isReadProvider = _readBool(json['is_read_provider'], fallback: true),
      unreadCountUser = _readInt(json['unread_count_user']),
      isActive = _readBool(json['is_active'], fallback: true),
      unreadCountProvider = _readInt(json['unread_count_provider']);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (userId != null && userId!.isNotEmpty) {
      data['user_id'] = userId;
    }
    if (providerId != null && providerId!.isNotEmpty) {
      data['provider_id'] = providerId;
    }
    if (userName != null && userName!.isNotEmpty) {
      data['user_name'] = userName;
    }
    if (providerName != null && providerName!.isNotEmpty) {
      data['provider_name'] = providerName;
    }
    if (userImageUrl != null && userImageUrl!.isNotEmpty) {
      data['user_image_url'] = userImageUrl;
    }
    if (providerImageUrl != null && providerImageUrl!.isNotEmpty) {
      data['provider_image_url'] = providerImageUrl;
    }
    if (lastMessage != null && lastMessage!.isNotEmpty) {
      data['last_message'] = lastMessage;
    }
    if (lastMessageType != null && lastMessageType!.isNotEmpty) {
      data['last_message_type'] = lastMessageType;
    }
    if (lastMessageUserId != null && lastMessageUserId!.isNotEmpty) {
      data['last_message_user_id'] = lastMessageUserId;
    }

    data['last_message_date'] =
        lastMessageDate ?? Timestamp.fromDate(DateTime.now());
    data['created_at'] = createdAt ?? Timestamp.fromDate(DateTime.now());

    data['is_read_user'] = isReadUser ?? true;
    data['is_read_provider'] = isReadProvider ?? true;
    data['unread_count_user'] = unreadCountUser;
    data['unread_count_provider'] = unreadCountProvider;
    data['is_active'] = isActive;

    return data;
  }
}
