part of "bloc.dart";

class PageData {
  late final int id;
  late final int type;
  late final String title;
  late final String content;
  late final String createdAt;
  late final String updatedAt;

  PageData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    type = json['type'] ?? 0;
    title = json['title'] ?? '';
    content = json['content'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
  }
}
