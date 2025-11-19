import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../services/push_notification_service.dart';

enum AuthStatus {
  unknown,
  unauthenticated,
  authenticating,
  authenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    AuthService? authService,
    PushNotificationService? notificationService,
  })  : _authService = authService ?? AuthService(),
        _notificationService =
            notificationService ?? PushNotificationService() {
    _subscribeToAuthChanges();
  }

  final AuthService _authService;
  final PushNotificationService _notificationService;
  late final StreamSubscription<User?> _authSubscription;

  AuthStatus _status = AuthStatus.unknown;
  AppUser? _currentUser;
  String? _errorMessage;

  AuthStatus get status => _status;
  AppUser? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  void _subscribeToAuthChanges() {
    _authSubscription = _authService.authStateChanges().listen((user) async {
      if (user == null) {
        _currentUser = null;
        _setStatus(AuthStatus.unauthenticated);
        return;
      }
      try {
        final profile = await _authService.fetchUserProfile(user.uid);
        _currentUser = profile;
        _errorMessage = null;
        await _notificationService.syncUserToken(profile.id);
        _setStatus(AuthStatus.authenticated);
      } catch (e) {
        _currentUser = null;
        _errorMessage = e.toString();
        _setStatus(AuthStatus.error);
      }
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _setStatus(AuthStatus.authenticating);
    try {
      final profile = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      _currentUser = profile;
      _errorMessage = null;
      await _notificationService.syncUserToken(profile.id);
      _setStatus(AuthStatus.authenticated);
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _setStatus(AuthStatus.unauthenticated);
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(AuthStatus.unauthenticated);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required UserType userType,
  }) async {
    _setStatus(AuthStatus.authenticating);
    try {
      final profile = await _authService.registerWithEmail(
        name: name,
        email: email,
        password: password,
        phone: phone,
        userType: userType,
      );
      _currentUser = profile;
      _errorMessage = null;
      await _notificationService.syncUserToken(profile.id);
      _setStatus(AuthStatus.authenticated);
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _setStatus(AuthStatus.unauthenticated);
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(AuthStatus.unauthenticated);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    _errorMessage = null;
    _setStatus(AuthStatus.unauthenticated);
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
