import 'package:flutter/material.dart';
import 'package:who/screens/cotizacion/cotizacion.dart';
import 'package:who/screens/productos/productos.dart';

class AppBarMenu extends StatefulWidget {
  const AppBarMenu({super.key});

  @override
  State<AppBarMenu> createState() => _AppBarMenu();
}

class _AppBarMenu extends State<AppBarMenu> {

  int currentIndex = 0;

  void _onItemTapped(int index){
    setState((){
      currentIndex = index;
    });
  }

  List<Widget> screens = [
    Container(
      child: const Productos(),
    ),
    Container(
      child: CotizacionList(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: screens.elementAt(currentIndex),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Productos"),
          BottomNavigationBarItem(icon: Icon(Icons.pageview), label: "Cotizaciones"),
        ],
      )
    );
  }
}
