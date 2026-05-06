import 'dart:ui';

class LocaleUtils {
  const LocaleUtils._();

  /// Convierte un [Locale] al nombre de idioma que acepta la API de restcountries.
  /// Ej: Locale('es') → 'spanish', Locale('en') → 'english'
  static String toLang(Locale locale) => switch (locale.languageCode) {
    'es' => 'spanish',
    _ => 'english',
  };
}
