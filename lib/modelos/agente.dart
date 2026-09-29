// PASO 2 · PERSONA A (datos) — actualizado en el PASO 3 (campo "guia")
// y en el PASO 5 (API: códigos, idApi, desdeApi y combinarCon).
// El "modelo" de un agente: qué información tiene cada uno.
import 'package:flutter/material.dart';

import '../datos/codigos_api.dart';
import '../tema.dart';
import 'guia_agente.dart';

// "enum" = una lista cerrada de opciones. Así no podemos escribir mal
// "Hielo" en un sitio y "hielo " en otro: solo existen estas.
// Son "enums mejorados": cada opción lleva además su nombre bonito, su color
// y (PASO 5) el número con el que la identifica la API.

enum Rango {
  s('S', ColoresApp.acento, 4),
  a('A', Color(0xFFB9A6FF), 3);

  const Rango(this.nombre, this.color, this.codigoApi);
  final String nombre;
  final Color color;
  final int codigoApi;

  // "static" = se llama sobre el enum, no sobre una opción: Rango.desdeCodigo(4)
  // Devuelve null si la API manda un número que no conocemos.
  static Rango? desdeCodigo(int codigo) {
    for (final r in Rango.values) {
      if (r.codigoApi == codigo) return r;
    }
    return null;
  }
}

enum Elemento {
  hielo('Hielo', ColoresApp.hielo, 202),
  fuego('Fuego', ColoresApp.fuego, 201),
  electrico('Eléctrico', ColoresApp.electrico, 203),
  eter('Éter', ColoresApp.eter, 205),
  fisico('Físico', ColoresApp.fisico, 200),
  viento('Viento', ColoresApp.viento, 204),       // PASO 5: nuevo
  lumiflux('Lumiflux', ColoresApp.lumiflux, 300); // PASO 5: nuevo

  const Elemento(this.nombre, this.color, this.codigoApi);
  final String nombre;
  final Color color;
  final int codigoApi;

  static Elemento? desdeCodigo(int codigo) {
    for (final e in Elemento.values) {
      if (e.codigoApi == codigo) return e;
    }
    return null;
  }
}

enum Especialidad {
  ataque('Ataque', 1),
  aturdimiento('Aturdimiento', 2),
  anomalia('Anomalía', 3),
  apoyo('Apoyo', 4),
  defensa('Defensa', 5),
  ruptura('Ruptura', 6), // PASO 5: nuevo
  armero('Armero', 7);   // PASO 5: nuevo ("Armorer" en inglés)

  const Especialidad(this.nombre, this.codigoApi);
  final String nombre;
  final int codigoApi;

  static Especialidad? desdeCodigo(int codigo) {
    for (final e in Especialidad.values) {
      if (e.codigoApi == codigo) return e;
    }
    return null;
  }
}

class Agente {
  const Agente({
    required this.id,
    required this.nombre,
    required this.rango,
    required this.elemento,
    required this.especialidad,
    required this.faccion,
    this.guia,  // PASO 3: opcional, no todos los agentes tienen guía todavía
    this.idApi, // PASO 5: el número del agente en la API (ej: Ellen = 1191)
    this.urlImagen, // PASO 6: icono del agente en internet (puede ser null)
  });

  final String id;
  final String nombre;
  final Rango rango;
  final Elemento elemento;
  final Especialidad especialidad;
  final String faccion;
  final GuiaAgente? guia; // "?" = puede ser null (sin guía)
  final int? idApi;
  final String? urlImagen;

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

  // PASO 5: crea un Agente a partir de un agente de la API.
  // La API manda algo así (solo los campos que usamos):
  //   "1191": { "EN": "Ellen", "rank": 4, "type": 1, "element": 202, "camp": 2 }
  // Devuelve null si trae algún código que todavía no conocemos,
  // así un agente "raro" no rompe toda la app.
  static Agente? desdeApi(String idApi, Map<String, dynamic> json) {
    // "as int?" = puede venir un número o null (algunos personajes, como
    // los protagonistas, no tienen rango ni elemento).
    final codigoRango = json['rank'] as int?;
    final codigoElemento = json['element'] as int?;
    final codigoTipo = json['type'] as int?;
    if (codigoRango == null || codigoElemento == null || codigoTipo == null) {
      return null;
    }

    final rango = Rango.desdeCodigo(codigoRango);
    final elemento = Elemento.desdeCodigo(codigoElemento);
    final especialidad = Especialidad.desdeCodigo(codigoTipo);
    if (rango == null || elemento == null || especialidad == null) {
      return null;
    }

    // "??" = si lo de la izquierda es null, usa lo de la derecha.
    final nombre = (json['EN'] ?? json['code']) as String;

    // PASO 6: la API manda el nombre del icono ("icon": "IconRole21") y la
    // imagen está en: https://static.nanoka.cc/assets/zzz/IconRole21.webp
    final icono = json['icon'] as String?;

    return Agente(
      urlImagen: icono == null ? null : '$urlImagenesApi/$icono.webp',
      id: crearId(nombre),
      nombre: nombre,
      rango: rango,
      elemento: elemento,
      especialidad: especialidad,
      faccion: faccionesApi[json['camp']] ?? 'Desconocida',
      idApi: int.parse(idApi),
    );
  }

  // PASO 5: junta este agente (de la API) con el nuestro del JSON local.
  // De la API nos fiamos para los datos del juego (rango, elemento...),
  // y del JSON local cogemos lo que es "nuestro": el nombre completo y la guía.
  Agente combinarCon(Agente local) {
    return Agente(
      id: id,
      nombre: local.nombre,
      rango: rango,
      elemento: elemento,
      especialidad: especialidad,
      faccion: faccion,
      guia: local.guia,
      idApi: idApi,
      urlImagen: urlImagen, // PASO 6: la imagen de internet la conservamos
    );
  }

  // PASO 5: "Zhu Yuan" -> "zhu_yuan". Así el id coincide con el nombre de
  // la imagen (zhu_yuan.png) y con los ids de nuestro agentes.json.
  // RegExp = "expresión regular", un patrón para buscar texto:
  //   [^a-z0-9]+  -> cualquier grupo de caracteres que NO sea letra o número
  //   ^_+|_+$     -> guiones bajos al principio o al final
  static String crearId(String nombre) {
    return nombre
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }

  // "get" = una propiedad calculada. "Ellen Joe" -> "EJ".
  String get iniciales {
    final palabras = nombre.split(' ').where((p) => p.isNotEmpty);
    return palabras.take(2).map((p) => p[0]).join().toUpperCase();
  }
}
