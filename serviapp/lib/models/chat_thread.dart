import 'package:cloud_firestore/cloud_firestore.dart';

class ChatThread {
  ChatThread({
    required this.id,
    required this.jobId,
    required this.participants,
    this.lastMessage = '',
    DateTime? lastMessageAt,
    DateTime? createdAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastMessageAt = lastMessageAt ?? DateTime.now();

  final String id;
  final String jobId;
  final List<String> participants;
  final String lastMessage;
  final DateTime createdAt;
  final DateTime lastMessageAt;

  ChatThread copyWith({
    String? lastMessage,
    DateTime? lastMessageAt,
  }) {
    return ChatThread(
      id: id,
      jobId: jobId,
      participants: participants,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }

  factory ChatThread.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ChatThread(
      id: doc.id,
      jobId: data['jobId'] as String? ?? '',
      participants: List<String>.from(data['participants'] ?? const []),
      lastMessage: data['lastMessage'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'participants': participants,
      'lastMessage': lastMessage,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastMessageAt': Timestamp.fromDate(lastMessageAt),
    };
  }
}
