import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/adopcion/models/get_postulacion_by_id_response_model.dart';
import 'package:hogar_petfecto/features/adopcion/providers/adopcion_use_case.dart';
import 'package:hogar_petfecto/features/adopcion/providers/postulacion_use_case.dart';
import 'package:hogar_petfecto/features/seguridad/models/login_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/providers/user_provider.dart';

class GestionPostulacionesAdoptantePage extends ConsumerStatefulWidget {
  const GestionPostulacionesAdoptantePage({super.key});

  static const String route = '/gestion-postulaciones-adoptante';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GestionPostulacionesAdoptantePageState();
}

class _GestionPostulacionesAdoptantePageState
    extends ConsumerState<GestionPostulacionesAdoptantePage> {
  late final int perfilId;
  late UsuarioResponseDto? user;

  @override
  void initState() {
    super.initState();
    user = ref.read(userStateNotifierProvider);
    perfilId = user!.persona.perfiles
        .firstWhere((perfil) => perfil.tipoPerfil.id == 1)
        .id;
  }

  @override
  Widget build(BuildContext context) {
    final getAllMascotasAsyncValue =
        ref.watch(getPostulacionByIdUseCaseProvider(perfilId));
    final getMisMascotasAsyncValue = ref.watch(getMisAdopcionesUseCaseProvider);

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Mis Postulaciones y Adopciones',
        goBack: () {
          GoRouter.of(context).pop();
        },
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue[50], // Color para distinguir esta sección
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Adopciones Concretadas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: getMisMascotasAsyncValue.when(
                      data: (adopciones) {
                        return ListView.builder(
                          itemCount: adopciones.adopciones?.length ?? 0,
                          itemBuilder: (context, index) {
                            final adopcion = adopciones.adopciones?[index];
                            return ListTile(
                              title: Text(
                                  adopcion?.mascota?.nombre ?? 'Desconocido'),
                              subtitle: Text(
                                'Peso: ${adopcion?.mascota?.peso ?? 'N/A'}kg',
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stackTrace) => Center(
                        child: Text('Error al cargar adopciones: $error'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 2),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.green[50], // Color para distinguir esta sección
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Postulaciones Pendientes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: getAllMascotasAsyncValue.when(
                      data: (postulacionResponse) {
                        return ListView.builder(
                          itemCount:
                              postulacionResponse.postulacionDtos?.length ?? 0,
                          itemBuilder: (context, index) {
                            final postulacion =
                                postulacionResponse.postulacionDtos![index];
                            return buildPostulacionCard(postulacion, perfilId);
                          },
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stackTrace) => Center(
                        child: Text('Error al cargar postulaciones: $error'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPostulacionCard(PostulacionDtos postulacion, int perfilId) {
    final name = postulacion.mascota?.nombre ?? 'Desconocido';
    final age = postulacion.mascota?.fechaNacimiento != null
        ? '${DateTime.now().year - DateTime.parse(postulacion.mascota!.fechaNacimiento!).year} años'
        : 'Edad desconocida';
    final status = postulacion.estado?.estado ?? 'Estado desconocido';

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          name,
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text(age),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              status,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
              onPressed: () {
                eliminarPostulacion(postulacion.id!, perfilId);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> eliminarPostulacion(int mascotaId, int perfilId) async {
    await ref.read(deletePostulacionUseCaseProvider(mascotaId).future);

    ref.refresh(getPostulacionByIdUseCaseProvider(perfilId));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Postulación eliminada')),
    );
  }
}
