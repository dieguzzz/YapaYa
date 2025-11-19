import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat_thread.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../chat/chat_room_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ChatProvider>(
      builder: (context, authProvider, chatProvider, _) {
        final user = authProvider.currentUser;

        if (user == null) {
          return const Center(
            child: Text('Inicia sesión para ver tus chats.'),
          );
        }

        if (chatProvider.threads.isEmpty) {
          return const Center(
            child: Text('No tienes conversaciones activas todavía.'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: chatProvider.threads.length,
          itemBuilder: (context, index) {
            final thread = chatProvider.threads[index];
            return Card(
              child: ListTile(
                title: Text('Servicio: ${thread.jobId}'),
                subtitle: Text(
                  thread.lastMessage.isEmpty
                      ? 'Sin mensajes aún'
                      : thread.lastMessage,
                ),
                trailing: Text(
                  _formatTimestamp(thread.lastMessageAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () => _openThread(context, thread),
              ),
            );
          },
        );
      },
    );
  }

  void _openThread(BuildContext context, ChatThread thread) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatRoomScreen(thread: thread),
      ),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    final timeOfDay = TimeOfDay.fromDateTime(dateTime);
    final hour = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'a. m.' : 'p. m.';
    return '$hour:$minute $period';
  }
}
