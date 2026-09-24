// PASO 2 · PERSONA A (datos)
// El "repositorio" es quien sabe DE DÓNDE salen los datos.
// Hoy los leemos de un archivo JSON dentro de la app. Si mañana vienen de
// internet (Firebase, una API...), solo cambiamos este archivo y las
// pantallas siguen igual.
import 'dart:convert';

import 'package:flutter/services.dart';

import '../modelos/agente.dart';

class RepositorioAgentes {
  // "Future" = un valor que llegará más tarde (leer un archivo tarda un poco).
  // "async" / "await" = esperar a que llegue sin bloquear la app.
  static Future<List<Agente>> cargar() async {
    final texto = await rootBundle.loadString('assets/datos/agentes.json');
    final lista = jsonDecode(texto) as List<dynamic>;
    return lista
        .map((elemento) => Agente.fromJson(elemento as Map<String, dynamic>))
        .toList();
  }
}
