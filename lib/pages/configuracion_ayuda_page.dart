import 'package:flutter/material.dart';

class ConfiguracionAyudaPage extends StatelessWidget {
  const ConfiguracionAyudaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración / Ayuda')),
      body: const Center(child: Text('Welcome to Configuración / Ayuda Page!')),
    );
  }
}
