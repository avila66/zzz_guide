// La "carcasa" de la app: la barra de navegación de abajo y la pantalla activa.
import 'package:flutter/material.dart';

import 'agentes.dart';
import 'inicio.dart';
import 'proximamente.dart';

// StatefulWidget = un widget que SÍ cambia: aquí, la pestaña seleccionada.
class Navegacion extends StatefulWidget {
  const Navegacion({super.key});

  @override
  State<Navegacion> createState() => _NavegacionState();
}

class _NavegacionState extends State<Navegacion> {
  // Qué pestaña está activa: 0 = Inicio, 1 = Agentes, 2 = Tier list, 3 = Guías.
  int _indice = 0;

  // setState() avisa a Flutter de que algo cambió y hay que redibujar.
  void _irA(int nuevoIndice) {
    setState(() {
      _indice = nuevoIndice;
    });
  }

  @override
  Widget build(BuildContext context) {
    // De momento solo Inicio está hecha. Las demás las iremos sustituyendo
    // por sus pantallas de verdad en los siguientes pasos.
    final List<Widget> pantallas = [
      PantallaInicio(alCambiarPestana: _irA),
      const PantallaAgentes(), // PASO 2: ya es la pantalla de verdad
      const PantallaProximamente(titulo: 'Tier list'),
      const PantallaProximamente(titulo: 'Guías'),
    ];

    return Scaffold(
      // SafeArea evita que el contenido quede debajo del notch o la barra de estado.
      // IndexedStack muestra solo la pantalla del índice activo y
      // recuerda el scroll de las demás cuando cambias de pestaña.
      body: SafeArea(
        child: IndexedStack(index: _indice, children: pantallas),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: _irA,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Agentes',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            selectedIcon: Icon(Icons.leaderboard),
            label: 'Tier list',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Guías',
          ),
        ],
      ),
    );
  }
}
