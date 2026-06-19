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
    content = json['content'];
    type = json['type'];
    sentAt = json['sent_at'] ?? Timestamp.fromDate(DateTime.now());
    userId = json['user_id'];
    userType = json['user_type'];
    providerId = json['provider_id'];
    senderId = json['sender_id'];
    createdAt = json['created_at'] ?? Timestamp.fromDate(DateTime.now());
    isReadUser = json['is_read_user'];
    isReadProvider = json['is_read_provider'];
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
