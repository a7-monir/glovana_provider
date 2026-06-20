import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glovana_provider/core/logic/app_logger.dart';

import 'models/message_model.dart';
import 'models/rooms_model.dart';

class ChatUtils {
  static const String messageText = 'text';
  static const String messageImage = 'image';
  static const String messageVideo = 'video';
  static const String messageAudio = 'audio';

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static List<Object> _idVariants(String id) {
    final variants = <Object>[id];
    final parsed = int.tryParse(id);
    if (parsed != null) {
      variants.add(parsed);
    }
    return variants;
  }

  static bool _matchesId(dynamic actual, String expected) {
    return actual?.toString() == expected;
  }

  static int _timestampValue(Timestamp? timestamp) {
    return timestamp?.millisecondsSinceEpoch ?? 0;
  }

  static bool _isTruthy(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }

  static Query<Map<String, dynamic>> _roomsQueryForProvider(String providerId) {
    final variants = _idVariants(providerId);
    final collection = firestore.collection('rooms');
    if (variants.length > 1) {
      return collection.where('provider_id', whereIn: variants);
    }
    return collection.where('provider_id', isEqualTo: providerId);
  }

  static Query<Map<String, dynamic>> _messagesQueryForProvider(
    String providerId,
  ) {
    final variants = _idVariants(providerId);
    final collection = firestore.collection('messages');
    if (variants.length > 1) {
      return collection.where('provider_id', whereIn: variants);
    }
    return collection.where('provider_id', isEqualTo: providerId);
  }

  static QueryDocumentSnapshot<Map<String, dynamic>>? _findRoomDocInSnapshot(
    Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> docs, {
    required String userId,
    required String providerId,
  }) {
    for (final doc in docs) {
      final data = doc.data();
      if (_matchesId(data['user_id'], userId) &&
          _matchesId(data['provider_id'], providerId)) {
        return doc;
      }
    }
    return null;
  }

  static Future<QueryDocumentSnapshot<Map<String, dynamic>>?> _findRoomDoc({
    required String userId,
    required String providerId,
  }) async {
    final snapshot = await _roomsQueryForProvider(providerId).get();
    return _findRoomDocInSnapshot(
      snapshot.docs,
      userId: userId,
      providerId: providerId,
    );
  }

  static Stream<List<Room>> getRooms(
    String providerId, {
    bool onlyActive = false,
  }) {
    return _roomsQueryForProvider(providerId).snapshots().map((snapshot) {
      final rooms = snapshot.docs
          .where((doc) {
            final data = doc.data();
            if (!_matchesId(data['provider_id'], providerId)) {
              return false;
            }
            if (onlyActive && !_isTruthy(data['is_active'])) {
              return false;
            }
            return true;
          })
          .map((doc) => Room.fromJson(doc.data(), docId: doc.id))
          .toList();

      rooms.sort(
        (a, b) => _timestampValue(
          b.lastMessageDate,
        ).compareTo(_timestampValue(a.lastMessageDate)),
      );
      return rooms;
    });
  }

  static Stream<List<Message>> getRoomMessages(
    String userId,
    String providerId,
  ) {
    return _messagesQueryForProvider(providerId).snapshots().map((snapshot) {
      final messages = snapshot.docs
          .where((doc) {
            final data = doc.data();
            return _matchesId(data['provider_id'], providerId) &&
                _matchesId(data['user_id'], userId);
          })
          .map((doc) => Message.fromJson(doc.data()))
          .toList();

      messages.sort(
        (a, b) => _timestampValue(
          a.createdAt,
        ).compareTo(_timestampValue(b.createdAt)),
      );
      return messages;
    });
  }

  static Stream<Room?> streamRoom(String userId, String providerId) {
    return _roomsQueryForProvider(providerId).snapshots().map((snapshot) {
      final roomDoc = _findRoomDocInSnapshot(
        snapshot.docs,
        userId: userId,
        providerId: providerId,
      );
      if (roomDoc == null) {
        return null;
      }
      return Room.fromJson(roomDoc.data(), docId: roomDoc.id);
    });
  }

  /// إضافة أو تحديث روم
  /// إذا كانت موجودة مسبقًا سيتم تحديثها، إذا لا سيتم إنشاؤها
  static Future<Room> addRoom({Room? room}) async {
    if (room == null || room.userId == null || room.providerId == null) {
      throw ArgumentError('Room, userId, and providerId cannot be null');
    }

    String roomId;
    final existingRoomDoc = await _findRoomDoc(
      userId: room.userId!,
      providerId: room.providerId!,
    );

    if (existingRoomDoc != null) {
      roomId = existingRoomDoc.id;
      final updateData = <String, dynamic>{
        if (room.userName != null && room.userName!.isNotEmpty)
          'user_name': room.userName,
        if (room.providerName != null && room.providerName!.isNotEmpty)
          'provider_name': room.providerName,
        if (room.userImageUrl != null && room.userImageUrl!.isNotEmpty)
          'user_image_url': room.userImageUrl,
        if (room.providerImageUrl != null && room.providerImageUrl!.isNotEmpty)
          'provider_image_url': room.providerImageUrl,
        'is_active': room.isActive,
      };

      if (updateData.isNotEmpty) {
        await firestore.collection('rooms').doc(roomId).update(updateData);
      }
    } else {
      final docRef = await firestore.collection('rooms').add(room.toJson());
      roomId = docRef.id;
    }

    final docSnapshot = await firestore.collection('rooms').doc(roomId).get();
    final docData = docSnapshot.data();
    if (!docSnapshot.exists || docData == null) {
      throw Exception('Failed to create/update room');
    }

    return Room.fromJson(docData, docId: docSnapshot.id);
  }

  /// إضافة رسالة (كـ بروفايدر أو يوزر)
  static Future addMessage(Message message, {bool fromProvider = true}) async {
    await firestore.collection('messages').add(message.toJson());

    final roomDoc = await _findRoomDoc(
      userId: message.userId ?? '',
      providerId: message.providerId ?? '',
    );
    if (roomDoc == null) {
      AppLogger.warning(
        'Message saved but room was not found for summary update',
        tag: 'CHAT',
        data: {
          'userId': message.userId,
          'providerId': message.providerId,
          'senderId': message.senderId,
        },
      );
      return;
    }

    await firestore.collection('rooms').doc(roomDoc.id).update({
      'last_message': message.content,
      'last_message_date': message.sentAt,
      'last_message_type': message.type,
      'last_message_user_id': message.senderId,
      'is_read_user': !fromProvider,
      'is_read_provider': fromProvider,
      'unread_count_user': fromProvider
          ? FieldValue.increment(1)
          : FieldValue.increment(0),
      'unread_count_provider': fromProvider
          ? FieldValue.increment(0)
          : FieldValue.increment(1),
      'is_active': true,
    });
  }

  /// تحديد الرسائل كمقروءة للبروفايدر
  static Future<void> markMessagesAsRead({required String roomId}) async {
    try {
      await firestore.collection('rooms').doc(roomId).update({
        'is_read_provider': true,
        'unread_count_provider': 0,
      });
    } catch (e) {
      log('Failed to mark messages as read: $e');
    }
  }

  /// إنهاء الشات (اجعل isActive false)
  static Future<void> endChat({required String roomId}) async {
    try {
      await firestore.collection('rooms').doc(roomId).update({
        'is_active': false,
      });
      log('Room $roomId is now inactive');
    } catch (e) {
      log('Failed to end chat: $e');
    }
  }
}
