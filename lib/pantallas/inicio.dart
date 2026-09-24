// PASO 1: la pantalla de Inicio.
import 'package:flutter/material.dart';

import '../tema.dart';
import '../widgets/tarjeta_seccion.dart';

// Una clase sencilla para describir cada sección de la cuadrícula.
// Así los datos están separados del diseño.
class Seccion {
  const Seccion({
    required this.titulo,
    required this.subtitulo,
    required this.color,
    this.pestana, // "?" en el tipo = puede ser null (sección sin pantalla todavía)
  });

  final String titulo;
  final String subtitulo;
  final Color color;
  final int? pestana; // índice de la barra de abajo al que lleva
}

const List<Seccion> secciones = [
  Seccion(titulo: 'Agentes', subtitulo: 'Fichas, builds y equipos', color: ColoresApp.acento, pestana: 1),
  Seccion(titulo: 'Tier list', subtitulo: 'Ranking por modo', color: ColoresApp.fuego, pestana: 2),
  Seccion(titulo: 'W-Engines', subtitulo: 'Armas y sus efectos', color: ColoresApp.electrico),
  Seccion(titulo: 'Discos', subtitulo: 'Sets de Drive Discs', color: ColoresApp.hielo),
  Seccion(titulo: 'Bangboo', subtitulo: 'Compañeros y habilidades', color: ColoresApp.eter),
  Seccion(titulo: 'Novatos', subtitulo: 'Primeros pasos y reroll', color: ColoresApp.fisico),
];

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key, required this.alCambiarPestana});

  // Función que nos pasa Navegacion para poder cambiar de pestaña desde aquí.
  final void Function(int) alCambiarPestana;

  // Muestra un mensajito abajo para lo que aún no está hecho.
  void _mostrarProximamente(BuildContext context, String que) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$que: próximamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ListView = columna con scroll. Todo lo de la pantalla va dentro.
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      children: [
        _cabecera(context),
        const SizedBox(height: 20),
        _buscador(),
        const SizedBox(height: 20),
        _bannerActual(context),
        const SizedBox(height: 24),
        const _TituloSeccion('Base de datos'),
        const SizedBox(height: 12),
        _cuadriculaSecciones(context),
        const SizedBox(height: 24),
        const _TituloSeccion('Contenido endgame'),
        const SizedBox(height: 12),
        _FilaEndgame(
          titulo: 'Shiyu Defense',
          subtitulo: 'Equipos recomendados por fase',
          alPulsar: () => _mostrarProximamente(context, 'Shiyu Defense'),
        ),
        const SizedBox(height: 8),
        _FilaEndgame(
          titulo: 'Deadly Assault',
          subtitulo: 'Jefes de la rotación actual',
          alPulsar: () => _mostrarProximamente(context, 'Deadly Assault'),
        ),
      ],
    );
  }

  // --- Trozos de la pantalla, separados en métodos para que se lea mejor ---

  Widget _cabecera(BuildContext context) {
    return Row(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GUÍA ZZZ',
              style: TextStyle(
                fontSize: 13,
                letterSpacing: 3,
                fontWeight: FontWeight.bold,
                color: ColoresApp.acento,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Hola, Proxy',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Spacer(), // empuja el botón hasta la derecha
        IconButton(
          tooltip: 'Ajustes',
          icon: const Icon(Icons.settings_outlined),
          style: IconButton.styleFrom(
            backgroundColor: ColoresApp.superficie,
            side: const BorderSide(color: ColoresApp.borde),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => _mostrarProximamente(context, 'Ajustes'),
        ),
      ],
    );
  }

  Widget _buscador() {
    final borde = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: ColoresApp.borde),
    );
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar agentes, W-Engines, discos…',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: ColoresApp.superficie,
        border: borde,
        enabledBorder: borde,
        focusedBorder: borde.copyWith(
          borderSide: const BorderSide(color: ColoresApp.acento),
        ),
      ),
    );
  }

  Widget _bannerActual(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ColoresApp.acento,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BANNER ACTUAL',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: ColoresApp.textoOscuro,
            ),
          ),
          const SizedBox(height: 6),
          // TODO: cambiar estos textos por los datos reales del banner.
          const Text(
            '[AGENTE DESTACADO]',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: ColoresApp.textoOscuro,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Versión [X.X] · termina el [FECHA]',
            style: TextStyle(fontSize: 14, color: ColoresApp.textoOscuro),
          ),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: ColoresApp.textoOscuro,
              foregroundColor: ColoresApp.acento,
            ),
            onPressed: () => _mostrarProximamente(context, 'Guía del agente'),
            child: const Text('Ver guía del agente'),
          ),
        ],
      ),
    );
  }

  Widget _cuadriculaSecciones(BuildContext context) {
    // GridView.count = cuadrícula con un número fijo de columnas.
    // shrinkWrap + NeverScrollableScrollPhysics: la cuadrícula no hace scroll
    // por su cuenta, porque ya está dentro del ListView que sí lo hace.
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.6, // ancho / alto de cada tarjeta
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // .map() convierte cada Seccion (datos) en una TarjetaSeccion (widget).
      children: secciones.map((s) {
        return TarjetaSeccion(
          titulo: s.titulo,
          subtitulo: s.subtitulo,
          color: s.color,
          alPulsar: () {
            final pestana = s.pestana;
            if (pestana != null) {
              alCambiarPestana(pestana);
            } else {
              _mostrarProximamente(context, s.titulo);
            }
          },
        );
      }).toList(),
    );
  }
}

// Widgets pequeños privados (el "_" delante = solo se usan en este archivo).

class _TituloSeccion extends StatelessWidget {
  const _TituloSeccion(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class _FilaEndgame extends StatelessWidget {
  const _FilaEndgame({
    required this.titulo,
    required this.subtitulo,
    required this.alPulsar,
  });

  final String titulo;
  final String subtitulo;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColoresApp.superficie,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: ColoresApp.borde),
      ),
      // ListTile = fila típica de lista con título, subtítulo e icono.
      child: ListTile(
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          subtitulo,
          style: const TextStyle(color: ColoresApp.textoSecundario, fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, color: ColoresApp.acento),
        onTap: alPulsar,
      ),
    );
  }
}
