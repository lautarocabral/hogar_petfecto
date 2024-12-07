import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/veterinaria/models/veterinaria_response_model.dart';

class VeterinariaDescripcionPage extends StatelessWidget {
  final Veterinarias veterinaria;

  static const String route = '/veterinaria-descripcion-page';

  const VeterinariaDescripcionPage({
    super.key,
    required this.veterinaria,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: veterinaria.nombre ?? 'Sin nombre'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre de la veterinaria
              Text(
                veterinaria.nombre ?? 'Nombre de la veterinaria',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16.0),

              // Dirección
              if (veterinaria.direccionLocal != null)
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey, size: 24),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        veterinaria.direccionLocal!,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 16.0),

              // Ofertas
              if (veterinaria.ofertas != null &&
                  veterinaria.ofertas!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ofertas disponibles:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    ...veterinaria.ofertas!.map(
                      (oferta) => Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: oferta.imagen != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    oferta.imagen!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.local_offer,
                                  size: 50,
                                  color: Colors.blueAccent,
                                ),
                          title: Text(
                            oferta.titulo ?? 'Oferta sin título',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            oferta.descripcion ?? 'Sin descripción',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${oferta.descuento ?? 0}%',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const Text(
                                'Desc.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 24.0),

              // Contacto
              if (veterinaria.telefono != null &&
                  veterinaria.telefono!.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.green, size: 24),
                    const SizedBox(width: 8.0),
                    Text(
                      'Contacto: ${veterinaria.telefono}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 32.0),

              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(Icons.map, color: Colors.white,),
                    label: const Text('Ver en Mapa',style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Lógica para llamar
                    },
                    icon: const Icon(Icons.call, color: Colors.white,),
                    label: const Text('Llamar', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
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
