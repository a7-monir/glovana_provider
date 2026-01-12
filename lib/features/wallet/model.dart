part of 'bloc.dart';

class WalletModel {
  late final num balance;
  late final WalletTransactions transactions;

  WalletModel.fromJson(Map<String, dynamic> json) {
    balance = json['balance'] ?? 0;
    transactions = WalletTransactions.fromJson(json['transactions'] ?? {});
  }
}

class WalletTransactions {
  late final List<WalletTransaction> list;

  WalletTransactions.fromJson(Map<String, dynamic> json) {
    list =
        List.from(
          json['data'] ?? [],
        ).map((e) => WalletTransaction.fromJson(e)).toList();
  }
}

class WalletTransaction {
  late final int id;
  late final int userId;
  late final int providerId;
  late final int adminId;
  late final num amount;
  late final int typeOfTransaction;
  late final String note;
  late final String createdAt;
  late final String updatedAt;

  WalletTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userId = json['user_id'] ?? 0;
    providerId = json['provider_id'] ?? 0;
    adminId = json['admin_id'] ?? 0;
    amount = json['amount'] ?? 0;
    typeOfTransaction = json['type_of_transaction'] ?? 0;
    note = json['note'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
  }
}
