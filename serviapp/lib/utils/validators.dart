class Validators {
  static String? requiredField(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es obligatorio';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredMessage = requiredField(value, fieldName: 'Email');
    if (requiredMessage != null) return requiredMessage;
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value!.trim())) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  static String? password(String? value) {
    final requiredMessage = requiredField(value, fieldName: 'Contraseña');
    if (requiredMessage != null) return requiredMessage;
    if (value!.trim().length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }
}
