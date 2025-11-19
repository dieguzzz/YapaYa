import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_message.dart';
import '../models/chat_thread.dart';
import 'firestore_paths.dart';

class ChatService {
  ChatService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _threads =>
      _firestore.collection(FirestorePath.chats);
  CollectionReference<Map<String, dynamic>> get _messages =>
      _firestore.collection(FirestorePath.messages);

  Future<ChatThread> getOrCreateThread({
    required String jobId,
    required List<String> participants,
  }) async {
    final normalizedParticipants = [...participants]..sort();
    final existing = await _threads.where('jobId', isEqualTo: jobId).get();
    for (final doc in existing.docs) {
      final threadParticipants =
          List<String>.from(doc['participants'] ?? const [])..sort();
      if (_listsEqual(threadParticipants, normalizedParticipants)) {
        return ChatThread.fromDoc(doc);
      }
    }

    final docRef = _threads.doc();
    final thread = ChatThread(
      id: docRef.id,
      jobId: jobId,
      participants: normalizedParticipants,
      lastMessage: 'Nuevo chat creado',
    );
    await docRef.set(thread.toMap());
    return thread;
  }

  Stream<List<ChatThread>> watchThreadsForUser(String userId) {
    return _threads
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(ChatThread.fromDoc).toList());
  }

  Stream<List<ChatMessage>> watchMessages(String chatId) {
    return _messages
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(ChatMessage.fromDoc).toList());
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    if (text.trim().isEmpty) {
      throw Exception('El mensaje no puede estar vacío.');
    }

    final docRef = _messages.doc();
    final message = ChatMessage(
      id: docRef.id,
      chatId: chatId,
      senderId: senderId,
      text: text.trim(),
      readBy: [senderId],
    );

    await _firestore.runTransaction((transaction) async {
      final threadRef = _threads.doc(chatId);
      transaction.set(docRef, message.toMap());
      transaction.update(threadRef, {
        'lastMessage': message.text,
        'lastMessageAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> markMessagesAsRead({
    required String chatId,
    required String userId,
  }) async {
    final unreadQuery =
        await _messages.where('chatId', isEqualTo: chatId).get();

    final batch = _firestore.batch();
    for (final doc in unreadQuery.docs.where((doc) {
      final readBy = List<String>.from(doc['readBy'] ?? const []);
      return !readBy.contains(userId);
    })) {
      final readBy = List<String>.from(doc['readBy'] ?? const [])..add(userId);
      batch.update(doc.reference, {'readBy': readBy});
    }
    await batch.commit();
  }

  bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
