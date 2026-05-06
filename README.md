# flutter_wigilabs_sr

Prueba técnica – Explorador de países de Europa con BLoC, Drift y Dio.

## 🌐 Demo en vivo

**Web App:** [https://andresroviram.github.io/flutter_wigilabs_sr/](https://andresroviram.github.io/flutter_wigilabs_sr/)

La aplicación está desplegada automáticamente en GitHub Pages mediante GitHub Actions.

## Screenshots

### Mobile (Light Theme)
<br>
<p align="center">
<img src="screenshots/mobile/Screenshot_1771544371.png" width="30%">
<img src="screenshots/mobile/Screenshot_1771544373.png" width="30%">
<img src="screenshots/mobile/Screenshot_1771544394.png" width="30%">
</p>

### Mobile (Dark Theme)
<br>
<p align="center">
<img src="screenshots/mobile/Screenshot_1771544419.png" width="30%">
<img src="screenshots/mobile/Screenshot_1771544421.png" width="30%">
<img src="screenshots/mobile/Screenshot_1771544398.png" width="30%">
</p>

### Web (Light Theme)
<br>
<p align="center">
<img src="screenshots/web/Screenshot_19-2-2026_182939_localhost.jpeg" width="45%">
<img src="screenshots/web/Screenshot_19-2-2026_183136_localhost.jpeg" width="45%">
<img src="screenshots/web/Screenshot_19-2-2026_183254_localhost.jpeg" width="45%">
<img src="screenshots/web/Screenshot_19-2-2026_183346_localhost.jpeg" width="45%">
</p>

### Web (Dark Theme)
<br>
<p align="center">
<img src="screenshots/web/Screenshot_19-2-2026_183514_localhost.jpeg" width="45%">
<img src="screenshots/web/Screenshot_19-2-2026_183538_localhost.jpeg" width="45%">
<img src="screenshots/web/Screenshot_19-2-2026_18369_localhost.jpeg" width="45%">
<img src="screenshots/web/Screenshot_19-2-2026_183626_localhost.jpeg" width="45%">
</p>

## Using on this app

- Clean Architecture
- BLoC (flutter_bloc)
- go_router
- GetIt / Injectable
- freezed
- json_serializable
- Dio (HTTP Client) + interceptores
- Exception Handling (Custom Error Management)
- Drift (SQLite Database)
- Performance Optimization (Jank Detection & Prevention)
- easy_localization
- adaptive_theme
- bot_toast
- cached_network_image
- [REST Countries API](https://restcountries.com/)

## Clean Architecture

Este proyecto implementa Clean Architecture con la siguiente estructura de capas:

- **Presentation Layer**: UI components, BLoC state management
- **Domain Layer**: Use cases, entities, repository interfaces
- **Data Layer**: Repository implementations, data sources (remote & local), models

<br>
<p align="center">
<img src="screenshots/Clean Architecture Bloc - Flutter.jpg" width="80%">
</p>

## Project Structure

```
lib/
├── main.dart
├── my_app.dart
├── components/         # UI components reutilizables
├── config/             # Configuración de la app
├── core/               # Utilidades y core features
└── modules/            # Módulos de características
    └── [feature]/
        ├── data/
        ├── domain/
        └── presentation/
```

## How to use

Para clonar y ejecutar esta aplicación, necesitarás tener [Git](https://git-scm.com/downloads) y [Flutter](https://flutter.dev/docs/get-started/install) instalados en tu computadora. Desde tu línea de comandos:

```bash
# Clonar este repositorio
$ git clone https://github.com/yourusername/flutter_wigilabs_sr.git

# Ir al directorio del repositorio
$ cd flutter_wigilabs_sr

# Instalar dependencias
$ flutter pub get

# Crear archivo .env en la raíz del proyecto
$ API_KEY=''
$ BASE_URL='https://restcountries.com/v3.1'

# Generar código
$ dart run build_runner build --delete-conflicting-outputs

# Ejecutar la aplicación
$ flutter run

# Para web
$ flutter run -d chrome
```

## CI/CD & Despliegue

El proyecto cuenta con workflows automatizados de CI/CD configurados con GitHub Actions:

### 🔄 Continuous Integration (CI)

**Workflow:** `.github/workflows/ci.yml`

Se ejecuta automáticamente en cada push y pull request:

- ✅ Instalación de dependencias
- ✅ Generación de código (build_runner)
- ✅ Verificación de formato de código
- ✅ Análisis estático con flutter analyze
- ✅ Ejecución de tests con cobertura
- ✅ Reporte de cobertura a Codecov
- ✅ Verificación de umbral de cobertura (60%)

### 🚀 Despliegue Web

**Workflow:** `.github/workflows/deploy-web.yml`

**URL de producción:** [https://andresroviram.github.io/flutter_wigilabs_sr/](https://andresroviram.github.io/flutter_wigilabs_sr/)

Se ejecuta automáticamente al hacer push a `main` o `develop`:

- ✅ Build de la aplicación web con Flutter
- ✅ Ejecución de tests
- ✅ Despliegue automático a GitHub Pages
- ✅ Configuración opcional para Firebase Hosting y Vercel

### 📱 Despliegue Android

**Workflow:** `.github/workflows/deploy-android.yml`

Despliega a Google Play Store (Internal/Beta/Production) cuando se hace push a `main` o ramas `release/*`:

- ✅ Build de APK/AAB firmado
- ✅ Fastlane para automatización
- ✅ Despliegue a diferentes tracks de Play Store

### 🍎 Despliegue iOS

**Workflow:** `.github/workflows/deploy-ios.yml`

Despliega a TestFlight/App Store cuando se hace push a `main` o ramas `release/*`:

- ✅ Build de IPA firmado
- ✅ Fastlane para automatización
- ✅ Gestión de certificados con match
- ✅ Despliegue a TestFlight o App Store

### 📋 Configuración de Secrets

Para que los workflows funcionen correctamente, configura los siguientes secrets en GitHub:

**General:**
- `API_KEY` - (Opcional) API key si es requerida
- `BASE_URL` - Base URL de la API (default: https://restcountries.com/v3.1)

**Android:**
- `ANDROID_KEYSTORE_BASE64` - Keystore codificado en base64
- `KEYSTORE_PASSWORD` - Contraseña del keystore
- `KEY_ALIAS` - Alias de la key
- `KEY_PASSWORD` - Contraseña de la key
- `PLAY_STORE_CONFIG_JSON` - Credenciales de servicio de Google Play

**iOS:**
- `MATCH_PASSWORD` - Contraseña para match (certificados)
- `MATCH_GIT_BASIC_AUTHORIZATION` - Autorización para repositorio de certificados
- `FASTLANE_USER` - Usuario de Apple Developer
- `FASTLANE_PASSWORD` - Contraseña de Apple ID
- `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` - Contraseña específica de app
- `APP_STORE_CONNECT_API_KEY_ID` - ID de la API key de App Store Connect
- `APP_STORE_CONNECT_API_ISSUER_ID` - Issuer ID de App Store Connect
- `APP_STORE_CONNECT_API_KEY` - API Key de App Store Connect

**Coverage:**
- `CODECOV_TOKEN` - Token para reportar cobertura a Codecov

## Features

- 🌍 Explorador de países de Europa
- 🔍 Búsqueda y filtrado de países
- 💾 Almacenamiento local con Drift (SQLite)
- 🌐 Soporte multi-idioma (Español/Inglés)
- 🎨 Tema claro/oscuro adaptativo
- 📱 Diseño responsive (Mobile, Tablet, Web)
- ⚡ Caché de imágenes
- 🔄 Manejo de estados con BLoC
- 🌐 Peticiones HTTP con Dio e interceptores
- ⚠️ Manejo robusto de excepciones y errores
- 🚀 Optimización de performance (detección y prevención de janks)
