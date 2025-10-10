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

  static Future<Room> addRoom({Room? room}) async {
    if (room == null || room.userId == null || room.providerId == null) {
      throw ArgumentError('Room, userId, and providerId cannot be null');
    }

    // Check if a room already exists with this user-provider combination
    final querySnapshot = await firestore
        .collection('rooms')
        .where('user_id', isEqualTo: room.userId)
        .where('provider_id', isEqualTo: room.providerId)
        .limit(1)
        .get();

    String roomId;
    if (querySnapshot.docs.isNotEmpty) {
      // Room already exists - update it
      roomId = querySnapshot.docs.first.id;
      await firestore.collection('rooms').doc(roomId).update(room.toJson());
    } else {
      // Room doesn't exist - create a new one
      final docRef = await firestore.collection('rooms').add(room.toJson());
      roomId = docRef.id;
    }

    // Fetch the complete room document
    final docSnapshot = await firestore.collection('rooms').doc(roomId).get();

    if (!docSnapshot.exists) {
      throw Exception('Failed to create/update room');
    }

    // Convert document to Room object and return it
    // Assuming you have a fromJson factory method in your Room class
    return Room.fromJson(docSnapshot.data()!);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getRooms(String userId) {
    return firestore
        .collection('rooms')
        .where('provider_id', isEqualTo: userId)
        //  .orderBy('last_message_date', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getRoomMessages(
      String userId, String providerId) {
    return firestore
        .collection('messages')
        .where('provider_id', isEqualTo: providerId)
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: false)
        .snapshots();
  }

  static Future addMessage(Message message) async {
    firestore.collection('messages').add(message.toJson());

    final querySnapshot = await firestore
        .collection('rooms')
        .where('user_id', isEqualTo: message.userId)
        .where('provider_id', isEqualTo: message.providerId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Room already exists - return the existing room ID
      await firestore
          .collection('rooms')
          .doc(querySnapshot.docs.first.id)
          .update(Room(
                  lastMessage: message.content,
                  lastMessageDate: message.sentAt,
                  lastMessageType: message.type,
                  lastMessageUserId: message.userId,
                  isReadUser: true,
                  isReadProvider: false)
              .toJson());
    }
  }
}
