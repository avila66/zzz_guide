// PASO 7 · PERSONA A (datos)
// Lee la tier list de assets/datos/tierlist.json.
// Es el mismo patrón que el repositorio de agentes del paso 2.
import 'dart:convert';

import 'package:flutter/services.dart';

import '../modelos/tier_list.dart';

class RepositorioTierList {
  static Future<List<ModoTierList>> cargar() async {
    final texto = await rootBundle.loadString('assets/datos/tierlist.json');
    final json = jsonDecode(texto) as Map<String, dynamic>;
    return (json['modos'] as List)
        .map((m) => ModoTierList.fromJson(m as Map<String, dynamic>))
        .toList();
  }
}
