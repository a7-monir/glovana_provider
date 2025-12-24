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
      : id = docId ?? json['id'],
        userId = json['user_id'],
        providerId = json['provider_id'],
        userName = json['user_name'],
        providerName = json['provider_name'],
        userImageUrl = json['user_image_url'],
        providerImageUrl = json['provider_image_url'],
        lastMessage = json['last_message'],
        lastMessageType = json['last_message_type'],
        lastMessageUserId = json['last_message_user_id'],
        lastMessageDate = json['last_message_date'] ?? Timestamp.fromDate(DateTime.now()),
        createdAt = json['created_at'] ?? Timestamp.fromDate(DateTime.now()),
        isReadUser = json['is_read_user'],
        isReadProvider = json['is_read_provider'],
        unreadCountUser = json['unread_count_user'] ?? 0,
        isActive = json['is_active'] ?? true,
        unreadCountProvider = json['unread_count_provider'] ?? 0;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (userId != null && userId!.isNotEmpty) data['user_id'] = userId;
    if (providerId != null && providerId!.isNotEmpty) data['provider_id'] = providerId;
    if (userName != null && userName!.isNotEmpty) data['user_name'] = userName;
    if (providerName != null && providerName!.isNotEmpty) data['provider_name'] = providerName;
    if (userImageUrl != null && userImageUrl!.isNotEmpty) data['user_image_url'] = userImageUrl;
    if (providerImageUrl != null && providerImageUrl!.isNotEmpty) data['provider_image_url'] = providerImageUrl;
    if (lastMessage != null && lastMessage!.isNotEmpty) data['last_message'] = lastMessage;
    if (lastMessageType != null && lastMessageType!.isNotEmpty) data['last_message_type'] = lastMessageType;
    if (lastMessageUserId != null && lastMessageUserId!.isNotEmpty) {
      data['last_message_user_id'] = lastMessageUserId;
    }

    data['last_message_date'] =
        lastMessageDate ?? Timestamp.fromDate(DateTime.now());
    data['created_at'] =
        createdAt ?? Timestamp.fromDate(DateTime.now());

    data['is_read_user'] = isReadUser ?? true;
    data['is_read_provider'] = isReadProvider ?? true;
    data['unread_count_user'] = unreadCountUser;
    data['unread_count_provider'] = unreadCountProvider;
    data['is_active'] = isActive;

    return data;
  }
}