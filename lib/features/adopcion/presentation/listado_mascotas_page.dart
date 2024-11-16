import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/adopcion/models/get_all_mascotas_response_model.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/descripcion_mascota_page.dart';
import 'package:hogar_petfecto/features/adopcion/providers/mascotas_use_case.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

class ListadoMascotasPage extends ConsumerStatefulWidget {
  const ListadoMascotasPage({super.key});

  static const String route = '/listado-mascotas';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListadoMascotasPageState();
}

class _ListadoMascotasPageState extends ConsumerState<ListadoMascotasPage> {
  @override
  Widget build(BuildContext context) {
    final getAllMascotasAsyncValue = ref.watch(getAllMascotasUseCase);
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Adopciones',
        goBack: () {
          GoRouter.of(context).pop();
        },
      ),
      body: getAllMascotasAsyncValue.when(
        data: (mascotasList) {
          return Padding(
            padding: const EdgeInsets.all(Margins.largeMargin),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de columnas
                crossAxisSpacing: 10.0, // Espacio horizontal entre las tarjetas
                mainAxisSpacing: 10.0, // Espacio vertical entre las tarjetas
                childAspectRatio:
                    0.7, // Ajusta la proporción entre el ancho y alto de las tarjetas
              ),
              itemCount: mascotasList.mascotasDto?.length ?? 0,
              itemBuilder: (context, index) {
                final mascota = mascotasList.mascotasDto![index];
                return buildCard(mascota);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error al cargar lista de mascotas: $error'),
        ),
      ),
    );
  }

  Widget buildCard(GetAllMascotasDto mascota) {
    var heading = mascota.nombre ?? 'Sin nombre';

    // Convertir fecha de nacimiento a un formato amigable
    String formattedDate;
    if (mascota.fechaNacimiento != null) {
      try {
        DateTime date = DateTime.parse(mascota.fechaNacimiento!);
        formattedDate = DateFormat('dd/MM/yyyy').format(date);
      } catch (e) {
        formattedDate = 'Fecha no disponible';
      }
    } else {
      formattedDate = 'Fecha no disponible';
    }

    var subheading = '${mascota.peso ?? 'N/A'} kg, $formattedDate';

    // Decodificar la imagen en Base64 a un MemoryImage
    var cardImage = mascota.imagen != null
        ? MemoryImage(base64Decode(mascota.imagen!))
        : const AssetImage('assets/images/default_pet.png') as ImageProvider;

    return GestureDetector(
      onTap: () {
        if (mascota.adoptado!) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Este ${mascota.tipoMascota?.tipo} ya fue adoptado!!')),
          );
        } else {
          context.push(
            DescripcionMascotaPage.route,
            extra: mascota, // Pasar la información de la mascota
          );
        }
      },
      child: Card(
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Ink.image(
                image: cardImage,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  heading,
                  style: const TextStyle(fontSize: 16),
                ),
                subtitle: Text(
                  subheading,
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: const Icon(Icons.favorite_outline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
