import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authProvider.signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido${user != null ? ', ${user.name}' : ''}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            if (user != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tipo de usuario: ${user.userType.name}'),
                      const SizedBox(height: 8),
                      Text('Email: ${user.email}'),
                      const SizedBox(height: 8),
                      Text(
                          'Teléfono: ${user.phone.isEmpty ? 'No configurado' : user.phone}'),
                    ],
                  ),
                ),
              ),
            const Spacer(),
            Text(
              'Aquí irá el resto de la experiencia del MVP (matching, chat, pagos, etc.).',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
