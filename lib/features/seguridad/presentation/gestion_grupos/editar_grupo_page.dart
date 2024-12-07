import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/seguridad/models/lista_grupos_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/models/lista_permisos_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/providers/modulo_seguridad_use_case.dart';

class EditarGrupoPage extends ConsumerStatefulWidget {
  final GruposDto grupo;
  static const String route = '/editar-grupo';

  const EditarGrupoPage({Key? key, required this.grupo}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditarGrupoPageState();
}

class _EditarGrupoPageState extends ConsumerState<EditarGrupoPage> {
  late List<PermisosDto> permisosDisponibles = [];
  late List<int> permisosSeleccionados = [];

  @override
  void initState() {
    super.initState();
    _cargarPermisos();
  }

  Future<void> _cargarPermisos() async {
    // Lógica para cargar la lista de permisos disponibles y los actuales
    final permisosResponse =
        await ref.read(listaPermisosUseCaseProvider.future);
    setState(() {
      permisosDisponibles = permisosResponse.permisosDto ?? [];
      permisosSeleccionados =
          widget.grupo.permisos?.map((p) => p.id!).toList() ?? [];
    });
  }

  Future<void> _guardarCambios() async {
    try {
      final permisosActualizados = permisosSeleccionados
          .map((id) => permisosDisponibles.firstWhere((p) => p.id == id))
          .toList();

      final credentials = {
        'grupoId': widget.grupo.id,
        'permisosId': permisosSeleccionados,
        'grupoNombre': '',
      };

      await ref.read(editarGrupoUseCaseProvider(credentials).future);
      ref.invalidate(listaGruposUseCaseProvider);
      await ref.refresh(listaGruposUseCaseProvider.future);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permisos actualizados con éxito'),
          backgroundColor: Colors.green,
        ),
      );
      await Future.delayed(Duration(milliseconds: 100));
     
      context.pop(); // Vuelve a la pantalla anterior
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar permisos: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Editar Permisos'),
      body: permisosDisponibles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Permisos para el grupo: ${widget.grupo.descripcion}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: permisosDisponibles.length,
                      itemBuilder: (context, index) {
                        final permiso = permisosDisponibles[index];
                        final isSelected =
                            permisosSeleccionados.contains(permiso.id);

                        return CheckboxListTile(
                          title: Text(permiso.nombrePermiso ?? ''),
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                permisosSeleccionados.add(permiso.id!);
                              } else {
                                permisosSeleccionados.remove(permiso.id!);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _guardarCambios,
                    child: const Text('Guardar Cambios'),
                  ),
                ],
              ),
            ),
    );
  }
}
