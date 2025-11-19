import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';
import '../models/chat_thread.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider({ChatService? chatService})
      : _chatService = chatService ?? ChatService();

  final ChatService _chatService;

  StreamSubscription<List<ChatThread>>? _threadsSubscription;
  StreamSubscription<List<ChatMessage>>? _messagesSubscription;

  List<ChatThread> _threads = [];
  List<ChatMessage> _currentMessages = [];
  ChatThread? _currentThread;
  String? _userId;
  bool _isSending = false;
  String? _errorMessage;

  List<ChatThread> get threads => _threads;
  List<ChatMessage> get currentMessages => _currentMessages;
  ChatThread? get currentThread => _currentThread;
  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;

  void attachUser(String? userId) {
    if (_userId == userId) return;
    _userId = userId;
    _threads = [];
    _currentMessages = [];
    _currentThread = null;
    _threadsSubscription?.cancel();
    _messagesSubscription?.cancel();

    if (userId == null) {
      notifyListeners();
      return;
    }

    _threadsSubscription =
        _chatService.watchThreadsForUser(userId).listen((threads) {
      _threads = threads;
      notifyListeners();
    });
  }

  Future<ChatThread> startThread({
    required String jobId,
    required List<String> participants,
  }) async {
    final thread = await _chatService.getOrCreateThread(
      jobId: jobId,
      participants: participants,
    );
    _listenToThread(thread);
    return thread;
  }

  void openThread(ChatThread thread) {
    _listenToThread(thread);
  }

  Future<void> sendMessage(String text) async {
    if (_currentThread == null || _userId == null) {
      throw Exception('No hay un chat activo.');
    }

    _isSending = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _chatService.sendMessage(
        chatId: _currentThread!.id,
        senderId: _userId!,
        text: text,
      );
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  void _listenToThread(ChatThread thread) {
    _currentThread = thread;
    _messagesSubscription?.cancel();
    _messagesSubscription = _chatService.watchMessages(thread.id).listen(
      (messages) {
        _currentMessages = messages;
        notifyListeners();
        if (_userId != null) {
          _chatService.markMessagesAsRead(chatId: thread.id, userId: _userId!);
        }
      },
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _threadsSubscription?.cancel();
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
