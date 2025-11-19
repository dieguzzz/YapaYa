import 'package:flutter/foundation.dart';

import '../models/professional_profile.dart';
import '../services/category_service.dart';
import '../services/professional_service.dart';

class ProfessionalSearchProvider extends ChangeNotifier {
  ProfessionalSearchProvider({
    ProfessionalService? professionalService,
    CategoryService? categoryService,
  })  : _professionalService = professionalService ?? ProfessionalService(),
        _categoryService = categoryService ?? CategoryService();

  final ProfessionalService _professionalService;
  final CategoryService _categoryService;

  List<ProfessionalProfile> _results = [];
  bool _isSearching = false;
  String? _errorMessage;

  List<ProfessionalProfile> get results => _results;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  CategoryService get categories => _categoryService;

  Future<void> search({
    required String category,
    required String area,
  }) async {
    _isSearching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _results = await _professionalService.findProfessionals(
        category: category,
        area: area,
        limit: 5,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }
}
