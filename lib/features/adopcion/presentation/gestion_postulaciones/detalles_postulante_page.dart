import 'package:flutter/material.dart';

class DetallesPostulantePage extends StatelessWidget {
  static const String route = '/detalles-postulante';

  final String adoptante;
  final String detalles;

  const DetallesPostulantePage({
    Key? key,
    required this.adoptante,
    required this.detalles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Adoptante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(title: 'Adoptante'),
              const SizedBox(height: 10),
              Text(
                adoptante,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 1),
              SectionTitle(title: 'Detalles'),
              const SizedBox(height: 10),
              Text(
                detalles,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
