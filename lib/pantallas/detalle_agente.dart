// PASO 3 · PERSONA B (pantalla)
// Ficha de un agente con 3 pestañas: Resumen, Build y Equipos.
import 'package:flutter/material.dart';

import '../modelos/agente.dart';
import '../modelos/guia_agente.dart';
import '../tema.dart';

class PantallaDetalleAgente extends StatelessWidget {
  const PantallaDetalleAgente({super.key, required this.agente});

  // La pantalla recibe el agente que se pulsó en la lista.
  final Agente agente;

  @override
  Widget build(BuildContext context) {
    final guia = agente.guia;

    // DefaultTabController conecta la TabBar (los botones) con el
    // TabBarView (el contenido de cada pestaña). "length" = nº de pestañas.
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // AppBar pone automáticamente la flecha de "volver atrás".
        appBar: AppBar(
          title: const Text('Ficha de agente'),
          backgroundColor: ColoresApp.fondo,
        ),
        body: Column(
          children: [
            _Cabecera(agente: agente),
            // "if" dentro de una lista: la TabBar solo aparece si hay guía.
            if (guia != null)
              const TabBar(
                tabs: [
                  Tab(text: 'Resumen'),
                  Tab(text: 'Build'),
                  Tab(text: 'Equipos'),
                ],
              ),
            Expanded(
              child: guia == null
                  ? const _SinGuia()
                  : TabBarView(
                      children: [
                        _TabResumen(guia: guia),
                        _TabBuild(guia: guia),
                        _TabEquipos(guia: guia),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Cabecera: imagen, nombre y etiquetas ----------

class _Cabecera extends StatelessWidget {
  const _Cabecera({required this.agente});

  final Agente agente;

  @override
  Widget build(BuildContext context) {
    final color = agente.elemento.color;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Row(
        children: [
          // Hueco para la imagen del agente (de momento, iniciales).
          Container(
            width: 88,
            height: 88,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF24262B),
              border: Border.all(color: color, width: 3),
            ),
            child: Text(
              agente.iniciales,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agente.nombre,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // Wrap = como una Row, pero salta de línea si no cabe.
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _Etiqueta('Rango ${agente.rango.nombre}', relleno: agente.rango.color),
                    _Etiqueta(agente.elemento.nombre, borde: color),
                    _Etiqueta(agente.especialidad.nombre),
                    _Etiqueta(agente.faccion),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  const _Etiqueta(this.texto, {this.relleno, this.borde});

  final String texto;
  final Color? relleno; // si tiene relleno, el texto va oscuro
  final Color? borde;

  @override
  Widget build(BuildContext context) {
    final colorTexto = relleno != null ? ColoresApp.textoOscuro : (borde ?? ColoresApp.texto);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: relleno,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: relleno ?? borde ?? ColoresApp.borde),
      ),
      child: Text(
        texto,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorTexto),
      ),
    );
  }
}

// ---------- Bloque reutilizable: una tarjeta con título ----------

class _Bloque extends StatelessWidget {
  const _Bloque({required this.titulo, required this.hijos});

  final String titulo;
  final List<Widget> hijos;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // ocupa todo el ancho
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColoresApp.superficie,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColoresApp.borde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              letterSpacing: 1,
              color: ColoresApp.textoSecundario,
            ),
          ),
          const SizedBox(height: 10),
          // "..." (spread) mete todos los widgets de la lista aquí dentro.
          ...hijos,
        ],
      ),
    );
  }
}

// ---------- Pestaña 1: Resumen ----------

class _TabResumen extends StatelessWidget {
  const _TabResumen({required this.guia});

  final GuiaAgente guia;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _Bloque(
          titulo: 'Valoración por modo',
          hijos: [
            // .entries recorre el Map como pares (clave, valor).
            for (final v in guia.valoraciones.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Text(v.key, style: const TextStyle(color: ColoresApp.textoSecundario)),
                    const Spacer(),
                    Text(
                      v.value,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColoresApp.acento,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        _Bloque(
          titulo: 'Puntos fuertes',
          hijos: [for (final p in guia.puntosFuertes) _Linea('+ $p')],
        ),
        _Bloque(
          titulo: 'Puntos débiles',
          hijos: [for (final p in guia.puntosDebiles) _Linea('− $p')],
        ),
      ],
    );
  }
}

// ---------- Pestaña 2: Build ----------

class _TabBuild extends StatelessWidget {
  const _TabBuild({required this.guia});

  final GuiaAgente guia;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _Bloque(
          titulo: 'W-Engines recomendados',
          hijos: [
            // for con índice para numerar: 1., 2., 3.…
            for (var i = 0; i < guia.wEngines.length; i++)
              _Linea('${i + 1}. ${guia.wEngines[i]}'),
          ],
        ),
        _Bloque(
          titulo: 'Drive Discs',
          hijos: [
            _Linea('${guia.set4}  ·  4 piezas'),
            _Linea('${guia.set2}  ·  2 piezas'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _Ranura(numero: 4, stat: guia.ranura4)),
                const SizedBox(width: 8),
                Expanded(child: _Ranura(numero: 5, stat: guia.ranura5)),
                const SizedBox(width: 8),
                Expanded(child: _Ranura(numero: 6, stat: guia.ranura6)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _Ranura extends StatelessWidget {
  const _Ranura({required this.numero, required this.stat});

  final int numero;
  final String stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF24262B),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            'Ranura $numero',
            style: const TextStyle(fontSize: 12, color: ColoresApp.textoSecundario),
          ),
          const SizedBox(height: 4),
          Text(
            stat,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ---------- Pestaña 3: Equipos ----------

class _TabEquipos extends StatelessWidget {
  const _TabEquipos({required this.guia});

  final GuiaAgente guia;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _Bloque(
          titulo: 'Equipo recomendado',
          hijos: [
            for (final m in guia.equipo)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(m.rol, style: const TextStyle(color: ColoresApp.textoSecundario)),
                    ),
                    Expanded(
                      child: Text(m.nombre, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
          ],
        ),
        _Bloque(titulo: 'Bangboo', hijos: [_Linea(guia.bangboo)]),
      ],
    );
  }
}

// ---------- Pequeños ayudantes ----------

class _Linea extends StatelessWidget {
  const _Linea(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(texto, style: const TextStyle(fontSize: 14, height: 1.3)),
    );
  }
}

class _SinGuia extends StatelessWidget {
  const _SinGuia();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Todavía no hay guía para este agente.\nAñádela en agentes.json',
          textAlign: TextAlign.center,
          style: TextStyle(color: ColoresApp.textoSecundario),
        ),
      ),
    );
  }
}
