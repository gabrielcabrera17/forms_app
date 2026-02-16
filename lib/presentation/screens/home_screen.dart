import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prueba instalación via git hub'),
      ),
      body: ListView(

        children: [
          ListTile(
            title: Text('Cubits'),
            subtitle: Text('Gestor de estado simple'),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => context.push('/cubits'),
          ),

           ListTile(
            title: Text('BLoC'),
            subtitle: Text('Gestor de estado compuesto'),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => context.push('/counter-bloc'),
          )
        ],

      ),
    );
  }
}