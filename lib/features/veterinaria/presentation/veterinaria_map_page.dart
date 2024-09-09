// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/veterinaria_descripcion_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';

class VeterinariaMapPage extends ConsumerStatefulWidget {
  const VeterinariaMapPage({super.key});

  static const String route = '/veterinaria-map';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VeterinariaMapPageState();
}

class _VeterinariaMapPageState extends ConsumerState<VeterinariaMapPage> {
  // Definimos la ubicación inicial en coordenadas de latitud y longitud
  final LatLng initialLocation =
      LatLng(19.432608, -99.133209); // Ejemplo: Ciudad de México

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Veterinarias'),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: initialLocation, // Ubicación inicial del mapa
          initialZoom: 13.0, // Nivel de zoom inicial
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', // Usamos OpenStreetMap
            subdomains: ['a', 'b', 'c'],
          ),
          // Añadimos la capa de marcadores para las veterinarias
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(19.432608,
                    -99.133209), // Ejemplo de ubicación de una veterinaria
                width: 80.0,
                height: 80.0,
                child: GestureDetector(
                  onTap: () {
                    context.push(
                      VeterinariaDescripcionPage.route,
                      extra: {
                        'nombre': 'Veterinaria Central',
                        'descripcion':
                            'Ofrecemos los mejores servicios veterinarios en la ciudad.',
                      },
                    );
                  },
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
                rotate: true, // Para rotar el ícono si es necesario
              ),
              // Añade más marcadores para otras veterinarias
            ],
          ),
        ],
      ),
    );
  }
}
