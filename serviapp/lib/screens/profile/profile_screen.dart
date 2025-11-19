import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/professional_profile.dart';
import '../../models/app_user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/professional_provider.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cedulaController = TextEditingController();
  final _professionsController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _serviceAreasController = TextEditingController();
  final _referencesController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profile = context.watch<ProfessionalProvider>().profile;
    if (profile != null && _cedulaController.text.isEmpty) {
      _cedulaController.text = profile.cedula;
      _professionsController.text = profile.professions.join(', ');
      _descriptionController.text = profile.description;
      _serviceAreasController.text = profile.serviceAreas.join(', ');
      _referencesController.text = profile.references.join(', ');
    }
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _professionsController.dispose();
    _descriptionController.dispose();
    _serviceAreasController.dispose();
    _referencesController.dispose();
    super.dispose();
  }

  List<String> _splitInput(String value) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  Future<void> _handleSave(ProfessionalProvider provider) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await provider.saveProfile(
      cedula: _cedulaController.text.trim(),
      references: _splitInput(_referencesController.text),
      professions: _splitInput(_professionsController.text),
      description: _descriptionController.text.trim(),
      serviceAreas: _splitInput(_serviceAreasController.text),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil profesional enviado para revisión'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final professionalProvider = context.watch<ProfessionalProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _UserInfoCard(user: authProvider.currentUser),
        const SizedBox(height: 24),
        Text(
          'Perfil profesional',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Text(
          'Comparte tu información para que el equipo pueda verificarla y activar tu perfil.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _cedulaController,
                label: 'Cédula',
                validator: (value) =>
                    Validators.requiredField(value, fieldName: 'Cédula'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _professionsController,
                label: 'Oficios (separados por coma)',
                validator: (value) =>
                    Validators.requiredField(value, fieldName: 'Oficios'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    Validators.requiredField(value, fieldName: 'Descripción'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _serviceAreasController,
                label: 'Zonas de cobertura (separadas por coma)',
                validator: (value) =>
                    Validators.requiredField(value, fieldName: 'Zonas'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _referencesController,
                label: 'Referencias (al menos 2, separadas por coma)',
                validator: (value) {
                  final message =
                      Validators.requiredField(value, fieldName: 'Referencias');
                  if (message != null) return message;
                  final count = _splitInput(value ?? '').length;
                  if (count < 2) {
                    return 'Debes ingresar al menos 2 referencias';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (professionalProvider.errorMessage != null)
                Text(
                  professionalProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              if (professionalProvider.errorMessage != null)
                const SizedBox(height: 12),
              PrimaryButton(
                label: 'Guardar y enviar',
                isLoading: professionalProvider.isSaving,
                onPressed: professionalProvider.isSaving
                    ? null
                    : () => _handleSave(professionalProvider),
              ),
              const SizedBox(height: 16),
              if (professionalProvider.profile != null)
                _VerificationInfo(profile: professionalProvider.profile!),
            ],
          ),
        ),
      ],
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  const _UserInfoCard({required this.user});

  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Inicia sesión para ver tu información.'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Información básica',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Nombre: ${user!.name}'),
            Text('Email: ${user!.email}'),
            Text(
                'Teléfono: ${user!.phone.isEmpty ? 'No registrado' : user!.phone}'),
            Text('Tipo: ${user!.userType.name}'),
          ],
        ),
      ),
    );
  }
}

class _VerificationInfo extends StatelessWidget {
  const _VerificationInfo({required this.profile});

  final ProfessionalProfile profile;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (profile.verificationStatus) {
      case VerificationStatus.verified:
        statusColor = Colors.green;
        break;
      case VerificationStatus.rejected:
        statusColor = Colors.red;
        break;
      case VerificationStatus.pending:
      default:
        statusColor = Colors.orange;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.verified, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Estado de verificación: ${profile.verificationStatus.name}',
                  style: TextStyle(color: statusColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Rating: ${profile.rating.toStringAsFixed(1)}'),
            Text('Reviews: ${profile.reviewCount}'),
            const SizedBox(height: 8),
            Text('Oficios: ${profile.professions.join(', ')}'),
            Text('Cobertura: ${profile.serviceAreas.join(', ')}'),
            Text('Referencias: ${profile.references.join(', ')}'),
          ],
        ),
      ),
    );
  }
}
