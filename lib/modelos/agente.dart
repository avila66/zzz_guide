// PASO 2 · PERSONA A (datos) — actualizado en el PASO 3 (campo "guia")
// El "modelo" de un agente: qué información tiene cada uno.
import 'package:flutter/material.dart';

import '../tema.dart';
import 'guia_agente.dart';

// "enum" = una lista cerrada de opciones. Así no podemos escribir mal
// "Hielo" en un sitio y "hielo " en otro: solo existen estas.
// Son "enums mejorados": cada opción lleva además su nombre bonito y su color.

enum Rango {
  s('S', ColoresApp.acento),
  a('A', Color(0xFFB9A6FF));

  const Rango(this.nombre, this.color);
  final String nombre;
  final Color color;
}

enum Elemento {
  hielo('Hielo', ColoresApp.hielo),
  fuego('Fuego', ColoresApp.fuego),
  electrico('Eléctrico', ColoresApp.electrico),
  eter('Éter', ColoresApp.eter),
  fisico('Físico', ColoresApp.fisico);

  const Elemento(this.nombre, this.color);
  final String nombre;
  final Color color;
}

enum Especialidad {
  ataque('Ataque'),
  anomalia('Anomalía'),
  aturdimiento('Aturdimiento'),
  apoyo('Apoyo'),
  defensa('Defensa');

  const Especialidad(this.nombre);
  final String nombre;
}

class Agente {
  const Agente({
    required this.id,
    required this.nombre,
    required this.rango,
    required this.elemento,
    required this.especialidad,
    required this.faccion,
    this.guia, // PASO 3: opcional, no todos los agentes tienen guía todavía
  });

  final String id;
  final String nombre;
  final Rango rango;
  final Elemento elemento;
  final Especialidad especialidad;
  final String faccion;
  final GuiaAgente? guia; // "?" = puede ser null (sin guía)

  // "factory" = un constructor que crea el objeto a partir de otra cosa,
  // aquí a partir de un trozo del JSON (un Map con claves y valores).
  // values.byName('hielo') busca la opción del enum que se llama así.
  factory Agente.fromJson(Map<String, dynamic> json) {
    return Agente(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      rango: Rango.values.byName(json['rango'] as String),
      elemento: Elemento.values.byName(json['elemento'] as String),
      especialidad: Especialidad.values.byName(json['especialidad'] as String),
      faccion: json['faccion'] as String,
      // Si el JSON trae "guia", la leemos; si no, se queda en null.
      guia: json['guia'] == null
          ? null
          : GuiaAgente.fromJson(json['guia'] as Map<String, dynamic>),
    );
  }

  // "get" = una propiedad calculada. "Ellen Joe" -> "EJ".
  String get iniciales {
    final palabras = nombre.split(' ');
    return palabras.take(2).map((p) => p[0]).join().toUpperCase();
  }
}
