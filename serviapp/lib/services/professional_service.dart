import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/professional_profile.dart';
import 'firestore_paths.dart';

class ProfessionalService {
  ProfessionalService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestorePath.professionals);

  Stream<ProfessionalProfile?> watchProfile(String userId) {
    return _collection.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return ProfessionalProfile.fromDoc(doc);
    });
  }

  Future<ProfessionalProfile?> fetchProfile(String userId) async {
    final doc = await _collection.doc(userId).get();
    if (!doc.exists) return null;
    return ProfessionalProfile.fromDoc(doc);
  }

  Future<void> upsertProfile(ProfessionalProfile profile) async {
    await _collection
        .doc(profile.id)
        .set(profile.toMap(), SetOptions(merge: true));
  }

  Future<List<ProfessionalProfile>> findProfessionals({
    required String category,
    required String area,
    int limit = 5,
  }) async {
    final querySnapshot = await _collection
        .where('professions', arrayContains: category)
        .where('serviceAreas', arrayContains: area)
        .orderBy('rating', descending: true)
        .limit(limit)
        .get();

    return querySnapshot.docs.map(ProfessionalProfile.fromDoc).toList();
  }
}
