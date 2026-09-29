// PASO 7 · PERSONA A (datos)
// El modelo de la tier list: varios "modos" (Shiyu Defense, Deadly Assault...)
// y, dentro de cada modo, varios niveles (T0, T1...) con sus agentes.

class NivelTier {
  const NivelTier({required this.nombre, required this.idsAgentes});

  final String nombre;            // "T0", "T1"...
  final List<String> idsAgentes;  // ids de agentes: "ellen", "miyabi"...

  factory NivelTier.fromJson(Map<String, dynamic> json) {
    return NivelTier(
      nombre: json['nivel'] as String,
      idsAgentes: List<String>.from(json['agentes'] as List),
    );
  }
}

class ModoTierList {
  const ModoTierList({required this.nombre, required this.niveles});

  final String nombre;           // "Shiyu Defense"
  final List<NivelTier> niveles; // de mejor a peor

  factory ModoTierList.fromJson(Map<String, dynamic> json) {
    return ModoTierList(
      nombre: json['nombre'] as String,
      niveles: (json['niveles'] as List)
          .map((n) => NivelTier.fromJson(n as Map<String, dynamic>))
          .toList(),
    );
  }
}
