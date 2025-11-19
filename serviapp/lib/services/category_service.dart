import '../models/service_category.dart';

class CategoryService {
  CategoryService();

  final List<ServiceCategory> _categories = [
    ServiceCategory(
      id: 'electricista',
      name: 'Electricista',
      iconName: 'bolt',
      coverageAreas: ['San Francisco', 'Bella Vista', 'Costa del Este'],
    ),
    ServiceCategory(
      id: 'plomero',
      name: 'Plomero',
      iconName: 'water_drop',
      coverageAreas: ['San Francisco', 'Juan Díaz', 'Betania'],
    ),
    ServiceCategory(
      id: 'limpieza',
      name: 'Limpieza',
      iconName: 'cleaning_services',
      coverageAreas: ['Costa del Este', 'Obarrio', 'Punta Pacifica'],
    ),
    ServiceCategory(
      id: 'pintor',
      name: 'Pintor',
      iconName: 'format_paint',
      coverageAreas: ['Bella Vista', 'Brisas del Golf', 'Clayton'],
    ),
  ];

  List<ServiceCategory> get categories => List.unmodifiable(_categories);

  ServiceCategory? getById(String id) {
    return _categories.firstWhere(
      (category) => category.id == id,
      orElse: () => ServiceCategory(
        id: id,
        name: id,
        iconName: 'build',
        coverageAreas: const [],
      ),
    );
  }
}
