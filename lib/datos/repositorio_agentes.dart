// PASO 2 · PERSONA A — reescrito en el PASO 5 · PERSONA B (API)
// El "repositorio" es quien sabe DE DÓNDE salen los datos.
// Como las pantallas solo llaman a RepositorioAgentes.cargar(),
// ninguna pantalla se entera de que ahora los datos vienen de internet.
//
// Cómo funciona ahora:
//   1. Lee nuestro JSON local (nombres completos y guías).
//   2. Intenta descargar la lista completa de agentes de la API.
//   3. Si la descarga va bien, junta las dos cosas.
//      Si falla (sin internet, la API caída...), usa solo el JSON local.
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../modelos/agente.dart';

class RepositorioAgentes {
  // API no oficial de la comunidad (Hakush.in). Puede cambiar o caerse:
  // por eso siempre tenemos el plan B del JSON local.
  // (Antes estaba en api.hakush.in; se mudó a static.nanoka.cc.)
  // Funciona en dos pasos:
  //   1. manifest.json  -> nos dice qué versión del juego está activa (ej: "2.3")
  //   2. zzz/<versión>/character.json -> la lista de agentes de esa versión
  static const String _urlBase = 'https://static.nanoka.cc';

  // PASO 7: "caché". Guardamos la carga la primera vez que alguien la pide.
  // Así, si Agentes y Tier list llaman los dos a cargar(), solo se descarga
  // UNA vez de internet. "??=" = "si es null, asígnale esto".
  static Future<List<Agente>>? _cache;

  static Future<List<Agente>> cargar() {
    return _cache ??= _cargarSinCache();
  }

  static Future<List<Agente>> _cargarSinCache() async {
    final locales = await _cargarLocales();

    // try / catch = "intenta esto, y si algo sale mal, haz esto otro"
    // en vez de que la app se cierre con un error.
    try {
      final deApi = await _descargarDeApi();
      return _combinar(deApi, locales);
    } catch (error) {
      // debugPrint escribe en la consola de "flutter run" (no lo ve el usuario).
      debugPrint('No se pudo usar la API ($error). Uso solo los datos locales.');
      return locales;
    }
  }

  // Nuestro JSON de siempre (el de assets/datos/agentes.json).
  static Future<List<Agente>> _cargarLocales() async {
    final texto = await rootBundle.loadString('assets/datos/agentes.json');
    final lista = jsonDecode(texto) as List<dynamic>;
    return lista
        .map((elemento) => Agente.fromJson(elemento as Map<String, dynamic>))
        .toList();
  }

  // Descarga una URL y devuelve el JSON ya convertido a Map.
  static Future<Map<String, dynamic>> _descargarJson(String url) async {
    // http.get hace la petición. timeout: si en 10 segundos no responde,
    // salta un error (y el catch de cargar() usa el JSON local).
    final respuesta = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 10));

    // 200 = "todo bien". Cualquier otro código (404, 500...) es un error.
    if (respuesta.statusCode != 200) {
      throw Exception('$url respondió con código ${respuesta.statusCode}');
    }
    return jsonDecode(respuesta.body) as Map<String, dynamic>;
  }

  static Future<List<Agente>> _descargarDeApi() async {
    // Paso 1: ¿qué versión del juego está activa?
    // El manifest es algo así: { "zzz": { "live": "2.3", "latest": "2.4", ... }, ... }
    final manifest = await _descargarJson('$_urlBase/manifest.json');
    final infoZzz = manifest['zzz'] as Map<String, dynamic>;
    final version = infoZzz['live'] as String;

    // Paso 2: la lista de agentes de esa versión.
    // Es un Map: { "1191": {...Ellen...}, "1091": {...Miyabi...} }
    // La clave es el id del agente en la API; el valor, sus datos.
    final datos = await _descargarJson('$_urlBase/zzz/$version/character.json');

    final agentes = <Agente>[];
    datos.forEach((idApi, valor) {
      final agente = Agente.desdeApi(idApi, valor as Map<String, dynamic>);
      if (agente != null) {
        agentes.add(agente);
      } else {
        debugPrint('Agente $idApi ignorado: tiene un código que no conocemos.');
      }
    });
    return agentes;
  }

  static List<Agente> _combinar(List<Agente> deApi, List<Agente> locales) {
    // Map por id para buscar rápido: {"ellen": Agente(...), ...}
    final localesPorId = {for (final a in locales) a.id: a};

    final combinados = deApi.map((agenteApi) {
      final local = localesPorId[agenteApi.id];
      // Si lo tenemos en local, le ponemos nuestro nombre completo y la guía.
      return local == null ? agenteApi : agenteApi.combinarCon(local);
    }).toList();

    // Por si algún agente local no existe en la API (id escrito distinto),
    // lo añadimos igualmente para no perderlo.
    final idsApi = deApi.map((a) => a.id).toSet();
    combinados.addAll(locales.where((a) => !idsApi.contains(a.id)));

    // Ordenamos: primero los S, luego los A; dentro de cada grupo, los más
    // nuevos primero (el idApi más alto es el más reciente).
    combinados.sort((a, b) {
      if (a.rango != b.rango) return a.rango.index - b.rango.index;
      return (b.idApi ?? 0) - (a.idApi ?? 0);
    });
    return combinados;
  }
}
