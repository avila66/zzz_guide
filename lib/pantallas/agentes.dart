// PASO 2 · PERSONA B (pantalla)
// Lista de agentes con filtros por rango y elemento.
import 'package:flutter/material.dart';

import '../datos/repositorio_agentes.dart';
import '../modelos/agente.dart';
import '../tema.dart';
import '../widgets/tarjeta_agente.dart';

class PantallaAgentes extends StatefulWidget {
  const PantallaAgentes({super.key});

  @override
  State<PantallaAgentes> createState() => _PantallaAgentesState();
}

class _PantallaAgentesState extends State<PantallaAgentes> {
  // Guardamos el Future en initState para cargar el JSON UNA sola vez
  // (si lo pusiéramos en build(), se volvería a cargar en cada redibujado).
  late final Future<List<Agente>> _cargaAgentes;

  // Filtros activos. null = "Todos".
  Rango? _rango;
  Elemento? _elemento;

  @override
  void initState() {
    super.initState();
    _cargaAgentes = RepositorioAgentes.cargar();
  }

  // Devuelve solo los agentes que cumplen los filtros.
  List<Agente> _filtrar(List<Agente> todos) {
    return todos.where((agente) {
      final okRango = _rango == null || agente.rango == _rango;
      final okElemento = _elemento == null || agente.elemento == _elemento;
      return okRango && okElemento;
    }).toList();
  }

  void _abrirFicha(Agente agente) {
    // La ficha del agente la haremos en el paso 3.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ficha de ${agente.nombre}: próximamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder dibuja una cosa u otra según el estado del Future:
    // cargando, error o datos listos.
    return FutureBuilder<List<Agente>>(
      future: _cargaAgentes,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Error al cargar los agentes:\n${snapshot.error}'),
            ),
          );
        }

        final agentes = _filtrar(snapshot.data ?? []);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cabecera(agentes.length),
            _filaFiltros<Rango>(
              etiqueta: 'Rango',
              opciones: Rango.values,
              seleccionado: _rango,
              nombreDe: (r) => r.nombre,
              alElegir: (r) => setState(() => _rango = r),
            ),
            const SizedBox(height: 8),
            _filaFiltros<Elemento>(
              etiqueta: 'Elemento',
              opciones: Elemento.values,
              seleccionado: _elemento,
              nombreDe: (e) => e.nombre,
              alElegir: (e) => setState(() => _elemento = e),
            ),
            const SizedBox(height: 12),
            // Expanded = "ocupa todo el espacio que queda".
            // Sin él, la cuadrícula no sabría qué alto tener y daría error.
            Expanded(
              child: agentes.isEmpty
                  ? const Center(
                      child: Text(
                        'Ningún agente con esos filtros',
                        style: TextStyle(color: ColoresApp.textoSecundario),
                      ),
                    )
                  : _cuadricula(agentes),
            ),
          ],
        );
      },
    );
  }

  Widget _cabecera(int total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'Agentes',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            '$total resultados',
            style: const TextStyle(color: ColoresApp.textoSecundario),
          ),
        ],
      ),
    );
  }

  // Una fila de chips con scroll horizontal. Es "genérica" (<T>): sirve
  // igual para Rango que para Elemento, así no repetimos código.
  Widget _filaFiltros<T>({
    required String etiqueta,
    required List<T> opciones,
    required T? seleccionado,
    required String Function(T) nombreDe,
    required void Function(T?) alElegir,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              etiqueta,
              style: const TextStyle(fontSize: 12, color: ColoresApp.textoSecundario),
            ),
          ),
          _chip('Todos', seleccionado == null, () => alElegir(null)),
          // "for" dentro de una lista: crea un chip por cada opción.
          for (final opcion in opciones)
            _chip(nombreDe(opcion), seleccionado == opcion, () => alElegir(opcion)),
        ],
      ),
    );
  }

  Widget _chip(String texto, bool activo, VoidCallback alPulsar) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(texto),
        selected: activo,
        showCheckmark: false,
        onSelected: (_) => alPulsar(),
        selectedColor: ColoresApp.acento,
        backgroundColor: ColoresApp.superficie,
        side: BorderSide(color: activo ? ColoresApp.acento : ColoresApp.borde),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: activo ? ColoresApp.textoOscuro : ColoresApp.texto,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }

  Widget _cuadricula(List<Agente> agentes) {
    // GridView.builder crea las tarjetas según se ven en pantalla
    // (mejor que GridView.count cuando la lista es larga).
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: agentes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.66, // más altas que anchas
      ),
      itemBuilder: (context, indice) {
        final agente = agentes[indice];
        return TarjetaAgente(
          agente: agente,
          alPulsar: () => _abrirFicha(agente),
        );
      },
    );
  }
}
