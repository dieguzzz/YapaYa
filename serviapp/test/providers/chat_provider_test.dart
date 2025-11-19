import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:serviapp/models/chat_message.dart';
import 'package:serviapp/models/chat_thread.dart';
import 'package:serviapp/providers/chat_provider.dart';
import 'package:serviapp/services/chat_service.dart';

class _MockChatService extends Mock implements ChatService {}

void main() {
  group('ChatProvider', () {
    late ChatProvider provider;
    late _MockChatService chatService;
    late StreamController<List<ChatThread>> threadController;
    late StreamController<List<ChatMessage>> messageController;

    final thread = ChatThread(
      id: 'thread-1',
      jobId: 'job-123',
      participants: const ['client', 'professional'],
    );

    setUp(() {
      chatService = _MockChatService();
      threadController = StreamController<List<ChatThread>>.broadcast();
      messageController = StreamController<List<ChatMessage>>.broadcast();

      when(() => chatService.watchThreadsForUser(any()))
          .thenAnswer((_) => threadController.stream);
      when(() => chatService.watchMessages(any()))
          .thenAnswer((_) => messageController.stream);
      when(() => chatService.markMessagesAsRead(
            chatId: any(named: 'chatId'),
            userId: any(named: 'userId'),
          )).thenAnswer((_) async {});

      provider = ChatProvider(chatService: chatService);
    });

    tearDown(() async {
      await threadController.close();
      await messageController.close();
    });

    test('attachUser listens to thread updates', () async {
      provider.attachUser('client');
      threadController.add([thread]);

      await Future<void>.delayed(Duration.zero);
      expect(provider.threads, hasLength(1));
      expect(provider.threads.first.id, equals('thread-1'));
    });

    test('sendMessage delegates to service and resets loading state', () async {
      provider.attachUser('client');
      provider.openThread(thread);

      when(() => chatService.sendMessage(
            chatId: any(named: 'chatId'),
            senderId: any(named: 'senderId'),
            text: any(named: 'text'),
          )).thenAnswer((_) async {});

      await provider.sendMessage('Hola');

      expect(provider.isSending, isFalse);
      verify(() => chatService.sendMessage(
            chatId: thread.id,
            senderId: 'client',
            text: 'Hola',
          )).called(1);
    });
  });
}
