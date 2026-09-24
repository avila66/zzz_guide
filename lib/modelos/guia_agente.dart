// PASO 3 · PERSONA A (datos)
// La guía de un agente: valoraciones, build y equipo.
// Va en una clase aparte para que agente.dart no crezca demasiado.

// Un miembro del equipo recomendado: su rol y quién es.
class MiembroEquipo {
  const MiembroEquipo({required this.rol, required this.nombre});

  final String rol;
  final String nombre;

  factory MiembroEquipo.fromJson(Map<String, dynamic> json) {
    return MiembroEquipo(
      rol: json['rol'] as String,
      nombre: json['nombre'] as String,
    );
  }
}

class GuiaAgente {
  const GuiaAgente({
    required this.valoraciones,
    required this.puntosFuertes,
    required this.puntosDebiles,
    required this.wEngines,
    required this.set4,
    required this.set2,
    required this.ranura4,
    required this.ranura5,
    required this.ranura6,
    required this.equipo,
    required this.bangboo,
  });

  // Map = pares clave → valor. Ej: {"Shiyu Defense": "S", "Deadly Assault": "A"}
  final Map<String, String> valoraciones;
  final List<String> puntosFuertes;
  final List<String> puntosDebiles;

  // Build
  final List<String> wEngines; // en orden de preferencia
  final String set4;           // set de Drive Discs de 4 piezas
  final String set2;           // set de 2 piezas
  final String ranura4;        // stat principal recomendado en cada ranura
  final String ranura5;
  final String ranura6;

  // Equipo
  final List<MiembroEquipo> equipo;
  final String bangboo;

  factory GuiaAgente.fromJson(Map<String, dynamic> json) {
    return GuiaAgente(
      // .from(...) convierte lo que viene del JSON (tipos "dynamic")
      // a listas y mapas con el tipo correcto.
      valoraciones: Map<String, String>.from(json['valoraciones'] as Map),
      puntosFuertes: List<String>.from(json['puntosFuertes'] as List),
      puntosDebiles: List<String>.from(json['puntosDebiles'] as List),
      wEngines: List<String>.from(json['wEngines'] as List),
      set4: json['set4'] as String,
      set2: json['set2'] as String,
      ranura4: json['ranura4'] as String,
      ranura5: json['ranura5'] as String,
      ranura6: json['ranura6'] as String,
      equipo: (json['equipo'] as List)
          .map((m) => MiembroEquipo.fromJson(m as Map<String, dynamic>))
          .toList(),
      bangboo: json['bangboo'] as String,
    );
  }
}
