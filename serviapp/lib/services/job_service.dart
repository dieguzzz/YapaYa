import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/job_request.dart';
import 'firestore_paths.dart';

class JobService {
  JobService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestorePath.jobs);

  Future<JobRequest> createJob({
    required String clientId,
    required String title,
    required String description,
    required String category,
    required String locationName,
    double? budget,
    List<String> photos = const [],
  }) async {
    final docRef = _collection.doc();

    final job = JobRequest(
      id: docRef.id,
      clientId: clientId,
      title: title,
      description: description,
      category: category,
      locationName: locationName,
      budget: budget,
      photos: photos,
      status: JobStatus.posted,
    );

    await docRef.set(job.toMap());
    return job;
  }

  Stream<List<JobRequest>> watchClientJobs(String clientId) {
    return _collection
        .where('clientId', isEqualTo: clientId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(JobRequest.fromDoc).toList());
  }

  Stream<List<JobRequest>> watchProfessionalJobs(String professionalId) {
    return _collection
        .where('professionalId', isEqualTo: professionalId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(JobRequest.fromDoc).toList());
  }

  Future<void> updateJobStatus({
    required String jobId,
    required JobStatus status,
    String? professionalId,
  }) async {
    await _collection.doc(jobId).update({
      'status': jobStatusToString(status),
      if (professionalId != null) 'professionalId': professionalId,
      if (status == JobStatus.completed)
        'completedAt': FieldValue.serverTimestamp(),
    });
  }
}
