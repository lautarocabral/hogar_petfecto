// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/veterinaria_descripcion_page.dart';
import 'package:hogar_petfecto/features/veterinaria/providers/get_veterinarias_use_case.dart';
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
  LatLng? initialLocation;

  @override
  Widget build(BuildContext context) {
    final listaVeterinariasAsyncValue =
        ref.watch(getVeterinariasUseUseCaseProvider);

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Veterinarias'),
      body: listaVeterinariasAsyncValue.when(
        data: (listaVeterinariasAsyncValue) {
          final veterinarias = listaVeterinariasAsyncValue.veterinarias ?? [];

          // Actualizamos initialLocation si aún no está definido y hay veterinarias con coordenadas válidas
          initialLocation ??= veterinarias
              .where((v) => v.latitud != null && v.longitud != null)
              .map((v) => LatLng(v.latitud!, v.longitud!))
              .firstOrNull;

          // Si no hay coordenadas válidas, usamos una ubicación predeterminada
          final effectiveInitialLocation =
              initialLocation ?? const LatLng(19.432608, -99.133209);

          return FlutterMap(
            options: MapOptions(
              initialCenter:
                  effectiveInitialLocation, // Ubicación inicial dinámica
              initialZoom: 15.0, // Nivel de zoom inicial
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', // Usamos OpenStreetMap
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: veterinarias
                    .where((v) =>
                        v.latitud != null &&
                        v.longitud !=
                            null) // Asegúrate de que las coordenadas no sean nulas
                    .map(
                      (veterinaria) => Marker(
                        point:
                            LatLng(veterinaria.latitud!, veterinaria.longitud!),
                        width: 80.0,
                        height: 80.0,
                        child: GestureDetector(
                          onTap: () {
                            context.push(
                              VeterinariaDescripcionPage.route,
                              extra: veterinaria,
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
                    )
                    .toList(),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error al cargar veterinarias: $error'),
        ),
      ),
    );
  }
}
