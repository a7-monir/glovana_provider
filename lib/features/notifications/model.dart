part of 'bloc.dart';

class NotificationsModel {

 late final List<NotificationData> list;


   NotificationsModel.fromJson(Map<String, dynamic> json) {
    list = List.from(json['data'] ?? []).map((e) => NotificationData.fromJson(e)).toList();

  }
}

class NotificationData {
 late final int id;
 late final String title;
 late final String body;
 late final int type;
 late final int? userId;
 late final int? providerId;
 late final String createdAt;
 late final String? updatedAt;



   NotificationData.fromJson(Map<String, dynamic> json) {

      id= json['id'] ?? 0;
      title= json['title'] ?? '';
      body= json['body'] ?? '';
      type= json['type'] ?? 0;
      userId= json['user_id'];
      providerId= json['provider_id'];
      createdAt= DateFormat.yMMMMEEEEd("en")
          .format(DateTime.parse(json['created_at'] ?? ""));
      updatedAt=
          DateFormat.yMMMMEEEEd("en")
              .format(DateTime.parse(json['updated_at'] ?? ""));

  }
}