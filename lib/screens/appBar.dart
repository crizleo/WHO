import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {

  int CurrentIndex = 1;

  void _onItemTapped(int index){
    setState((){
      CurrentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: CurrentIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Productos"),
        BottomNavigationBarItem(icon: Icon(Icons.pageview), label: "Cotizaciones"),
        BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Pedidos")
      ],
    );
  }
}
