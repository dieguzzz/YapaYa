# ServiApp – Release Checklist

Use this checklist before uploading a build to the Play Store or App Store.

## 1. Calidad y pruebas

- [ ] Ejecuta el script de CI local `./tool/ci.sh`.
- [ ] Verifica `flutter analyze` y `flutter test` sin errores.
- [ ] Prueba manualmente login, publicación de trabajos, chat y perfil profesional en **Android** y **iOS** (debug y release).
- [ ] Asegúrate de que las notificaciones push (FCM) soliciten permisos y sincronicen tokens correctamente.

## 2. Configuración Firebase/Back-end

- [ ] `firebase_options.dart`, `google-services.json` y `GoogleService-Info.plist` actualizados para el proyecto productivo.
- [ ] Reglas de Firestore y Storage desplegadas (`firebase deploy --only firestore:rules,storage:rules`).
- [ ] Cloud Functions (`onChatMessage`, `onJobCreated`, `onYappyWebhook`) desplegadas y probadas en el emulador/producción.

## 3. Android (Play Store)

- [ ] Actualiza `applicationId` en `android/app/build.gradle` y `versionName/versionCode` en `pubspec.yaml`.
- [ ] Configura firma de release (keystore + `key.properties` o Play App Signing).
- [ ] Ejecuta `flutter build appbundle --release`.
- [ ] Verifica el bundle con `bundletool` o subiéndolo al track interno.
- [ ] Revisa íconos, nombre de app y `android:label`.

## 4. iOS (App Store)

- [ ] Ajusta `PRODUCT_BUNDLE_IDENTIFIER`, `DISPLAY_NAME` y `VERSION` desde Xcode.
- [ ] Configura certificados y perfiles (o usa Xcode automatic signing).
- [ ] Ejecuta `flutter build ipa --release` (o `flutter build ios --release` + Xcode Archive).
- [ ] Prueba en TestFlight antes de enviar a App Review.
- [ ] Asegúrate de tener descripciones de permisos (NSPhotoLibraryUsageDescription, etc.) en `Info.plist`.

## 5. Metadatos y soporte

- [ ] Actualiza screenshots, descripción y keywords en ambas tiendas.
- [ ] Prepara respuestas para revisión (privacidad, uso de datos, pagos).
- [ ] Define un correo de soporte y política de privacidad accesibles desde la app/tie nda.

## 6. Post-release

- [ ] Monitorea Firebase Crashlytics/Logs después del lanzamiento.
- [ ] Toma métricas de retención y conversión usando Analytics/BigQuery si aplica.
- [ ] Planifica hotfix o siguiente iteración (pagos, matching avanzado, etc.).

> Tip: crea un release tag en Git después de subir la build (`git tag -a v1.0.0 -m "Phase 4 release"` y `git push --tags`).
