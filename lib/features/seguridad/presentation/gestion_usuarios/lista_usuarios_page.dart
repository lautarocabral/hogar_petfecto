import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/gestion_usuarios/editar_usuario_page.dart';
import 'package:hogar_petfecto/features/seguridad/providers/modulo_seguridad_use_case.dart';

class ListaUsuariosPage extends ConsumerStatefulWidget {
  const ListaUsuariosPage({super.key});
  static const String route = '/lista_usuarios';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListaUsuariosPageState();
}

class _ListaUsuariosPageState extends ConsumerState<ListaUsuariosPage> {
  void _confirmarEliminarUsuario(BuildContext context, int userIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
              '¿Estás seguro de que deseas eliminar al usuario $userIndex?'),
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
              onPressed: () {
                // Acción para eliminar el usuario
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listaUsuariosAsyncValue = ref.watch(listaUsuariosUseCaseProvider);

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Gestión de usuarios'),
      body: listaUsuariosAsyncValue.when(
        data: (listaUsuariosAsyncValue) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Usuarios registrados',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: listaUsuariosAsyncValue.usuarioDtos!.length,
                    itemBuilder: (context, index) {
                      var usuario = listaUsuariosAsyncValue.usuarioDtos![index];
                      return Column(
                        children: [
                          Card(
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                    'U${index + 1}'), // Iniciales o avatar del usuario
                              ),
                              title: Text(
                                  'Usuario ${usuario.persona!.razonSocial}'),
                              subtitle: Text(
                                  'Roles: ${usuario.grupos!.map((grupo) => grupo.descripcion).join(', ')}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () {
                                      context.push(EditarUsuarioPage.route,
                                          extra: usuario);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      // Confirmación y acción de eliminar usuario
                                      _confirmarEliminarUsuario(context, index);
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
                const SizedBox(
                  height: 80, // Espacio fijo debajo de la lista
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error al cargar provincias: $error'),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     context.push(AltaUsuarioPage.route);
      //   },
      //   backgroundColor: Colors.blueAccent,
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
