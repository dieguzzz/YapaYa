import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/job_provider.dart';
import '../../services/category_service.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _budgetController = TextEditingController();
  final _categoryService = CategoryService();

  String? _selectedCategory;
  String? _selectedArea;

  @override
  void initState() {
    super.initState();
    final firstCategory = _categoryService.categories.first;
    _selectedCategory = firstCategory.id;
    _selectedArea = firstCategory.coverageAreas.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(JobProvider jobProvider) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedCategory == null || _selectedArea == null) return;

    final budget = double.tryParse(_budgetController.text.trim());

    await jobProvider.createJob(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory!,
      locationName: _locationController.text.trim().isEmpty
          ? _selectedArea!
          : _locationController.text.trim(),
      budget: budget,
    );

    if (mounted) {
      _formKey.currentState?.reset();
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _budgetController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trabajo publicado exitosamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final categories = _categoryService.categories;
    final currentCategory = categories.firstWhere(
        (c) => c.id == _selectedCategory,
        orElse: () => categories.first);
    final areas = currentCategory.coverageAreas;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory,
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
                  final newCategory =
                      categories.firstWhere((c) => c.id == value);
                  _selectedArea = newCategory.coverageAreas.first;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedArea,
              items: areas
                  .map(
                    (area) => DropdownMenuItem(
                      value: area,
                      child: Text(area),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedArea = value),
              decoration: const InputDecoration(
                labelText: 'Zona sugerida',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _titleController,
              label: 'Título del trabajo',
              validator: (value) =>
                  Validators.requiredField(value, fieldName: 'Título'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              minLines: 4,
              maxLines: 6,
              validator: (value) =>
                  Validators.requiredField(value, fieldName: 'Descripción'),
              decoration: const InputDecoration(
                labelText: 'Descripción detallada',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _locationController,
              label: 'Ubicación específica (opcional)',
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _budgetController,
              label: 'Presupuesto estimado (USD)',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            if (jobProvider.errorMessage != null)
              Text(
                jobProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            if (jobProvider.errorMessage != null) const SizedBox(height: 12),
            PrimaryButton(
              label: 'Publicar trabajo',
              isLoading: jobProvider.isSubmitting,
              onPressed: jobProvider.isSubmitting
                  ? null
                  : () => _handleSubmit(jobProvider),
            ),
          ],
        ),
      ),
    );
  }
}
