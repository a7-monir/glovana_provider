part of "bloc.dart";

class PointsModel {
  late final int currentPoints;
  late final PointsTransactions transactions;

  PointsModel.fromJson(Map<String, dynamic> json) {
    currentPoints = json['current_points'] ?? 0;
    transactions = PointsTransactions.fromJson(json['transactions'] ?? {});
  }
}

class PointsTransactions {
  late final List<PointsTransaction> list;

  PointsTransactions.fromJson(Map<String, dynamic> json) {
    list =
        List.from(
          json['data'] ?? [],
        ).map((e) => PointsTransaction.fromJson(e)).toList();
  }
}

class PointsTransaction {
  late final int id;
  late final int userId;
  late final int providerId;
  late final int adminId;
  late final int points;
  late final int typeOfTransaction;
  late final String note;
  late final String createdAt;
  late final String updatedAt;
  late final String transactionTypeLabel;
  late final User user;
  late final dynamic provider;

  PointsTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userId = json['user_id'] ?? 0;
    providerId = json['provider_id'] ?? 0;
    adminId = json['admin_id'] ?? 0;
    points = json['points'] ?? 0;
    typeOfTransaction = json['type_of_transaction'] ?? 0;
    note = json['note'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    transactionTypeLabel = json['transaction_type_label'] ?? '';
    user = User.fromJson(json['user'] ?? {});
    provider = json['provider'];
  }
}

class User {
  late int id;
  late String name;
  late String phone;
  late String photoUrl;

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? '';
    phone = json["phone"] ?? '';
    photoUrl = json["photo_url"] ?? '';
  }
}
