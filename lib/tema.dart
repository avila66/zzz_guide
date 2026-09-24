// Aquí guardamos los colores y el tema de la app en un solo sitio.
// Si mañana queréis cambiar el amarillo por otro color, solo lo tocáis aquí.
import 'package:flutter/material.dart';

class ColoresApp {
  // "static const" = valores fijos a los que se accede sin crear un objeto:
  // ColoresApp.acento, ColoresApp.fondo...
  static const Color fondo = Color(0xFF0F1012);
  static const Color superficie = Color(0xFF1A1C20); // fondo de tarjetas
  static const Color borde = Color(0xFF2C2F35);
  static const Color barraNavegacion = Color(0xFF141518);
  static const Color acento = Color(0xFFE6F23A); // amarillo principal
  static const Color textoOscuro = Color(0xFF141413); // texto sobre el amarillo
  static const Color texto = Color(0xFFECEAE4);
  static const Color textoSecundario = Color(0xFFA09E97);

  // Colores de los elementos (los usaremos en la pantalla de Agentes).
  static const Color hielo = Color(0xFF7CC8F2);
  static const Color fuego = Color(0xFFFF8A4C);
  static const Color electrico = Color(0xFF8FA8FF);
  static const Color eter = Color(0xFFFF6FAE);
  static const Color fisico = Color(0xFFF0C04A);
}

// El tema oscuro de toda la app.
final ThemeData temaApp = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: ColoresApp.fondo,
  colorScheme: const ColorScheme.dark(
    primary: ColoresApp.acento,
    onPrimary: ColoresApp.textoOscuro,
    // La "pastilla" que marca la pestaña activa en la barra de abajo:
    secondaryContainer: ColoresApp.acento,
    onSecondaryContainer: ColoresApp.textoOscuro,
    surface: ColoresApp.superficie,
    onSurface: ColoresApp.texto,
  ),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: ColoresApp.barraNavegacion,
  ),
);
