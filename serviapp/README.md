# ServiApp (MVP)

Base Flutter app para el marketplace de servicios profesionales descrito en el documento de requerimientos. Esta iteración inicial cubre:

- Configuración del proyecto Flutter + Firebase.
- Arquitectura base (`models/`, `services/`, `providers/`, `screens/`, `widgets/`, `utils/`).
- Flujo de autenticación con correo/contraseña usando Firebase Auth + Firestore.
- Reglas iniciales de seguridad para Firestore y Storage.

## Stack

- Flutter 3.24 (Dart 3.5).
- Firebase (Auth, Firestore, Storage, Cloud Messaging, Cloud Functions).
- Provider para state management.
- Google Maps plugin y utilidades para futuras fases.

## Requisitos previos

- Flutter SDK instalado (el repo ya incluye `/workspace/flutter`, pero puedes usar tu instalación local).
- Cuenta de Firebase con un proyecto creado.
- Java 17 para builds Android (ver advertencia de Gradle al crear el proyecto).

## Configuración rápida

```bash
cd serviapp
flutter pub get

# Instala el CLI oficial de FlutterFire si no lo tienes
dart pub global activate flutterfire_cli

# Vincula este código con tu proyecto de Firebase (elige las plataformas que usarás)
flutterfire configure --project <tu-proyecto>

# Copia las credenciales descargadas a las rutas esperadas (si no usas flutterfire configure):
# - android/app/google-services.json
# - ios/Runner/GoogleService-Info.plist
# - lib/firebase_options.dart (sustituye los placeholders)

flutter run
```

> Nota: En `android/app/google-services.json.example` y `ios/Runner/GoogleService-Info.plist.example` tienes el formato esperado para cada plataforma.

## Estructura principal

```
lib/
├── firebase_options.dart   # Placeholder, reemplazar con el generado por flutterfire
├── main.dart               # Inicializa Firebase y monta el AuthGate
├── models/                 # Modelos de dominio (AppUser, etc.)
├── providers/              # Provider(s) para el estado global (AuthProvider)
├── screens/                # Pantallas (auth, home, splash)
├── services/               # Integraciones (AuthService, rutas de Firestore)
├── utils/                  # Validadores y helpers
└── widgets/                # Componentes reutilizables (inputs, botones)
```

La carpeta `firebase/` incluye:

- `firebase.json`: referencias de reglas y funciones.
- `firestore.rules` y `storage.rules`: reglas base que cubren usuarios, profesionales, chats, jobs y transacciones.
- `functions/`: carpeta vacía lista para las Cloud Functions (`onJobCreated`, `onYappyWebhook`, `onChatMessage`).

## Autenticación

- Registro y login con email + contraseña.
- Captura básica de datos: nombre, teléfono y tipo de usuario (`client` | `professional`).
- Persistencia del perfil en `users/{uid}` siguiendo el modelo del MVP.
- Provider gestiona los estados `unknown`, `authenticating`, `authenticated`, `unauthenticated` y `error`.
- Pantallas iniciales (`LoginScreen`, `RegisterScreen`) listas para aplicar branding.

## Fase 2 (Perfiles y Servicios)

- `DashboardScreen`: resumen de usuario y listado de trabajos publicados (stream desde Firestore).
- `CreateJobScreen`: formulario para publicar servicios con categoría, zona sugerida y presupuesto.
- `ProfessionalsScreen`: búsqueda de profesionales verificados por categoría/zona usando `ProfessionalSearchProvider`.
- `ProfileScreen`: captura/edición del perfil profesional (cédula, oficios, referencias, service areas) y muestra estado de verificación.
- Providers nuevos:
  - `JobProvider`: maneja publicaciones y escucha cambios de trabajos del cliente.
  - `ProfessionalProvider`: sincroniza el documento del profesional en Firestore y gestiona envíos para verificación.
  - `ProfessionalSearchProvider`: expone búsquedas con `ProfessionalService`.
- Servicios nuevos: `JobService`, `ProfessionalService`, `CategoryService` y modelos (`JobRequest`, `ProfessionalProfile`, `ServiceCategory`).
- Navegación principal: `HomeScreen` ahora es un `NavigationBar` con pestañas `Resumen`, `Publicar`, `Profesionales`, `Perfil`.

## Próximos pasos sugeridos

1. Integrar verificación de teléfono (Firebase Phone Auth) y validaciones adicionales para profesionales (cédula, referencias).
2. Implementar la publicación de servicios (`jobs`) y notificaciones push (Cloud Functions + FCM).
3. Añadir chat en tiempo real (colecciones `chats` y `messages`) y la integración con Yappy para pagos.
4. Completar el flujo de calificaciones y el sistema de matching con reglas de negocio (timeout 4h, top 5 profesionales, etc.).

## Scripts útiles

| Acción | Comando |
| --- | --- |
| Formatear código | `flutter format lib` |
| Análisis estático | `flutter analyze` |
| Ejecutar pruebas | `flutter test` |

---

Para cualquier duda o ajuste de alcance, comenta en el issue correspondiente o abre una nueva tarea en la fase actual.*** End Patch
