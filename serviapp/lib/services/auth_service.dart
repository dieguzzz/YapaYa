import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import 'firestore_paths.dart';

class AuthService {
  AuthService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<AppUser> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String phone,
    required UserType userType,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final uid = credential.user!.uid;
    await credential.user!.updateDisplayName(name.trim());

    final newUser = AppUser(
      id: uid,
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      userType: userType,
    );

    await _firestore
        .collection(FirestorePath.users)
        .doc(uid)
        .set(newUser.toMap());
    return newUser;
  }

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return fetchUserProfile(credential.user!.uid);
  }

  Future<AppUser> fetchUserProfile(String uid) async {
    final doc = await _firestore.collection(FirestorePath.users).doc(uid).get();
    if (!doc.exists) {
      throw Exception('El perfil del usuario no existe todavía.');
    }
    return AppUser.fromDoc(doc);
  }

  Future<void> sendPasswordReset(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() => _firebaseAuth.signOut();
}
