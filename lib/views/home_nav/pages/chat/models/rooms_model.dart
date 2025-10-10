import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
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
  Room(
      {this.userId,
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
      this.createdAt});

  Room.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    providerId = json['provider_id'];
    userName = json['user_name'];
    providerName = json['provider_name'];
    userImageUrl = json['user_image_url'];
    providerImageUrl = json['provider_image_url'];
    lastMessage = json['last_message'];
    lastMessageType = json['last_message_type'];
    lastMessageUserId = json['last_message_user_id'];
    lastMessageDate =
        json['last_message_date'] ?? Timestamp.fromDate(DateTime.now());
    isReadUser = json['is_read_user'];
    isReadProvider = json['is_read_provider'];
    createdAt = json['created_at'] ?? Timestamp.fromDate(DateTime.now());
  }

  Map<String, dynamic> toJson() {
    log("1");
    final Map<String, dynamic> data = <String, dynamic>{};
    log("1");
    if (userId != null && userId != '') {
      data['user_id'] = userId;
      log("3");
    }

    log("4");

    if (providerId != null && providerId != '') {
      log("5");
      data['provider_id'] = providerId;
      log("6");
    }

    if (userName != null && userName != '') {
      data['user_name'] = userName;
    }

    if (providerName != null && providerName != '') {
      data['provider_name'] = providerName;
    }

    if (userImageUrl != null && userImageUrl != '') {
      data['user_image_url'] = userImageUrl;
    }

    if (providerImageUrl != null && providerImageUrl != '') {
      data['provider_image_url'] = providerImageUrl;
    }

    if (lastMessage != null && lastMessage != '') {
      data['last_message'] = lastMessage;
    }

    if (lastMessageType != null && lastMessageType != '') {
      data['last_message_type'] = lastMessageType;
    }
    if (lastMessageUserId != null && lastMessageUserId != '') {
      data['last_message_user_id'] = lastMessageUserId;
    }

    data['last_message_date'] =
        lastMessageDate ?? Timestamp.fromDate(DateTime.now());

    if (isReadUser != null) {
      data['is_read_user'] = isReadUser;
    }

    if (isReadProvider != null) {
      data['is_read_provider'] = isReadProvider;
    }

    data['created_at'] = createdAt ?? Timestamp.fromDate(DateTime.now());

    return data;
  }
}
