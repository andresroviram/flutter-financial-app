# flutter_wigilabs_sr

Prueba técnica – Explorador de países de Europa con BLoC, Drift y Dio.

## Screenshots

### Mobile (Light Theme)
<br>
<p align="center">
<img src="screenshots/mobile/Screenshot_1771536327.png" width="30%">
<img src="screenshots/mobile/Screenshot_1771536333.png" width="30%">
<img src="screenshots/mobile/Screenshot_1771536358.png" width="30%">
</p>

### Mobile (Dark Theme)
<br>
<p align="center">
<img src="screenshots/mobile/Screenshot_1771536507.png" width="30%">
<img src="screenshots/mobile/Screenshot_1771536400.png" width="30%">
<img src="screenshots/mobile/Screenshot_1771536422.png" width="30%">
</p>

### Web (Light Theme)
<br>
<p align="center">
<img src="screenshots/web/Screenshot_19-2-2026_16144_localhost.jpeg" width="45%">
<img src="screenshots/web/Screenshot_19-2-2026_161453_localhost.jpeg" width="45%">
<img src="screenshots/web/Screenshot_19-2-2026_161536_localhost.jpeg" width="45%">
<img src="screenshots/web/Screenshot_19-2-2026_161557_localhost.jpeg" width="45%">
</p>

### Web (Dark Theme)
<br>
<p align="center">
<img src="screenshots/web/Screenshot_19-2-2026_161827_localhost.jpeg" width="45%">
<img src="screenshots/web/Screenshot_19-2-2026_161927_localhost.jpeg" width="45%">
<img src="screenshots/web/Screenshot_19-2-2026_161842_localhost.jpeg" width="45%">
<img src="screenshots/web/Screenshot_19-2-2026_16187_localhost.jpeg" width="45%">
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

<br>
<p align="center">
<img src="screenshots/Clean Architecture Bloc - Flutter.jpg" width="80%">
</p>

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
