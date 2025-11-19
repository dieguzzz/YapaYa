import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/job_request.dart';
import '../services/job_service.dart';

class JobProvider extends ChangeNotifier {
  JobProvider({JobService? jobService})
      : _jobService = jobService ?? JobService();

  final JobService _jobService;

  StreamSubscription<List<JobRequest>>? _jobsSubscription;
  List<JobRequest> _myJobs = [];
  String? _userId;
  bool _isSubmitting = false;
  String? _errorMessage;

  List<JobRequest> get myJobs => _myJobs;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  void attachUser(String? userId) {
    if (_userId == userId) return;
    _jobsSubscription?.cancel();
    _userId = userId;

    if (userId == null) {
      _myJobs = [];
      notifyListeners();
      return;
    }

    _jobsSubscription = _jobService.watchClientJobs(userId).listen((jobs) {
      _myJobs = jobs;
      notifyListeners();
    });
  }

  Future<void> createJob({
    required String title,
    required String description,
    required String category,
    required String locationName,
    double? budget,
  }) async {
    if (_userId == null) {
      throw Exception('Debes iniciar sesión para publicar un trabajo.');
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _jobService.createJob(
        clientId: _userId!,
        title: title,
        description: description,
        category: category,
        locationName: locationName,
        budget: budget,
      );
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _jobsSubscription?.cancel();
    super.dispose();
  }
}
