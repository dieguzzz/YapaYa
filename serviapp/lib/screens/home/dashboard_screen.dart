import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/job_request.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final jobProvider = context.watch<JobProvider>();
    final user = authProvider.currentUser;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Hola ${user?.name ?? ''}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Revisa el estado de tus servicios publicados y completa tu perfil profesional.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        if (user != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Usuario',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Nombre: ${user.name}'),
                  Text('Email: ${user.email}'),
                  Text(
                      'Teléfono: ${user.phone.isEmpty ? 'No registrado' : user.phone}'),
                  Text('Tipo: ${user.userType.name}'),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          'Mis trabajos',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (jobProvider.myJobs.isEmpty)
          const Text(
              'Aún no has publicado trabajos. Usa la pestaña "Publicar".')
        else
          ...jobProvider.myJobs.map(
            (job) => _JobTile(job: job),
          ),
      ],
    );
  }
}

class _JobTile extends StatelessWidget {
  const _JobTile({required this.job});

  final JobRequest job;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(job.title),
        subtitle: Text(
          '${job.category} • ${job.locationName}\nEstado: ${job.status.name}',
        ),
        isThreeLine: true,
        trailing: Text(
          job.budget != null
              ? '\$${job.budget!.toStringAsFixed(2)}'
              : 'Sin presupuesto',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
