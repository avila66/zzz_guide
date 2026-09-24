// Pantalla temporal para las secciones que aún no hemos hecho.
import 'package:flutter/material.dart';

import '../tema.dart';

class PantallaProximamente extends StatelessWidget {
  const PantallaProximamente({super.key, required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // la columna ocupa solo lo necesario
        children: [
          const Icon(Icons.construction, size: 48, color: ColoresApp.acento),
          const SizedBox(height: 12),
          Text(
            titulo,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Próximamente',
            style: TextStyle(color: ColoresApp.textoSecundario),
          ),
        ],
      ),
    );
  }
}
