import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/professional_profile.dart';
import '../../providers/professional_search_provider.dart';

class ProfessionalsScreen extends StatefulWidget {
  const ProfessionalsScreen({super.key});

  @override
  State<ProfessionalsScreen> createState() => _ProfessionalsScreenState();
}

class _ProfessionalsScreenState extends State<ProfessionalsScreen> {
  String? _selectedCategory;
  String? _selectedArea;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<ProfessionalSearchProvider>();
    _selectedCategory ??= provider.categories.categories.first.id;
    _selectedArea ??= provider.categories.categories.first.coverageAreas.first;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfessionalSearchProvider>(
      builder: (context, provider, _) {
        final categories = provider.categories.categories;
        final currentCategory = categories.firstWhere(
          (category) => category.id == _selectedCategory,
          orElse: () => categories.first,
        );
        final areas = currentCategory.coverageAreas;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(),
                      ),
                      items: categories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category.id,
                              child: Text(category.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                          final nextCategory = categories.firstWhere(
                              (c) => c.id == value,
                              orElse: () => categories.first);
                          _selectedArea = nextCategory.coverageAreas.first;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedArea,
                      decoration: const InputDecoration(
                        labelText: 'Zona',
                        border: OutlineInputBorder(),
                      ),
                      items: areas
                          .map(
                            (area) => DropdownMenuItem(
                              value: area,
                              child: Text(area),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedArea = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: provider.isSearching
                    ? null
                    : () {
                        if (_selectedCategory == null ||
                            _selectedArea == null) {
                          return;
                        }
                        provider.search(
                          category: _selectedCategory!,
                          area: _selectedArea!,
                        );
                      },
                icon: const Icon(Icons.search),
                label: const Text('Buscar profesionales'),
              ),
              const SizedBox(height: 24),
              if (provider.isSearching) const CircularProgressIndicator(),
              if (provider.errorMessage != null)
                Text(
                  provider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              if (!provider.isSearching &&
                  provider.results.isEmpty &&
                  provider.errorMessage == null)
                const Text('No hay resultados todavía. Haz una búsqueda.'),
              if (provider.results.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.results.length,
                    itemBuilder: (context, index) {
                      final prof = provider.results[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(prof.professions.isNotEmpty
                                ? prof.professions.first[0].toUpperCase()
                                : '?'),
                          ),
                          title: Text(prof.professions.join(', ')),
                          subtitle: Text(
                            'Cobertura: ${prof.serviceAreas.join(', ')}\n'
                            'Rating: ${prof.rating.toStringAsFixed(1)} (${prof.reviewCount} reviews)',
                          ),
                          isThreeLine: true,
                          trailing: Text(
                            prof.verificationStatus.name,
                            style: TextStyle(
                              color: prof.verificationStatus ==
                                      VerificationStatus.verified
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
