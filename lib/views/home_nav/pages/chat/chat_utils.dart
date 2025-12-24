import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/app_theme.dart';
import '../../../../core/logic/cache_helper.dart';
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
      // روم موجودة مسبقًا → تحديثها
      roomId = querySnapshot.docs.first.id;
      await firestore.collection('rooms').doc(roomId).update(room.toJson());
    } else {
      // روم جديدة → إنشاءها
      final docRef = await firestore.collection('rooms').add(room.toJson());
      roomId = docRef.id;
    }

    final docSnapshot = await firestore.collection('rooms').doc(roomId).get();
    if (!docSnapshot.exists) {
      throw Exception('Failed to create/update room');
    }

    return Room.fromJson(docSnapshot.data()!, docId: docSnapshot.id);
  }

  /// جلب كل الرومات للبروفايدر
  /// يمكن فلترتهم حسب isActive لو عايز تظهر الرومات النشطة فقط
  static Stream<QuerySnapshot<Map<String, dynamic>>> getRooms(String providerId, {bool onlyActive = false}) {
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

    if (querySnapshot.docs.isNotEmpty) {
      final docRef = firestore.collection('rooms').doc(querySnapshot.docs.first.id);

      if (fromProvider) {
        // انت البروفايدر → الرسائل غير مقروءة عند اليوزر
        await docRef.update({
          'last_message': message.content,
          'last_message_date': message.sentAt,
          'last_message_type': message.type,
          'last_message_user_id': message.userId,
          'is_read_user': false,
          'unread_count_user': FieldValue.increment(1),
          'is_active': true, // أي رسالة جديدة تجعل الشات نشط
        });
      } else {
        // من اليوزر → الرسائل غير مقروءة عند البروفايدر
        await docRef.update({
          'last_message': message.content,
          'last_message_date': message.sentAt,
          'last_message_type': message.type,
          'last_message_user_id': message.userId,
          'is_read_provider': false,
          'unread_count_provider': FieldValue.increment(1),
          'is_active': true, // أي رسالة جديدة تجعل الشات نشط
        });
      }
    }
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