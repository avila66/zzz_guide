// PASO 7 · PERSONA B (pantalla)
// Tier list: elige un modo arriba y ve los agentes agrupados por nivel.
import 'package:flutter/material.dart';

import '../datos/repositorio_agentes.dart';
import '../datos/repositorio_tier_list.dart';
import '../modelos/agente.dart';
import '../modelos/tier_list.dart';
import '../tema.dart';
import '../widgets/avatar_agente.dart';
import 'detalle_agente.dart';

// Los dos datos que necesita la pantalla, juntos en una clase.
class _DatosTierList {
  const _DatosTierList({required this.modos, required this.agentesPorId});

  final List<ModoTierList> modos;
  final Map<String, Agente> agentesPorId;
}

class PantallaTierList extends StatefulWidget {
  const PantallaTierList({super.key});

  @override
  State<PantallaTierList> createState() => _PantallaTierListState();
}

class _PantallaTierListState extends State<PantallaTierList> {
  late final Future<_DatosTierList> _carga;
  int _modoElegido = 0; // índice del modo seleccionado

  @override
  void initState() {
    super.initState();
    _carga = _cargarTodo();
  }

  Future<_DatosTierList> _cargarTodo() async {
    // Future.wait lanza las dos cargas A LA VEZ y espera a que acaben ambas
    // (más rápido que una detrás de otra).
    final resultados = await Future.wait([
      RepositorioTierList.cargar(),
      RepositorioAgentes.cargar(),
    ]);
    final modos = resultados[0] as List<ModoTierList>;
    final agentes = resultados[1] as List<Agente>;

    return _DatosTierList(
      modos: modos,
      agentesPorId: {for (final a in agentes) a.id: a},
    );
  }

  void _abrirFicha(Agente agente) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PantallaDetalleAgente(agente: agente)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DatosTierList>(
      future: _carga,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Error al cargar la tier list:\n${snapshot.error}'),
            ),
          );
        }

        final datos = snapshot.data!; // "!" = sabemos que no es null
        if (datos.modos.isEmpty) {
          return const Center(child: Text('La tier list está vacía'));
        }
        final modo = datos.modos[_modoElegido];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 14),
              child: Text(
                'Tier list',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            _selectorModos(datos.modos),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: [
                  for (var i = 0; i < modo.niveles.length; i++)
                    _FilaNivel(
                      nivel: modo.niveles[i],
                      color: _colorNivel(i),
                      agentesPorId: datos.agentesPorId,
                      alPulsar: _abrirFicha,
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _selectorModos(List<ModoTierList> modos) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          for (var i = 0; i < modos.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(modos[i].nombre),
                selected: i == _modoElegido,
                showCheckmark: false,
                onSelected: (_) => setState(() => _modoElegido = i),
                selectedColor: ColoresApp.acento,
                backgroundColor: ColoresApp.superficie,
                side: BorderSide(
                  color: i == _modoElegido ? ColoresApp.acento : ColoresApp.borde,
                ),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: i == _modoElegido ? ColoresApp.textoOscuro : ColoresApp.texto,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
            ),
        ],
      ),
    );
  }

  // El primer nivel en amarillo, luego naranja, violeta y grises.
  Color _colorNivel(int indice) {
    const colores = [
      ColoresApp.acento,
      Color(0xFFFFB35C),
      Color(0xFFB9A6FF),
      Color(0xFF9A9DA3),
    ];
    // Si hay más niveles que colores, los últimos se quedan en gris.
    return indice < colores.length ? colores[indice] : colores.last;
  }
}

// Una fila de la tier list: la etiqueta del nivel + sus agentes.
class _FilaNivel extends StatelessWidget {
  const _FilaNivel({
    required this.nivel,
    required this.color,
    required this.agentesPorId,
    required this.alPulsar,
  });

  final NivelTier nivel;
  final Color color;
  final Map<String, Agente> agentesPorId;
  final void Function(Agente) alPulsar;

  @override
  Widget build(BuildContext context) {
    // Buscamos cada id en el mapa. Si un id está mal escrito en el JSON,
    // simplemente no sale (whereType<Agente>() quita los null).
    final agentes = nivel.idsAgentes
        .map((id) => agentesPorId[id])
        .whereType<Agente>()
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: ColoresApp.superficie,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColoresApp.borde),
      ),
      // IntrinsicHeight hace que la etiqueta de color tenga
      // la misma altura que la zona de los agentes.
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 56,
              color: color,
              alignment: Alignment.center,
              child: Text(
                nivel.nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColoresApp.textoOscuro,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final agente in agentes)
                      _MiniAgente(agente: agente, alPulsar: () => alPulsar(agente)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniAgente extends StatelessWidget {
  const _MiniAgente({required this.agente, required this.alPulsar});

  final Agente agente;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    // Solo la primera palabra del nombre, para que quepa ("Ellen Joe" -> "Ellen").
    final nombreCorto = agente.nombre.split(' ').first;

    return InkWell(
      onTap: alPulsar,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            AvatarAgente(agente: agente, tamano: 48),
            const SizedBox(height: 4),
            Text(
              nombreCorto,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
