// PASO 2 · PERSONA B (pantalla)
// Tarjeta de un agente en la cuadrícula.
import 'package:flutter/material.dart';

import '../modelos/agente.dart';
import '../tema.dart';

class TarjetaAgente extends StatelessWidget {
  const TarjetaAgente({super.key, required this.agente, required this.alPulsar});

  final Agente agente;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    final colorElemento = agente.elemento.color;

    return Material(
      color: ColoresApp.superficie,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: ColoresApp.borde),
      ),
      child: InkWell(
        onTap: alPulsar,
        // Stack = poner widgets unos ENCIMA de otros (la letra del rango
        // flota sobre la esquina de la tarjeta).
        child: Stack(
          children: [
            Positioned(
              top: 8,
              left: 10,
              child: Text(
                agente.rango.nombre,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: agente.rango.color,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hueco para la imagen: de momento, un círculo con iniciales.
                  Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF24262B),
                      border: Border.all(color: colorElemento, width: 2),
                    ),
                    child: Text(
                      agente.iniciales,
                      style: TextStyle(
                        color: colorElemento,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    agente.nombre,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    agente.elemento.nombre,
                    style: TextStyle(fontSize: 11, color: colorElemento),
                  ),
                  Text(
                    agente.especialidad.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: ColoresApp.textoSecundario,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
