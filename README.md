# ServiApp MVP Workspace

Este repositorio contiene el MVP inicial para la plataforma que conecta clientes con profesionales de servicios. El código fuente principal vive en `serviapp/`, creado con Flutter 3.24 y organizado siguiendo la arquitectura propuesta (models, services, providers, screens, widgets y utils).

## Contenido clave

- `serviapp/lib/`: Código fuente Flutter con autenticación Firebase lista para extender.
- `serviapp/firebase/`: Archivos de configuración (`firebase.json`, reglas de Firestore/Storage y carpeta para Cloud Functions).
- `serviapp/android` / `serviapp/ios`: Proyectos nativos configurados para Google Services (incluye archivos `.example` para las credenciales).

## Pasos rápidos

1. Instala Flutter 3.24+ (ya descargado localmente en `/workspace/flutter`).
2. Entra al proyecto: `cd serviapp`.
3. Configura Firebase:
   - Ejecuta `dart pub global activate flutterfire_cli`.
   - `flutterfire configure --project <tu-proyecto>` para generar `lib/firebase_options.dart`, `android/app/google-services.json` y `ios/Runner/GoogleService-Info.plist`.
4. Lanza la app: `flutter run`.

## Estado actual (Fase 2)

- Autenticación lista (email/contraseña) con `AuthProvider` y pantallas dedicadas.
- Navegación principal con `NavigationBar` que ofrece resumen, publicación de trabajos, búsqueda de profesionales y edición de perfil.
- Formularios funcionales para publicar trabajos (`JobProvider` + `JobService`) y para enviar información de verificación profesional (`ProfessionalProvider`).
- Búsqueda básica de profesionales por categoría/zona (`ProfessionalSearchProvider` + Firestore).
- Documentación, modelos y reglas de Firestore/Storage alineadas al esquema del MVP.

## Estado actual (Fase 3 - Chat & FCM)

- Chat en tiempo real con `ChatProvider`, `ChatService`, reglas reforzadas de Firestore y nuevas pantallas (`ChatListScreen`, `ChatRoomScreen`).
- Sincronización básica de tokens FCM mediante `PushNotificationService`, lista para conectar con Cloud Functions (`onChatMessage`) y FCM.
- Actualizaciones en `firebase/firestore.rules`, documentación y navegación (`Mensajes`) para cubrir la fase de comunicación/notificaciones.

Consulta `serviapp/README.md` para detalles de autenticación, estructura y próximos pasos del MVP.
