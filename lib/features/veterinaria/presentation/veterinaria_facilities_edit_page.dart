import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hogar_petfecto/features/veterinaria/models/servicios_response_model.dart';
import 'package:hogar_petfecto/features/veterinaria/providers/servicios_use_case.dart';

class VeterinariaFacilitiesEditPage extends ConsumerStatefulWidget {
  const VeterinariaFacilitiesEditPage({super.key});

  static const String route = '/veterinaria_servicios_edit';

  @override
  ConsumerState<VeterinariaFacilitiesEditPage> createState() =>
      _VeterinariaFacilitiesEditPageState();
}

class _VeterinariaFacilitiesEditPageState
    extends ConsumerState<VeterinariaFacilitiesEditPage> {
  @override
  Widget build(BuildContext context) {
    final serviciosAsyncValue = ref.watch(serviciosUseCaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Servicios de la Veterinaria',
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddOrEditDialog(context),
          ),
        ],
      ),
      body: serviciosAsyncValue.when(
        data: (servicios) => _buildServiciosList(context, servicios.servicios!),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error al cargar servicios: $error')),
      ),
    );
  }

  Widget _buildServiciosList(BuildContext context, List<Servicios> servicios) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Gestiona los servicios de tu veterinaria: ¡Agrega y edita los servicios que ofreces para atraer a más clientes y destacar tus especialidades!',
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: servicios.length,
            itemBuilder: (context, index) {
              final servicio = servicios[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(
                    servicio.servicioNombre ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(servicio.servicioDescripcion ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _showAddOrEditDialog(context, servicio: servicio),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteServicio(servicio: servicio),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _deleteServicio({Servicios? servicio}) async {
    await ref.read(deleteServicioUseCaseProvider(servicio!.id!).future);
    ref.invalidate(serviciosUseCaseProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Servicio eliminado con exito'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddOrEditDialog(BuildContext context, {Servicios? servicio}) {
    final isEdit = servicio != null;
    final nombreController =
        TextEditingController(text: isEdit ? servicio!.servicioNombre : '');
    final descripcionController = TextEditingController(
        text: isEdit ? servicio!.servicioDescripcion : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Editar Servicio' : 'Agregar Servicio'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (nombreController.text.isNotEmpty &&
                    descripcionController.text.isNotEmpty) {
                  if (isEdit) {
                    final credentials = {
                      'servicioNombre': nombreController.text,
                      'servicioDescripcion': descripcionController.text,
                      'servicioId': servicio.id
                    };
                    await ref
                        .read(addServicioUseCaseProvider(credentials).future);
                    ref.invalidate(serviciosUseCaseProvider);
                  } else {
                    final credentials = {
                      'servicioNombre': nombreController.text,
                      'servicioDescripcion': descripcionController.text,
                    };
                    await ref
                        .read(addServicioUseCaseProvider(credentials).future);
                    ref.invalidate(serviciosUseCaseProvider);
                  }

                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEdit
                          ? 'Servicio actualizado'
                          : 'Servicio agregado'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
