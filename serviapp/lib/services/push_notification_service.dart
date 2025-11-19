import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firestore_paths.dart';

class PushNotificationService {
  PushNotificationService({
    FirebaseMessaging? messaging,
    FirebaseFirestore? firestore,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;

  Future<void> syncUserToken(String uid) async {
    final settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
    final token = await _messaging.getToken();
    if (token == null) return;

    await _firestore.collection(FirestorePath.users).doc(uid).set(
      {
        'messagingTokens': FieldValue.arrayUnion([token]),
        'lastTokenSyncAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}
