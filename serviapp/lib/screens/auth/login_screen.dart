import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await context.read<AuthProvider>().signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.status == AuthStatus.authenticating;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'ServiApp',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Conecta clientes con profesionales verificados.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
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
                  const SizedBox(height: 24),
                  if (authProvider.errorMessage != null)
                    Text(
                      authProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (authProvider.errorMessage != null)
                    const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'Ingresar',
                    onPressed: isLoading ? null : () => _handleSubmit(),
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen()),
                            );
                          },
                    child: const Text('Crear una cuenta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
