import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/job_provider.dart';
import 'providers/professional_provider.dart';
import 'providers/professional_search_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ServiApp());
}

class ServiApp extends StatelessWidget {
  const ServiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, JobProvider>(
          create: (_) => JobProvider(),
          update: (_, authProvider, jobProvider) {
            final provider = jobProvider ?? JobProvider();
            provider.attachUser(authProvider.currentUser?.id);
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProfessionalProvider>(
          create: (_) => ProfessionalProvider(),
          update: (_, authProvider, professionalProvider) {
            final provider = professionalProvider ?? ProfessionalProvider();
            provider.attachUser(authProvider.currentUser?.id);
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, ChatProvider>(
          create: (_) => ChatProvider(),
          update: (_, authProvider, chatProvider) {
            final provider = chatProvider ?? ChatProvider();
            provider.attachUser(authProvider.currentUser?.id);
            return provider;
          },
        ),
        ChangeNotifierProvider<ProfessionalSearchProvider>(
          create: (_) => ProfessionalSearchProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'ServiApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006B5E)),
          useMaterial3: true,
        ),
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        switch (authProvider.status) {
          case AuthStatus.unknown:
            return const SplashScreen();
          case AuthStatus.authenticating:
            return const SplashScreen();
          case AuthStatus.authenticated:
            return const HomeScreen();
          case AuthStatus.unauthenticated:
            return const LoginScreen();
          case AuthStatus.error:
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Ocurrió un error cargando tu sesión'),
                    const SizedBox(height: 12),
                    if (authProvider.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          authProvider.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: authProvider.signOut,
                      child: const Text('Volver a intentar'),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
