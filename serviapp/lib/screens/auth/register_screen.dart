import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserType _selectedType = UserType.client;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await context.read<AuthProvider>().register(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          phone: _phoneController.text,
          userType: _selectedType,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.status == AuthStatus.authenticating;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _nameController,
                  label: 'Nombre completo',
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      Validators.requiredField(value, fieldName: 'Nombre'),
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _phoneController,
                  label: 'Teléfono',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      Validators.requiredField(value, fieldName: 'Teléfono'),
                  prefixIcon: Icons.phone_outlined,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: Validators.password,
                  prefixIcon: Icons.lock_outline,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<UserType>(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de usuario',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedType,
                  onChanged: isLoading
                      ? null
                      : (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedType = value;
                          });
                        },
                  items: const [
                    DropdownMenuItem(
                      value: UserType.client,
                      child: Text('Cliente'),
                    ),
                    DropdownMenuItem(
                      value: UserType.professional,
                      child: Text('Profesional'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (authProvider.errorMessage != null)
                  Text(
                    authProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                if (authProvider.errorMessage != null)
                  const SizedBox(height: 12),
                PrimaryButton(
                  label: 'Registrarme',
                  onPressed: isLoading ? null : () => _handleSubmit(),
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
