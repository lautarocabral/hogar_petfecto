import 'package:flutter/material.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';

class VeterinariaDescripcionPage extends StatelessWidget {
  final String veterinariaNombre;
  final String veterinariaDescripcion;
  static const String route = '/veterinaria-descripcion-page';

  const VeterinariaDescripcionPage({
    super.key,
    required this.veterinariaNombre,
    required this.veterinariaDescripcion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: veterinariaNombre),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(
                    'https://via.placeholder.com/300x200.png?text=Veterinaria',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                veterinariaNombre,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                veterinariaDescripcion,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Acción de llamar a la veterinaria
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('Llamar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Acción de navegar a la ubicación en el mapa
                    },
                    icon: const Icon(Icons.map),
                    label: const Text('Ver en Mapa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
