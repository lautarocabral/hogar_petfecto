import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/seguridad/models/lista_grupos_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/gestion_grupos/alta_grupo_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/gestion_grupos/editar_grupo_page.dart';
import 'package:hogar_petfecto/features/seguridad/providers/modulo_seguridad_use_case.dart';

class ListaGruposPage extends ConsumerStatefulWidget {
  const ListaGruposPage({super.key});
  static const String route = '/lista_grupos';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListaGruposPageState();
}

class _ListaGruposPageState extends ConsumerState<ListaGruposPage> {
  @override
  Widget build(BuildContext context) {
    final listaGruposAsyncValue = ref.watch(listaGruposUseCaseProvider);
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Gestión de Grupos'),
      body: listaGruposAsyncValue.when(
        data: (listaGruposAsyncValue) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grupos Registrados',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: listaGruposAsyncValue.gruposDto!
                        .length, // Aquí pondrías el número real de roles
                    itemBuilder: (context, index) {
                      // Lista de roles ficticios
                      var role = listaGruposAsyncValue.gruposDto![index];
                      return Column(
                        children: [
                          Card(
                            elevation: 5.0,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Text(
                                  role.id.toString(),
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                role.descripcion ?? '',
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: () {
                                      // Acción para editar el rol
                                      context.push(EditarGrupoPage.route,
                                          extra: role);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      // Confirmación y acción de eliminar rol
                                      _confirmarEliminarRol(context, role);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 80), // Espacio fijo debajo de la lista
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error al cargar provincias: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AltaGrupoPage.route);
        },
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Agregar Grupo'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _confirmarEliminarRol(BuildContext context, GruposDto role) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar el rol $role?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                context.pop();
              },
            ),
            TextButton(
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await ref.read(eliminarGrupoUseCaseProvider(role.id!).future);
                ref.invalidate(listaGruposUseCaseProvider);
               
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
