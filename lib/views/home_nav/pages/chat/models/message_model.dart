import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? content;
  String? type,userType;
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
    type = json['user_type'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['type'] = this.type;
    data['user_type'] = this.userType;
    data['sent_at'] = this.sentAt;
    data['user_id'] = this.userId;
    data['provider_id'] = this.providerId;
    data['created_at'] = this.createdAt;
    data['is_read_user'] = this.isReadUser;
    data['is_read_provider'] = this.isReadProvider;
    data['sender_id'] = this.senderId;
    return data;
  }
}
