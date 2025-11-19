class ServiceCategory {
  ServiceCategory({
    required this.id,
    required this.name,
    required this.iconName,
    required this.coverageAreas,
  });

  final String id;
  final String name;
  final String iconName;
  final List<String> coverageAreas;
}
