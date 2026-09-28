// PASO 4 · PERSONA B (código)
// Foto redonda de un agente. Busca la imagen por su id:
//   assets/imagenes/agentes/<id>.png   (ej: ellen.png, zhu_yuan.png)
// Si la imagen todavía no existe, enseña las iniciales como hasta ahora.
// Así podéis ir añadiendo fotos poco a poco sin que la app se rompa.
import 'package:flutter/material.dart';

import '../modelos/agente.dart';

class AvatarAgente extends StatelessWidget {
  const AvatarAgente({
    super.key,
    required this.agente,
    this.tamano = 60,     // valores por defecto: si no los pasas, usa estos
    this.grosorBorde = 2,
  });

  final Agente agente;
  final double tamano;
  final double grosorBorde;

  @override
  Widget build(BuildContext context) {
    final color = agente.elemento.color;

    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF24262B),
        border: Border.all(color: color, width: grosorBorde),
      ),
      // ClipOval recorta la imagen en forma de círculo.
      child: ClipOval(
        child: Image.asset(
          'assets/imagenes/agentes/${agente.id}.png',
          fit: BoxFit.cover, // rellena el círculo sin deformar la imagen
          // errorBuilder se usa si la imagen no se puede cargar (no existe).
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                agente.iniciales,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: tamano * 0.3, // el texto crece con el avatar
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
