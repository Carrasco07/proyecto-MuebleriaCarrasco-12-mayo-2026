# 📋 Plan de Implementación: App Multiplataforma "Muebleria Carrasco"
**Stack:** Flutter + Dart | Firebase (Auth + Firestore) | Provider | VS Code  
**Formato:** Procedimiento paso a paso (sin código) | Listo para ejecución secuencial

---

## 🔧 Fase 1: Preparación del Entorno de Desarrollo
1. **Instalación del SDK**
   - Descargar e instalar Flutter SDK y Dart SDK oficiales.
   - Configurar variables de entorno (`PATH`) para acceso global desde terminal.
2. **Configuración de VS Code**
   - Instalar extensiones oficiales: `Flutter`, `Dart`, `Firebase`, `Error Lens`, `Pubspec Assist`.
   - Activar `Format on Save`, `Linting` y `Hot Reload` automático.
3. **Entornos de Ejecución**
   - Configurar emuladores Android/iOS o conectar dispositivos físicos.
   - Verificar compatibilidad multiplataforma con `flutter doctor -v`.
4. **Inicialización del Proyecto**
   - Crear proyecto: `muebleria_carrasco`.
   - Inicializar repositorio Git con `.gitignore` estándar para Flutter.
   - Definir estructura de carpetas inicial (`lib/src/...`, `assets/`, `test/`).

---

## 🎨 Fase 2: Arquitectura y Diseño UI/UX
1. **Definición de Arquitectura**
   - Adoptar patrón **MVVM simplificado con Provider**: separación clara entre UI, Lógica de Estado y Servicios.
   - Establecer flujo de datos unidireccional (UI → Provider → Service → Firebase → UI).
2. **Guías UI/UX para Mueblería**
   - Paleta de colores: tonos cálidos/madera, neutros elegantes, acentos en verde bosque o terracota.
   - Tipografía: sans-serif legible para catálogo, serif opcional para encabezados premium.
   - Espaciado y jerarquía visual: énfasis en imágenes de producto, precios claros, CTAs prominentes.
   - Diseño responsivo: adaptación móvil → tablet → escritorio (usar `LayoutBuilder` y `MediaQuery` en etapa de implementación).
3. **Prototipado y Flujo de Navegación**
   - Crear wireframes en Figma/Adobe XD: Splash → Auth → Home/Catálogo → Detalle Producto → Carrito → Perfil/Órdenes.
   - Definir estados de carga, error y vacío para cada pantalla.
   - Documentar componentes reutilizables: `ProductCard`, `CustomAppBar`, `BottomNav`, `LoadingOverlay`.

---

## ☁️ Fase 3: Configuración de Firebase
1. **Creación del Proyecto**
   - Registrar proyecto en Firebase Console: `muebleria-carrasco-app`.
   - Habilitar servicios requeridos: Authentication, Firestore Database, Crashlytics (opcional), Storage (para imágenes futuras).
2. **Registro de Plataformas**
   - Agregar app Android (`com.carrasco.muebleria`), iOS y Web.
   - Descargar `google-services.json` y `GoogleService-Info.plist`; colocarlos en rutas estándar de Flutter.
3. **Configuración de Seguridad Inicial**
   - Firestore: iniciar en modo prueba para desarrollo, documentar reglas de producción posteriores.
   - Auth: habilitar método **Correo electrónico/Contraseña**.
   - Configurar Firebase CLI para integración con Flutter (`firebase login`, `firebase init`).

---

## 📦 Fase 4: Gestión de Dependencias (`pubspec.yaml`)
1. **Dependencias Principales**
   - `firebase_core`: inicialización del ecosistema.
   - `firebase_auth`: manejo de sesiones y autenticación.
   - `cloud_firestore`: base de datos NoSQL en tiempo real.
   - `provider`: gestión de estado reactiva.
   - `flutter_dotenv` o `flutter_config`: manejo de variables de entorno.
   - `intl`: formatos de fecha, moneda y localización (español).
   - `cached_network_image`: carga y cacheo de imágenes de productos.
   - `flutter_svg` (si aplica): iconos y logos vectoriales.
2. **Dependencias de Desarrollo**
   - `flutter_lints`, `mockito`, `flutter_test`: linting, pruebas unitarias y widget tests.
3. **Acción**
   - Agregar dependencias en `pubspec.yaml`.
   - Ejecutar `flutter pub get`.
   - Verificar compatibilidad de versiones con `flutter pub outdated`.

---

## 🔐 Fase 5: Autenticación de Usuarios (Email/Password)
1. **Capa de Servicios**
   - Crear `AuthService` que envuelva métodos de `firebase_auth`: `signIn`, `signUp`, `signOut`, `resetPassword`, `onAuthStateChanged`.
2. **Capa de Estado (Provider)**
   - Implementar `AuthProvider extends ChangeNotifier`.
   - Exponer: `currentUser`, `isLoading`, `errorMessage`, `isAuthenticated`.
   - Manejar persistencia de sesión y redirección automática.
3. **UI de Autenticación**
   - Pantallas: `LoginScreen`, `RegisterScreen`, `ForgotPasswordScreen`.
   - Validaciones de formulario (regex email, longitud/seguridad de contraseña).
   - Feedback visual: spinners, snackbars de error, transiciones suaves.
   - Protección de rutas: middleware o `Navigator` que redirija a login si no hay sesión.

---

## 🗃️ Fase 6: Firestore y Gestión de Estado con Provider
1. **Modelado de Datos**
   - Colecciones: `users`, `products`, `categories`, `cart`, `orders`.
   - Definir clases modelo Dart con métodos `fromJson`/`toJson` para mapeo automático.
   - Establecer relaciones: categoría → productos, usuario → órdenes/carrito.
2. **Servicio de Base de Datos**
   - Crear `FirestoreService` con métodos CRUD paginados y en tiempo real (`snapshots`).
   - Implementar filtros por categoría, precio, búsqueda textual.
   - Manejar transacciones para carrito y actualización de stock.
3. **Providers de Negocio**
   - `ProductProvider`: lista de productos, detalle, búsqueda.
   - `CartProvider`: agregar/eliminar, cálculo de total, persistencia local opcional.
   - `OrderProvider`: historial, estado de envío.
   - Usar `StreamProvider` o `FutureProvider` según si se requiere actualización en vivo o carga única.

---

## 📱 Fase 7: Estructura de Pantallas y Navegación
1. **Enrutamiento**
   - Definir rutas nombradas o enrutador declarativo.
   - Implementar guardias de autenticación y deep links (futuro).
2. **Desarrollo de Pantallas Core**
   - `HomeScreen`: banners, categorías destacadas, productos populares.
   - `CatalogScreen`: grid/listado, filtros, ordenamiento.
   - `ProductDetailScreen`: galería, descripción, especificaciones, botón "Añadir al carrito".
   - `CartScreen`: resumen, edición de cantidades, checkout simulado o integrado.
   - `ProfileScreen`: datos de usuario, historial de pedidos, cerrar sesión.
3. **Widgets Reutilizables y UX**
   - Implementar `AppTheme` centralizado (colores, tipografías, bordes, sombras).
   - Crear componentes atómicos: botones, inputs, badges, skeletons de carga.
   - Optimizar rendimiento: `const` widgets, `ListView.builder`, `RepaintBoundary` si aplica.

---

## 🧪 Fase 8: Pruebas, Seguridad y Despliegue
1. **Pruebas Automatizadas**
   - Unit tests: `AuthService`, `FirestoreService`, lógica de `CartProvider`.
   - Widget tests: validación de formularios, renderizado de listas, navegación.
   - Integration tests: flujo completo login → catálogo → carrito.
2. **Seguridad y Reglas**
   - Definir Firestore Security Rules por rol (cliente vs admin).
   - Validar datos en backend (opcional: Cloud Functions para verificación de stock/pagos).
   - Implementar manejo global de errores y logging.
3. **Optimización y Build**
   - Reducir tamaño de APK/IPA: `flutter build --split-per-abi`, compresión de assets.
   - Configurar íconos, splash screen y metadatos por plataforma.
   - Generar builds de release para Android, iOS y Web.
4. **Despliegue y Mantenimiento**
   - Subir a Google Play Console y App Store Connect.
   - Desplegar versión web en Firebase Hosting o Vercel.
   - Documentar arquitectura, flujos y decisiones técnicas.
   - Establecer ciclo de actualizaciones y monitoreo de crashes.

---

## 📌 Notas para el Siguiente Paso
- Este plan está diseñado para ejecutarse de forma **iterativa e incremental**.
- Una vez validada esta hoja de ruta, puedo proporcionar:
  - Estructura exacta de carpetas.
  - `pubspec.yaml` completo con versiones estables.
  - Arquitectura de Providers y Servicios.
  - Flujos de autenticación y consultas Firestore.
- ¿Deseas ajustar algún alcance (ej. agregar panel de administrador, integración de pagos, o modo offline) antes de pasar a la fase de código?
