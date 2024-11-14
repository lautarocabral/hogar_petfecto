import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/adopcion/models/mascotas_for_protectoras_response_model.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_mascota/alta_mascota_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_mascota/edit_mascota_page.dart';
import 'package:hogar_petfecto/features/adopcion/providers/mascotas_use_case.dart';

class ListaMascotasPage extends ConsumerStatefulWidget {
  const ListaMascotasPage({super.key});
  static const String route = '/lista_mascotas';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListaMascotasPageState();
}

class _ListaMascotasPageState extends ConsumerState<ListaMascotasPage> {
  void _confirmarEliminarMascota(BuildContext context, MascotasDto mascota) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
              '¿Estás seguro de que deseas eliminar a la mascota "${mascota.nombre}"?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:
                  const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await ref
                    .read(deleteMascotaUseCaseProvider(mascota.id!).future);

                ref.invalidate(getMascotasForProtectoraProvider);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _agregarMascota() {
    context.push(AltaMascotaPage.route);
  }

  void _editarMascota(MascotasDto mascota) {
    context.push(
      EditarMascotaPage.route,
      extra: mascota, 
    );
  }

  @override
  Widget build(BuildContext context) {
    final getAllMascotasAsyncValue =
        ref.watch(getMascotasForProtectoraProvider);

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Gestión de Mascotas'),
      body: getAllMascotasAsyncValue.when(
        data: (getAllMascotasAsyncValue) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Listado de Mascotas',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 50),
                    itemCount: getAllMascotasAsyncValue.mascotasDto!.length,
                    itemBuilder: (context, index) {
                      final mascota =
                          getAllMascotasAsyncValue.mascotasDto![index];

                      // Decode Base64 image
                      final imageBytes = mascota.imagen != null
                          ? base64Decode(mascota.imagen!)
                          : null;

                      return Card(
                        elevation: 3.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: imageBytes != null
                                ? MemoryImage(imageBytes)
                                : null, // Display the decoded image
                            child: imageBytes == null
                                ? const Icon(Icons.pets,
                                    size:
                                        30) // Fallback icon if no image is available
                                : null,
                          ),
                          title: Text(mascota.nombre ?? 'Sin nombre'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Tipo: ${mascota.tipoMascota!.tipo ?? 'Desconocido'}'),
                              Text(
                                  'Peso: ${mascota.peso?.toStringAsFixed(1) ?? 'N/A'} kg'),
                              Text('Sexo: ${mascota.sexo ?? 'N/A'}'),
                              Text(
                                  'Estado: ${mascota.adoptado == true ? 'Adoptado' : 'Disponible'}'),
                              Text(
                                'Vacunado: ${mascota.vacunado == true ? 'Sí' : 'No'}',
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  // Navegar a la pantalla de edición de mascota
                                  _editarMascota(mascota);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Confirmación y acción de eliminar mascota
                                  _confirmarEliminarMascota(context, mascota);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error al cargar tipo de mascotas: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navegar a la pantalla de agregar nueva mascota
          _agregarMascota();
        },
        label: const Text('Agregar Mascota'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
