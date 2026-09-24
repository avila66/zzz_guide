// Tarjeta reutilizable para cada sección de la cuadrícula "Base de datos".
// Crear widgets propios así evita repetir el mismo código 6 veces.
import 'package:flutter/material.dart';

import '../tema.dart';

class TarjetaSeccion extends StatelessWidget {
  const TarjetaSeccion({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.color,
    required this.alPulsar,
  });

  final String titulo;
  final String subtitulo;
  final Color color;          // el cuadradito de color de la esquina
  final VoidCallback alPulsar; // función que se ejecuta al tocar la tarjeta

  @override
  Widget build(BuildContext context) {
    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: const BorderSide(color: ColoresApp.borde),
    );

    // Material + InkWell = tarjeta con el efecto "onda" al pulsarla.
    return Material(
      color: ColoresApp.superficie,
      shape: forma,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alPulsar,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // alinear a la izquierda
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // "..." si no cabe
                    style: const TextStyle(
                      fontSize: 12,
                      color: ColoresApp.textoSecundario,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
