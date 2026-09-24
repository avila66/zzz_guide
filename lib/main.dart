// Punto de entrada de la app. Flutter empieza a ejecutar desde main().
import 'package:flutter/material.dart';

import 'pantallas/navegacion.dart';
import 'tema.dart';

void main() {
  // runApp() recibe el widget "raíz" de toda la aplicación.
  runApp(const GuiaZzzApp());
}

// StatelessWidget = un widget que no cambia por sí solo (no tiene estado).
class GuiaZzzApp extends StatelessWidget {
  const GuiaZzzApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp configura la app: título, tema (colores) y la primera pantalla.
    return MaterialApp(
      title: 'Guía ZZZ',
      debugShowCheckedModeBanner: false, // quita la etiqueta "DEBUG" de la esquina
      theme: temaApp,                    // definido en tema.dart
      home: const Navegacion(),          // la pantalla con la barra de abajo
    );
  }
}
