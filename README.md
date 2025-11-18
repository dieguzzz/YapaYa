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

Consulta `serviapp/README.md` para detalles de autenticación, estructura y próximos pasos del MVP.*** End Patch
