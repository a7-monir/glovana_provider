import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/message_model.dart';
import 'models/rooms_model.dart';

class ChatUtils {
  static const String messageText = 'text';
  static const String messageImage = 'image';
  static const String messageVideo = 'video';
  static const String messageAudio = 'audio';

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// إضافة أو تحديث روم
  /// إذا كانت موجودة مسبقًا سيتم تحديثها، إذا لا سيتم إنشاؤها
  static Future<Room> addRoom({Room? room}) async {
    if (room == null || room.userId == null || room.providerId == null) {
      throw ArgumentError('Room, userId, and providerId cannot be null');
    }

    final querySnapshot = await firestore
        .collection('rooms')
        .where('user_id', isEqualTo: room.userId)
        .where('provider_id', isEqualTo: room.providerId)
        .limit(1)
        .get();

    String roomId;
    if (querySnapshot.docs.isNotEmpty) {
      roomId = querySnapshot.docs.first.id;
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

  /// جلب كل الرومات للبروفايدر
  /// يمكن فلترتهم حسب isActive لو عايز تظهر الرومات النشطة فقط
  static Stream<QuerySnapshot<Map<String, dynamic>>> getRooms(
    String providerId, {
    bool onlyActive = false,
  }) {
    var query = firestore
        .collection('rooms')
        .where('provider_id', isEqualTo: providerId);

    if (onlyActive) {
      query = query.where('is_active', isEqualTo: true);
    }

    return query.snapshots();
  }

  /// جلب رسائل روم محدد
  static Stream<QuerySnapshot<Map<String, dynamic>>> getRoomMessages(
    String userId,
    String providerId,
  ) {
    return firestore
        .collection('messages')
        .where('provider_id', isEqualTo: providerId)
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: false)
        .snapshots();
  }

  /// إضافة رسالة (كـ بروفايدر أو يوزر)
  static Future addMessage(Message message, {bool fromProvider = true}) async {
    await firestore.collection('messages').add(message.toJson());

    final querySnapshot = await firestore
        .collection('rooms')
        .where('user_id', isEqualTo: message.userId)
        .where('provider_id', isEqualTo: message.providerId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return;

    final roomDoc = querySnapshot.docs.first;
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
