import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/seguridad/models/lista_permisos_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/providers/modulo_seguridad_use_case.dart';

class AltaGrupoPage extends ConsumerStatefulWidget {
  static const String route = '/alta-grupo';

  const AltaGrupoPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AltaGrupoPageState();
}

class AltaGrupoPageState extends ConsumerState<AltaGrupoPage> {
  late List<PermisosDto> permisosDisponibles = [];
  late List<int> permisosSeleccionados = [];
  late final TextEditingController grupoNombreController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    _cargarPermisos();
  }

  Future<void> _cargarPermisos() async {
    final permisosResponse =
        await ref.read(listaPermisosUseCaseProvider.future);
    setState(() {
      permisosDisponibles = permisosResponse.permisosDto ?? [];
    });
  }

  Future<void> _guardarCambios() async {
    try {
      if (grupoNombreController.text.isNotEmpty) {
        final credentials = {
          'grupoId': 1,
          'permisosId': permisosSeleccionados,
          'grupoNombre': grupoNombreController.text,
        };

        await ref.read(addGrupoUseCaseProvider(credentials).future);

        ref.invalidate(listaGruposUseCaseProvider);
       

        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debe completar el nombre del grupo'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
      appBar: CustomAppBarWidget(title: 'Crear Grupo'),
      body: permisosDisponibles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: grupoNombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del grupo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    obscureText: false,
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
