import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/app_constants.dart';
import '../models/chat_message.dart';

class ChatRepository {
  ChatRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> saveConversation({
    required String userId,
    required ChatMessage userMessage,
    required ChatMessage botMessage,
  }) async {
    final now = FieldValue.serverTimestamp();

    await _firestore.collection(AppConstants.chatsCollection).add({
      'userId': userId,
      'createdAt': now,
      'messages': [
        userMessage.toMap(),
        botMessage.toMap(),
      ],
    });
  }
}
