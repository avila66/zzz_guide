// PASO 4 · PERSONA B — actualizado en el PASO 6 (imagen desde internet)
// Foto redonda de un agente. Prueba 3 cosas, en este orden:
//   1. Nuestra imagen local: assets/imagenes/agentes/<id>.png
//   2. Si no existe, el icono de la API (agente.urlImagen), desde internet.
//   3. Si tampoco hay (o no hay conexión), las iniciales.
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
        // 1. Imagen local
        child: Image.asset(
          'assets/imagenes/agentes/${agente.id}.png',
          fit: BoxFit.cover, // rellena el círculo sin deformar la imagen
          // errorBuilder se usa si la imagen no se puede cargar (no existe).
          errorBuilder: (context, error, stackTrace) => _imagenDeInternet(color),
        ),
      ),
    );
  }

  // PASO 6b: las imágenes de la API son de cuerpo entero. Para que solo se
  // vea la cabeza, hacemos ZOOM hacia la parte de arriba de la imagen.
  // Podéis ajustar estos dos valores hasta que os guste:
  //   _zoomApi: cuánto se amplía (1.0 = sin zoom, 2.0 = el doble...)
  //   _enfoqueApi: hacia dónde se hace zoom. Alignment(x, y) va de -1 a 1:
  //     x: -1 izquierda, 0 centro, 1 derecha
  //     y: -1 arriba del todo, 0 centro, 1 abajo del todo
  static const double _zoomApi = 2.2;
  static const Alignment _enfoqueApi = Alignment(0, -0.7);

  // 2. Imagen de internet (o 3. iniciales si no hay URL).
  Widget _imagenDeInternet(Color color) {
    final url = agente.urlImagen;
    if (url == null) return _iniciales(color);

    // Image.network descarga la imagen. Flutter la guarda en memoria,
    // así que no se vuelve a descargar mientras la app siga abierta.
    return Image.network(
      url,
      fit: BoxFit.cover,
      // Mientras se descarga, enseñamos las iniciales (en vez de un hueco).
      loadingBuilder: (context, child, progreso) {
        if (progreso == null) {
          // Ya ha terminado: enseñamos la imagen con zoom hacia la cabeza.
          // Transform.scale amplía lo que tiene dentro; el ClipOval de
          // build() recorta lo que se sale del círculo.
          return Transform.scale(
            scale: _zoomApi,
            alignment: _enfoqueApi,
            child: child,
          );
        }
        return _iniciales(color);
      },
      // Si falla (sin internet, URL rota...), también las iniciales.
      errorBuilder: (context, error, stackTrace) => _iniciales(color),
    );
  }

  // 3. Iniciales
  Widget _iniciales(Color color) {
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
  }
}
