# Plan de Implementación — App Multiplataforma "Mueblería Carrasco"

**Stack tecnológico:** Flutter 3.x · Dart 3.x · Firebase (Auth + Firestore + Storage) · Provider · VS Code  
**Versión del documento:** 1.0  
**Metodología:** Desarrollo iterativo e incremental por fases validadas  

---

## Identidad Visual y Sistema de Diseño

Antes de escribir una sola línea de código, se define el sistema de diseño que regirá toda la interfaz. La aplicación adoptará una estética corporativa sobria, moderna y confiable, orientada a transmitir profesionalismo y calidad en cada pantalla.

**Paleta de colores principal**

| Rol | Color | Hex |
|-----|-------|-----|
| Primary | Azul grisáceo profundo | `#3B4F6B` |
| Primary Dark | Azul pizarra | `#2B3A52` |
| Primary Light | Azul grisáceo suave | `#5C728E` |
| Surface | Gris muy claro | `#F2F4F7` |
| Background | Blanco humo | `#EBEEF2` |
| Card | Blanco puro | `#FFFFFF` |
| Text Primary | Gris carbón | `#1E2A38` |
| Text Secondary | Gris medio | `#6B7A90` |
| Text Hint | Gris claro | `#9AAABB` |
| Accent / CTA | Azul acero | `#4A7FA5` |
| Error | Rojo apagado | `#C0392B` |
| Success | Verde grisáceo | `#4A7C6F` |
| Divider | Gris borde | `#D1D9E0` |

**Tipografía**

- Encabezados y títulos: `Inter` — peso 600–700, tracking ajustado.
- Cuerpo de texto: `Inter` — peso 400, tamaño 14–16sp.
- Etiquetas y badges: `Inter` — peso 500, tamaño 11–13sp.
- Precios y cifras: `Roboto Mono` o `Inter Numeric` para alineación consistente.

**Principios de diseño**

- Espaciado basado en múltiplos de 8px (8, 16, 24, 32, 48).
- Bordes redondeados: tarjetas 12px, botones 8px, inputs 8px, chips 20px.
- Sombras sutiles con opacidad máxima de 0.08 para no saturar el diseño.
- Imágenes de producto como elemento protagónico: relación de aspecto 4:3 fija.
- Estados de UI siempre definidos: cargando, vacío, error y datos presentes.

---

## Fase 1 — Entorno de Desarrollo

### 1.1 Instalación de herramientas base

Instalar Flutter SDK 3.x y Dart SDK en sus versiones estables más recientes. Configurar las variables de entorno `FLUTTER_HOME` y agregar `bin/` al `PATH` del sistema para acceso global desde cualquier terminal. Verificar que la instalación sea correcta ejecutando `flutter doctor -v` y resolver cada advertencia antes de continuar.

Instalar Android Studio únicamente para el SDK de Android y los emuladores (no como IDE principal). Instalar Xcode en macOS para compilación iOS. Instalar Google Chrome para el target Web.

### 1.2 Configuración de VS Code

Instalar las siguientes extensiones:

- Flutter (oficial de Dart Code) — soporte completo para hot reload, depuración y refactoring.
- Dart (oficial de Dart Code) — análisis estático y autocompletado.
- Firebase Explorer — inspección de colecciones Firestore desde el editor.
- Error Lens — visualización de errores en línea sin abrir el panel de problemas.
- Pubspec Assist — gestión rápida de dependencias desde la paleta de comandos.
- GitLens — historial de cambios y anotaciones de autoría en línea.
- Flutter Coverage — visualización de cobertura de tests directamente en el código.

Configurar el archivo `settings.json` del workspace con: guardado automático al cambiar de pestaña, formato automático al guardar, linting activo, longitud de línea visible en 100 caracteres y organización de imports al guardar.

### 1.3 Inicialización del proyecto

Crear el proyecto con `flutter create muebleria_carrasco --org com.carrasco --platforms android,ios,web`. Inicializar repositorio Git de inmediato con un `.gitignore` estándar para Flutter que excluya directorios de build, archivos de configuración de IDE y claves de Firebase. Crear las ramas `main` (producción), `develop` (integración) y convención de ramas de feature `feature/nombre-funcionalidad`.

---

## Fase 2 — Arquitectura del Proyecto

### 2.1 Patrón arquitectónico

La aplicación adoptará el patrón **MVVM simplificado con Provider**, con separación estricta en cuatro capas:

- **Capa de presentación (View):** Widgets de Flutter, pantallas, componentes. No contiene lógica de negocio.
- **Capa de estado (ViewModel / Provider):** ChangeNotifiers que exponen estado reactivo a la UI y orquestan llamadas a servicios.
- **Capa de servicios (Service):** Clases que encapsulan la comunicación con Firebase, APIs externas y almacenamiento local.
- **Capa de modelos (Model):** Clases Dart puras con métodos `fromJson`, `toJson`, `copyWith` y operadores de igualdad.

El flujo de datos es estrictamente unidireccional: UI → Provider → Service → Firebase → Stream/Future → Provider → UI.

### 2.2 Estructura de carpetas y archivos

La estructura es el contrato de organización del proyecto. Todo archivo nuevo debe ubicarse en la carpeta correspondiente sin excepción.

```
muebleria_carrasco/
│
├── android/                        # Configuración nativa Android
├── ios/                            # Configuración nativa iOS
├── web/                            # Configuración target Web
├── assets/
│   ├── images/                     # Imágenes estáticas (logo, placeholders)
│   ├── icons/                      # Iconos SVG propios
│   └── fonts/                      # Fuentes tipográficas (Inter, Roboto Mono)
│
├── lib/
│   ├── main.dart                   # Punto de entrada — inicialización Firebase + providers
│   ├── app.dart                    # MaterialApp, tema global, rutas raíz
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart     # Definición completa de la paleta de colores
│   │   │   ├── app_typography.dart # TextStyles y TextTheme de la app
│   │   │   ├── app_spacing.dart    # Constantes de padding y margin (base 8px)
│   │   │   └── app_strings.dart    # Textos literales de la interfaz (i18n futuro)
│   │   ├── theme/
│   │   │   └── app_theme.dart      # ThemeData completo: colores, tipografía, inputs, botones
│   │   ├── router/
│   │   │   ├── app_router.dart     # Definición de rutas nombradas y declarativas
│   │   │   └── route_guard.dart    # Guardia de autenticación (redirige a login si no hay sesión)
│   │   ├── errors/
│   │   │   ├── app_exception.dart  # Clase base de excepciones de negocio
│   │   │   └── error_handler.dart  # Mapeo de errores Firebase a mensajes amigables
│   │   └── utils/
│   │       ├── validators.dart     # Funciones de validación: email, contraseña, teléfono
│   │       ├── formatters.dart     # Formato de moneda MXN, fechas en español
│   │       └── extensions.dart     # Extension methods: String, DateTime, num
│   │
│   ├── models/
│   │   ├── user_model.dart         # Modelo de usuario autenticado y perfil
│   │   ├── product_model.dart      # Modelo de producto con fromJson/toJson
│   │   ├── category_model.dart     # Modelo de categoría
│   │   ├── cart_item_model.dart    # Ítem dentro del carrito de compras
│   │   ├── order_model.dart        # Pedido completo con líneas y estado
│   │   └── order_item_model.dart   # Línea individual de un pedido
│   │
│   ├── services/
│   │   ├── auth_service.dart       # Métodos Firebase Auth: signIn, signUp, signOut, reset
│   │   ├── firestore_service.dart  # CRUD genérico sobre colecciones Firestore
│   │   ├── product_service.dart    # Consultas de productos, filtros, paginación
│   │   ├── order_service.dart      # Creación y consulta de pedidos, transacciones
│   │   ├── cart_service.dart       # Lógica de carrito, sincronización local/remota
│   │   └── storage_service.dart    # Subida y descarga de imágenes en Firebase Storage
│   │
│   ├── providers/
│   │   ├── auth_provider.dart      # Estado de sesión, usuario actual, carga, error
│   │   ├── product_provider.dart   # Lista de productos, búsqueda, filtros activos
│   │   ├── category_provider.dart  # Categorías disponibles para filtrado
│   │   ├── cart_provider.dart      # Estado del carrito, totales, operaciones
│   │   └── order_provider.dart     # Historial de pedidos del usuario autenticado
│   │
│   ├── screens/
│   │   ├── splash/
│   │   │   └── splash_screen.dart          # Pantalla inicial con logo y verificación de sesión
│   │   ├── auth/
│   │   │   ├── login_screen.dart           # Formulario de inicio de sesión
│   │   │   ├── register_screen.dart        # Formulario de registro de nueva cuenta
│   │   │   └── forgot_password_screen.dart # Solicitud de restablecimiento por correo
│   │   ├── home/
│   │   │   └── home_screen.dart            # Dashboard: banners, categorías, destacados
│   │   ├── catalog/
│   │   │   ├── catalog_screen.dart         # Listado de productos con filtros y ordenamiento
│   │   │   └── filter_bottom_sheet.dart    # Panel de filtros deslizable desde la parte inferior
│   │   ├── product/
│   │   │   └── product_detail_screen.dart  # Detalle: galería, descripción, especificaciones, CTA
│   │   ├── cart/
│   │   │   └── cart_screen.dart            # Resumen del carrito, edición de cantidades, checkout
│   │   ├── checkout/
│   │   │   └── checkout_screen.dart        # Confirmación de datos, dirección, método de pago
│   │   ├── orders/
│   │   │   ├── orders_screen.dart          # Historial de pedidos del usuario
│   │   │   └── order_detail_screen.dart    # Detalle de un pedido específico con estado
│   │   └── profile/
│   │       └── profile_screen.dart         # Datos del usuario, preferencias, cerrar sesión
│   │
│   └── widgets/
│       ├── common/
│       │   ├── custom_app_bar.dart          # AppBar reutilizable con acciones configurables
│       │   ├── custom_button.dart           # Botón primario, secundario y ghost con estados
│       │   ├── custom_text_field.dart       # Input estilizado con validación integrada
│       │   ├── loading_overlay.dart         # Indicador de carga a pantalla completa
│       │   ├── empty_state_widget.dart      # Ilustración + mensaje para listas vacías
│       │   └── error_widget.dart            # Vista de error con opción de reintento
│       ├── product/
│       │   ├── product_card.dart            # Tarjeta de producto para grids y listas
│       │   ├── product_card_skeleton.dart   # Skeleton animado durante carga de productos
│       │   └── product_image_gallery.dart   # Carrusel de imágenes del detalle de producto
│       ├── cart/
│       │   ├── cart_item_tile.dart          # Fila de ítem en el carrito con controles de cantidad
│       │   └── cart_badge.dart              # Badge numérico sobre el ícono del carrito
│       └── home/
│           ├── category_chip.dart           # Chip de categoría para filtrado rápido
│           ├── banner_carousel.dart         # Carrusel de banners promocionales
│           └── section_header.dart          # Encabezado de sección con título y enlace "Ver todo"
│
├── test/
│   ├── unit/
│   │   ├── auth_service_test.dart
│   │   ├── cart_provider_test.dart
│   │   └── validators_test.dart
│   ├── widget/
│   │   ├── login_screen_test.dart
│   │   └── product_card_test.dart
│   └── integration/
│       └── auth_catalog_cart_flow_test.dart
│
├── pubspec.yaml
├── analysis_options.yaml
├── .env                            # Variables de entorno (NO se commitea a Git)
├── .gitignore
└── README.md
```

---

## Fase 3 — Configuración de Firebase

### 3.1 Creación del proyecto en Firebase Console

Registrar un nuevo proyecto con el nombre `muebleria-carrasco-app`. Habilitar Google Analytics para seguimiento de eventos de conversión y comportamiento de usuario. Activar los siguientes servicios desde el inicio del proyecto:

- **Authentication** — para gestión de sesiones de usuario.
- **Cloud Firestore** — base de datos NoSQL principal.
- **Firebase Storage** — almacenamiento de imágenes de productos.
- **Crashlytics** — monitoreo de crashes en producción.

### 3.2 Registro de plataformas

Registrar la aplicación para Android con el package name `com.carrasco.muebleria`. Descargar `google-services.json` y colocarlo en `android/app/`. Registrar para iOS con el Bundle ID `com.carrasco.muebleria`. Descargar `GoogleService-Info.plist` y colocarlo en `ios/Runner/`. Registrar para Web y copiar la configuración en el archivo de inicialización correspondiente.

### 3.3 Modelado de colecciones en Firestore

```
Firestore Database
│
├── users/{userId}
│   ├── displayName: string
│   ├── email: string
│   ├── phone: string
│   ├── address: string
│   └── createdAt: timestamp
│
├── categories/{categoryId}
│   ├── name: string
│   ├── description: string
│   └── imageUrl: string
│
├── products/{productId}
│   ├── name: string
│   ├── description: string
│   ├── price: number
│   ├── material: string
│   ├── categoryId: string (ref → categories)
│   ├── imageUrls: array<string>
│   ├── stock: number
│   └── isActive: boolean
│
├── orders/{orderId}
│   ├── userId: string (ref → users)
│   ├── status: string (pending|processing|shipped|delivered|cancelled)
│   ├── total: number
│   ├── createdAt: timestamp
│   ├── address: string
│   └── items: array<{productId, name, quantity, unitPrice, subtotal}>
│
└── carts/{userId}
    └── items: array<{productId, name, imageUrl, quantity, unitPrice}>
```

### 3.4 Reglas de seguridad de Firestore

Definir reglas de seguridad que permitan a cada usuario leer y escribir únicamente sus propios documentos en `users`, `carts` y `orders`. Los documentos de `products` y `categories` serán de solo lectura para usuarios autenticados. Ningún recurso será accesible para usuarios no autenticados. Las reglas de administrador se gestionarán con Firebase Custom Claims.

---

## Fase 4 — Dependencias (pubspec.yaml)

### 4.1 Dependencias de producción

| Paquete | Versión | Propósito |
|---------|---------|-----------|
| `firebase_core` | ^3.x | Inicialización del ecosistema Firebase |
| `firebase_auth` | ^5.x | Autenticación de usuarios |
| `cloud_firestore` | ^5.x | Base de datos NoSQL en tiempo real |
| `firebase_storage` | ^12.x | Almacenamiento de imágenes |
| `firebase_crashlytics` | ^4.x | Monitoreo de errores en producción |
| `provider` | ^6.x | Gestión de estado reactiva |
| `go_router` | ^14.x | Navegación declarativa con guardias |
| `cached_network_image` | ^3.x | Carga y cacheo eficiente de imágenes remotas |
| `flutter_svg` | ^2.x | Renderizado de iconos vectoriales |
| `intl` | ^0.19.x | Formateo de moneda MXN, fechas en español |
| `shared_preferences` | ^2.x | Persistencia local ligera |
| `image_picker` | ^1.x | Selección de foto de perfil |
| `shimmer` | ^3.x | Animación skeleton durante cargas |
| `flutter_dotenv` | ^5.x | Variables de entorno desde archivo .env |

### 4.2 Dependencias de desarrollo y testing

| Paquete | Propósito |
|---------|-----------|
| `flutter_lints` | Análisis estático con reglas estrictas |
| `mockito` | Mocks para tests unitarios de servicios |
| `flutter_test` | Framework de testing de widgets |
| `integration_test` | Tests de flujo completo (E2E) |
| `build_runner` | Generación de código para mocks |

---

## Fase 5 — Autenticación

### 5.1 AuthService

El servicio encapsulará toda interacción con `firebase_auth` exponiendo métodos asíncronos para: registro con correo y contraseña, inicio de sesión, cierre de sesión, restablecimiento de contraseña por correo, y un Stream de `User?` que emite cambios de estado de sesión en tiempo real.

### 5.2 AuthProvider

El `AuthProvider` escuchará el stream de `AuthService` y expondrá al árbol de widgets: el objeto `currentUser` nullable, el estado `isAuthenticated`, el estado `isLoading` durante operaciones en curso, y `errorMessage` para mostrar feedback en la UI. Manejará la persistencia automática de sesión sin que la pantalla de inicio tenga que verificarla.

### 5.3 Pantallas de autenticación

**LoginScreen:** campos de correo y contraseña con validación en tiempo real, botón de inicio de sesión con estado de carga, enlace a registro y enlace a recuperación de contraseña. Diseño centrado en tarjeta con logo de la marca en la parte superior, sobre fondo `#EBEEF2`.

**RegisterScreen:** campos de nombre completo, correo, contraseña y confirmación de contraseña. Validación de complejidad de contraseña (mínimo 8 caracteres, una mayúscula, un número). Feedback inmediato con indicadores visuales de fortaleza.

**ForgotPasswordScreen:** campo único de correo con instrucciones claras. Confirmación visual tras el envío del correo de restablecimiento.

### 5.4 Guardia de autenticación

`RouteGuard` implementado con `go_router` verificará el estado de `AuthProvider` en cada navegación. Redirigirá automáticamente a `/login` si no hay sesión activa, o a `/home` si el usuario ya está autenticado e intenta acceder a pantallas de auth.

---

## Fase 6 — Gestión de Estado con Provider

### 6.1 ProductProvider

Mantendrá la lista completa de productos como `List<ProductModel>`, el estado de carga, el término de búsqueda activo, los filtros seleccionados (categoría, rango de precio, material) y el criterio de ordenamiento. Expondrá un getter `filteredProducts` que aplica todos los filtros localmente sobre la lista cargada. Usará `StreamProvider` para actualizaciones en tiempo real desde Firestore.

### 6.2 CartProvider

Mantendrá el mapa de ítems del carrito `Map<String, CartItemModel>` con el `productId` como clave. Expondrá métodos para agregar, actualizar cantidad y eliminar ítems, y getters calculados para `itemCount` y `totalAmount`. Sincronizará el carrito con la colección `carts/{userId}` en Firestore usando debounce para evitar escrituras excesivas.

### 6.3 OrderProvider

Cargará el historial de pedidos del usuario autenticado ordenados por fecha descendente. Manejará la creación de nuevos pedidos usando transacciones de Firestore para actualizar simultáneamente el stock del producto y crear el documento del pedido, garantizando consistencia.

---

## Fase 7 — Pantallas y Navegación

### 7.1 Estructura de navegación

```
SplashScreen
    └── (sin sesión) ──→ LoginScreen
    │                        └── RegisterScreen
    │                        └── ForgotPasswordScreen
    └── (con sesión) ──→ Shell (BottomNavigationBar)
                             ├── HomeScreen
                             ├── CatalogScreen → ProductDetailScreen
                             ├── CartScreen → CheckoutScreen
                             └── ProfileScreen → OrdersScreen → OrderDetailScreen
```

La navegación interna al shell usará `go_router` con una `ShellRoute` para mantener el `BottomNavigationBar` persistente. La transición predeterminada entre pantallas será un fade de 200ms para mantener la sensación corporativa sobria.

### 7.2 HomeScreen

Estructura vertical con scroll: (1) `CustomAppBar` con logo y ícono de búsqueda, (2) `BannerCarousel` con banners promocionales de relación 16:9, (3) fila horizontal scrolleable de `CategoryChip`, (4) sección "Productos Destacados" con `GridView` de dos columnas y `ProductCard`, (5) sección "Nuevos Ingresos" con lista horizontal de `ProductCard` en formato compacto.

### 7.3 CatalogScreen

`CustomAppBar` con campo de búsqueda integrado y botón de filtros. Cuerpo con `GridView.builder` de dos columnas con `ProductCardSkeleton` durante la carga inicial. `FilterBottomSheet` modal que despliega controles para: categoría (chips selectables), rango de precio (RangeSlider) y material (checkboxes). Ordenamiento accesible desde el AppBar: relevancia, precio ascendente/descendente, más nuevos.

### 7.4 ProductDetailScreen

Carrusel de imágenes a pantalla completa con indicador de posición. Debajo: nombre del producto en tipografía 22sp peso 600, precio en `#4A7FA5` destacado, descripción en cuerpo regular, sección de especificaciones (material, dimensiones, colores) en tabla de dos columnas. Botón "Agregar al carrito" flotante fijo en la parte inferior, azul acero, con animación de confirmación al tocar.

### 7.5 CartScreen

Lista de `CartItemTile` con imagen miniatura, nombre, precio unitario y controles de cantidad (- cantidad +). Total calculado en tiempo real mostrado en una tarjeta fija al pie de pantalla junto al botón "Proceder al pago". Estado vacío con ilustración SVG y CTA "Ver catálogo".

---

## Fase 8 — Tema Global y Componentes Reutilizables

### 8.1 AppTheme

El archivo `app_theme.dart` definirá un único `ThemeData` con:

- `colorScheme` generado desde `ColorScheme.fromSeed` con seed `#3B4F6B`.
- `inputDecorationTheme` con bordes redondeados 8px, color de foco `#4A7FA5` y sin border filled por defecto.
- `elevatedButtonTheme` con padding vertical 14px, border radius 8px, color `#3B4F6B` y texto blanco peso 600.
- `cardTheme` con elevación 0, border radius 12px y `color: Colors.white` con borde sutil `#D1D9E0`.
- `appBarTheme` con fondo `#FFFFFF`, elevación 0, borde inferior sutil, iconos y texto en `#1E2A38`.
- `bottomNavigationBarTheme` con fondo blanco, ítem seleccionado en `#3B4F6B` e íconos no seleccionados en `#9AAABB`.

### 8.2 Componentes clave

**ProductCard:** tarjeta con imagen 4:3 con `cached_network_image`, nombre en máximo 2 líneas, precio formateado en MXN, badge de categoría y sombra sutil. Toca toda la superficie para navegar al detalle.

**CustomButton:** tres variantes configurables mediante parámetro enum: `filled` (fondo azul grisáceo), `outlined` (borde azul, fondo transparente) y `ghost` (solo texto). Todos gestionan el estado deshabilitado y el estado de carga con `CircularProgressIndicator` en miniatura.

**LoadingOverlay:** capa semitransparente con `CircularProgressIndicator` centrado. Se aplica como stack sobre la pantalla completa durante operaciones de red críticas (login, checkout).

**EmptyStateWidget:** imagen SVG ilustrativa, título configurable, subtítulo y botón de acción opcional. Usado en carrito vacío, historial de pedidos vacío y resultados de búsqueda sin coincidencias.

---

## Fase 9 — Pruebas

### 9.1 Tests unitarios

Cubrir el 100% de la lógica de `validators.dart`, los métodos de `formatters.dart`, la lógica de cálculo de totales en `CartProvider` y el mapeo de errores en `error_handler.dart`. Los servicios Firebase se testean usando mocks generados con `mockito` y `build_runner`.

### 9.2 Tests de widgets

Verificar que `LoginScreen` renderiza todos los campos, muestra errores de validación al intentar enviar el formulario vacío y llama al método correcto del `AuthProvider`. Verificar que `ProductCard` muestra correctamente el nombre, precio y responde al tap.

### 9.3 Tests de integración

Un flujo completo de prueba cubrirá: apertura de la app sin sesión, navegación a login, ingreso de credenciales, visualización del catálogo, apertura del detalle de un producto, agregarlo al carrito, verificar el conteo en el badge y navegar al carrito.

---

## Fase 10 — Seguridad y Optimización

### 10.1 Seguridad

Las claves y configuraciones sensibles se almacenan en un archivo `.env` ignorado por Git y cargado con `flutter_dotenv`. Las Firestore Security Rules se implementan en el repositorio bajo `/firestore.rules` y se versionan. Se habilitará App Check de Firebase para bloquear tráfico que no provenga de la app legítima en producción.

### 10.2 Optimización de rendimiento

Usar `const` en todos los widgets que no dependan de estado dinámico. Implementar `ListView.builder` y `GridView.builder` en lugar de constructores estáticos para listas largas. Paginar las consultas a Firestore usando `startAfterDocument` para no cargar el catálogo completo de una vez. Implementar `RepaintBoundary` alrededor de componentes de animación para aislar el repintado.

### 10.3 Optimización de assets

Comprimir todas las imágenes estáticas antes de incluirlas. Usar SVG para todos los iconos. Cargar fuentes solo con los pesos necesarios (400, 500, 600, 700). Para el build de Android, usar `--split-per-abi` para reducir el tamaño del APK. Configurar splash screen nativo con `flutter_native_splash` para eliminar el flash blanco al inicio.

---

## Fase 11 — Build y Despliegue

### 11.1 Configuración de builds

Definir tres flavors de la aplicación: `development` (conectado a proyecto Firebase de desarrollo, banner de debug visible), `staging` (proyecto Firebase de staging, para QA interno) y `production` (proyecto Firebase de producción, sin indicadores de debug).

### 11.2 Distribución

Para Android: generar AAB firmado con la keystore del proyecto y publicar en Google Play Console. Para iOS: generar IPA con certificado de distribución y subir a App Store Connect. Para Web: ejecutar `flutter build web --release` y desplegar en Firebase Hosting con configuración de SPA (rewrite de todas las rutas a `index.html`).

### 11.3 Monitoreo post-lanzamiento

Activar Crashlytics para reportes automáticos de errores en producción. Configurar Firebase Performance Monitoring para medir tiempos de carga de pantallas críticas (catálogo, checkout). Revisar el panel de Crashlytics en las primeras 48 horas tras cada release. Establecer un ciclo de actualización quincenal para correcciones y mensual para nuevas funcionalidades.

---

## Alcances Futuros (V2)

- Panel de administración web para gestión de productos, categorías e inventario.
- Integración con pasarela de pagos (Conekta o Stripe México).
- Notificaciones push con Firebase Cloud Messaging para actualizaciones de pedidos y promociones.
- Modo offline con Firestore persistence y sincronización al recuperar conexión.
- Galería de productos con realidad aumentada (AR Quick Look en iOS, Scene Viewer en Android).
- Sistema de reseñas y calificaciones de productos.
- Programa de puntos y fidelización de clientes.

---

*Plan de Implementación — Mueblería Carrasco — v1.0*
