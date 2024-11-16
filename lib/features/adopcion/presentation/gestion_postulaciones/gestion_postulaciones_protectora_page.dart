import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/adopcion/models/postulaciones_with_postulantes_response_model.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_postulaciones/detalles_postulante_page.dart';
import 'package:hogar_petfecto/features/adopcion/providers/postulacion_use_case.dart';
import 'package:hogar_petfecto/features/seguridad/providers/user_provider.dart';

class GestionPostulacionesProtectoraPage extends ConsumerStatefulWidget {
  const GestionPostulacionesProtectoraPage({super.key});

  static const String route = '/gestion-postulaciones-protectora';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GestionPostulacionesProtectoraPageState();
}

class _GestionPostulacionesProtectoraPageState
    extends ConsumerState<GestionPostulacionesProtectoraPage> {
  late final int perfilId;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userStateNotifierProvider);
    perfilId = user!.persona.perfiles
        .firstWhere((perfil) => perfil.tipoPerfil.id == 4)
        .id;
  }

  @override
  Widget build(BuildContext context) {
    final getPostulacionesOfProtectoraAsyncValue =
        ref.watch(getPostulacionesWithPostulantesUseCaseProvider(perfilId));
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Postulaciones Recibidas',
        goBack: () {
          GoRouter.of(context).pop();
        },
      ),
      body: getPostulacionesOfProtectoraAsyncValue.when(
        data: (PostulacionesWithPostulantesResponseModel data) {
          if (data.mascotaConPersonasDtos == null ||
              data.mascotaConPersonasDtos!.isEmpty) {
            return const Center(
              child: Text('No se encontraron postulaciones.'),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(Margins.largeMargin),
            child: ListView.builder(
              itemCount: data.mascotaConPersonasDtos!.length,
              itemBuilder: (context, index) {
                final mascota = data.mascotaConPersonasDtos![index];
                return buildMascotaSection(mascota);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error al cargar la lista de postulaciones: $error'),
        ),
      ),
    );
  }

  // Construir sección para cada mascota con sus postulantes
  Widget buildMascotaSection(MascotaConPersonasDtos mascota) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 4.0,
      child: ExpansionTile(
        title: Text(
          'Mascota: ${mascota.nombre ?? "Sin nombre"}',
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text('Tipo: ${mascota.tipoMascota ?? "Desconocido"}'),
        children: (mascota.personas ?? [])
            .map((postulante) => buildPostulacionCard(postulante, mascota))
            .toList(),
      ),
    );
  }

  // Tarjeta para cada postulante
  Widget buildPostulacionCard(
      Personas postulante, MascotaConPersonasDtos mascota) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16.0),
      title: Text(
        'Adoptante: ${postulante.razonSocial ?? "Desconocido"}',
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DNI: ${postulante.dni ?? "Sin DNI"}'),
          Text('Estado Civil: ${postulante.estadoCivil ?? "No especificado"}'),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (String result) {
          gestionarPostulacion(result, postulante);
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<String>(
            value: 'aceptar',
            child: Text('Seleccionar'),
            onTap: () {
              ref.read(seleccionarAdoptanteUseCaseProvider(
                  {'mascotaId': mascota.mascotaId!, 'adoptanteId': postulante.adoptanteId!}));

              ref.refresh(
                  getPostulacionesWithPostulantesUseCaseProvider(perfilId));

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Adopcion concretada con exito')),
              );
            },
          ),
        ],
        child: const Icon(Icons.more_vert),
      ),
      onTap: () => context.push(
        DetallesPostulantePage.route,
        extra: postulante,
      ),
    );
  }

  // Gestionar la postulación seleccionada
  void gestionarPostulacion(String accion, Personas postulante) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Postulación de ${postulante.razonSocial ?? "el adoptante"} ${accion == 'aceptar' ? 'aceptada' : 'rechazada'}.'),
      ),
    );
  }
}
