# 🛋️ Plan de Implementación: Ecosistema Mueblería Carrasco V2

**Stack:** Flutter Web/Mobile + Firebase Console (Auth, Firestore, Storage)
**Metodología:** Desarrollo por Capas (Clean Architecture)

---

## 🎨 1. Sistema de Diseño (Estética Slate & Steel)

Orientado a un entorno administrativo serio, limpio y eficiente.

| Elemento | Color | Hex | Aplicación |
| --- | --- | --- | --- |
| **Primary** | Azul Medianoche | `#1E293B` | Sidebars, AppBars y navegación principal. |
| **Secondary** | Azul Grisáceo | `#475569` | Encabezados de tablas y botones secundarios. |
| **Accent** | Azul Eléctrico | `#3B82F6` | Acciones de "Guardar", "Nuevo" y estados activos. |
| **Background** | Gris Humo | `#F8FAFC` | Fondo general de la plataforma. |
| **Surface** | Blanco Puro | `#FFFFFF` | Tarjetas, formularios y celdas de tabla. |
| **Border** | Gris Platino | `#E2E8F0` | Líneas divisorias e inputs. |

---

## 🏗️ 2. Configuración en Firebase Console (V2)

Pasos críticos para asegurar una infraestructura de grado empresarial:

1. **Proyecto:** Crear `Muebleria Carrasco V2` en la consola.
2. **Authentication:** Habilitar **Correo/Contraseña**. Configurar plantillas de correo con el color `#1E293B`.
3. **Firestore Database:** * Crear en **Modo Producción**.
* Configurar las 11 colecciones basadas en tu diagrama (Ver sección 3).


4. **Storage:** Habilitar para fotos de productos. Estructura: `/productos`, `/categorias`.
5. **Hosting:** Configurar para desplegar el panel de administración web.

---

## 📊 3. Arquitectura de Datos Normalizada

Cada entidad de tu diagrama ER se traduce en una colección independiente en Firestore para permitir un mantenimiento modular.

* **Gestión Humana:** `CLIENTE`, `EMPLEADO`.
* **Logística:** `PROVEEDORES`, `ALMACEN`, `INVENTARIO`.
* **Catálogo:** `CATEGORIA`, `PRODUCTO`.
* **Ventas y Finanzas:** `PEDIDO`, `DETALLE_PEDIDO`, `FACTURA`, `PAGO`.

---

## 🚀 4. Flujo de Usuario y Pantallas

### **Fase A: Acceso y Seguridad**

* **Splash Screen:** Pantalla de carga con el logo y `LoadingAnimationWidget`. Verifica si el token de sesión sigue activo.
* **Admin Login:** Formulario estilizado con validaciones. Solo permite acceso a correos registrados en la base de empleados con rol administrativo.

### **Fase B: Menú de Administración (Dashboard)**

Pantalla principal tras el login. Presenta un **Grid View** de botones (Cards) representando cada tabla:

* Cada botón incluye un icono de *FontAwesome* y el nombre de la tabla (ej: "Gestión de Productos").
* Colores aplicados: Fondo `#FFFFFF`, iconos y texto en `#1E293B`.

### **Fase C: Módulo CRUD Universal**

Cada tabla seleccionada abre una vista con:

1. **Read:** Tabla con búsqueda de documentos.
2. **Create/Update:** Formulario con Dropdowns vinculados (ej: al crear un `PRODUCTO`, el campo `id_categoria` muestra los nombres de la tabla `CATEGORIA`).
3. **Delete:** Borrado lógico o físico con advertencia de seguridad.

---

## 🗺️ 5. Mapa de Navegación del Sistema

* **Inicio:** `Splash Screen` ➔ (Verificación de Auth)
* **Acceso:** `Login Admin` (Si no hay sesión)
* **Principal:** `Menú de Tablas (Dashboard)`
* ➔ **Módulo Clientes** ➔ [CRUD]
* ➔ **Módulo Empleados** ➔ [CRUD]
* ➔ **Módulo Productos** ➔ [CRUD]
* ➔ **Módulo Inventario** ➔ [CRUD]
* ➔ **Módulo Almacenes** ➔ [CRUD]
* ➔ **Módulo Proveedores** ➔ [CRUD]
* ➔ **Módulo Ventas (Pedidos/Facturas/Pagos)** ➔ [CRUD]



---

## 📂 6. Estructura de Proyecto (Antigravity/Flutter)

```text
lib/
├── core/                        # Configuración global
│   ├── constants/               # app_colors.dart, app_themes.dart
│   └── widgets/                 # custom_button.dart, custom_input.dart
├── data/                        # Conexión con Firebase V2
│   ├── models/                  # ProductoModel.dart, FacturaModel.dart, etc.
│   └── services/                # auth_service.dart + 1 service por tabla
├── providers/                   # Lógica de estado (Provider)
│   ├── auth_provider.dart
│   └── admin_provider.dart      # Maneja la carga de las 11 tablas
├── screens/
│   ├── splash/                  # splash_screen.dart
│   ├── auth/                    # login_screen.dart
│   ├── menu/                    # dashboard_screen.dart (Botones de acceso)
│   └── tables/                  # Vistas CRUD (producto_view.dart, etc.)
└── main.dart

```

---

## 📦 7. Dependencias (`pubspec.yaml`)

```yaml
dependencies:
  # Firebase Core
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
  firebase_storage: ^12.0.0

  # UI & UX
  provider: ^6.1.2                # Gestión de estado
  go_router: ^14.2.0              # Navegación profesional
  font_awesome_flutter: ^10.7.0   # Iconografía para el menú
  google_fonts: ^6.2.1            # Tipografía "Inter"
  intl: ^0.19.0                   # Formatos de moneda y fecha
  loading_animation_widget: ^1.2.1 # Splash profesional

```

---

## ✅ 8. Checklist de Calidad

* [ ] **Persistencia:** El login debe mantenerse tras refrescar la página (Web).
* [ ] **Integridad:** No permitir borrar una `CATEGORIA` si tiene `PRODUCTOS` asociados.
* [ ] **Diseño:** Todas las pantallas deben usar la paleta `#1E293B` y `#475569`.
* [ ] **Responsivo:** El menú de botones debe ajustarse de 4 columnas (Web) a 2 columnas (Móvil).
