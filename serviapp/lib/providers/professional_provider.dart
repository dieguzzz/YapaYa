import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/professional_profile.dart';
import '../services/professional_service.dart';

class ProfessionalProvider extends ChangeNotifier {
  ProfessionalProvider({ProfessionalService? professionalService})
      : _professionalService = professionalService ?? ProfessionalService();

  final ProfessionalService _professionalService;

  StreamSubscription<ProfessionalProfile?>? _profileSubscription;
  ProfessionalProfile? _profile;
  String? _userId;
  bool _isSaving = false;
  String? _errorMessage;

  ProfessionalProfile? get profile => _profile;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  void attachUser(String? userId) {
    if (_userId == userId) return;
    _profileSubscription?.cancel();
    _userId = userId;

    if (userId == null) {
      _profile = null;
      notifyListeners();
      return;
    }

    _profileSubscription =
        _professionalService.watchProfile(userId).listen((profile) {
      _profile = profile;
      notifyListeners();
    });
  }

  Future<void> saveProfile({
    required String cedula,
    required List<String> references,
    required List<String> professions,
    required String description,
    required List<String> serviceAreas,
  }) async {
    if (_userId == null) {
      throw Exception('Debes iniciar sesión para completar tu perfil.');
    }

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = ProfessionalProfile(
        id: _userId!,
        userId: _userId!,
        cedula: cedula,
        references: references,
        professions: professions,
        description: description,
        serviceAreas: serviceAreas,
        verificationStatus: VerificationStatus.pending,
        portfolio: _profile?.portfolio ?? [],
        rating: _profile?.rating ?? 0,
        reviewCount: _profile?.reviewCount ?? 0,
      );
      await _professionalService.upsertProfile(profile);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _profileSubscription?.cancel();
    super.dispose();
  }
}
