import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_postulaciones/detalles_postulante_page.dart';

class GestionPostulacionesProtectoraPage extends ConsumerStatefulWidget {
  const GestionPostulacionesProtectoraPage({super.key});

  static const String route = '/gestion-postulaciones-protectora';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GestionPostulacionesProtectoraPageState();
}

class _GestionPostulacionesProtectoraPageState
    extends ConsumerState<GestionPostulacionesProtectoraPage> {
  // Simulación de datos: cada mascota tiene una lista de postulaciones
  final List<Map<String, dynamic>> mascotasPostuladas = [
    {
      'mascota': 'Basilio',
      'postulaciones': [
        {
          'adoptante': 'Juan Pérez',
          'status': 'Pendiente',
          'detalles': 'Juan tiene 2 perros y está interesado en adoptar.'
        },
        {
          'adoptante': 'Ana García',
          'status': 'Aceptada',
          'detalles':
              'Ana es una amante de los animales con experiencia en adopciones.'
        },
      ],
    },
    {
      'mascota': 'Firulais',
      'postulaciones': [
        {
          'adoptante': 'Carlos Rodríguez',
          'status': 'Pendiente',
          'detalles': 'Carlos vive en una casa con jardín.'
        },
      ],
    },
    {
      'mascota': 'Luna',
      'postulaciones': [
        {
          'adoptante': 'María López',
          'status': 'Pendiente',
          'detalles': 'María busca una mascota para su familia.'
        },
        {
          'adoptante': 'Pedro Sánchez',
          'status': 'Rechazada',
          'detalles': 'Pedro no tiene experiencia previa con mascotas.'
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Postulaciones Recibidas',
        goBack: () {
          GoRouter.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(Margins.largeMargin),
        child: ListView.builder(
          itemCount: mascotasPostuladas.length,
          itemBuilder: (context, index) {
            return buildMascotaSection(index);
          },
        ),
      ),
    );
  }

  // Sección para cada mascota con sus postulaciones
  Widget buildMascotaSection(int index) {
    var mascota = mascotasPostuladas[index]['mascota'];
    var postulaciones =
        mascotasPostuladas[index]['postulaciones'] as List<Map<String, String>>;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 4.0,
      child: ExpansionTile(
        title: Text(
          'Mascota: $mascota',
          style: const TextStyle(fontSize: 18),
        ),
        children: postulaciones
            .asMap()
            .entries
            .map((entry) =>
                buildPostulacionCard(entry.key, postulaciones, index))
            .toList(),
      ),
    );
  }

  // Tarjeta para cada postulación dentro de una mascota
  Widget buildPostulacionCard(int postIndex,
      List<Map<String, String>> postulaciones, int mascotaIndex) {
    var adoptante = postulaciones[postIndex]['adoptante']!;
    var status = postulaciones[postIndex]['status']!;

    return ListTile(
      contentPadding: const EdgeInsets.all(16.0),
      title: Text(
        'Adoptante: $adoptante',
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: Text('Estado: $status'),
      trailing: PopupMenuButton<String>(
        onSelected: (String result) {
          gestionarPostulacion(result, mascotaIndex, postIndex);
        },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem<String>(
            value: 'aceptar',
            child: Text('Aceptar'),
          ),
          const PopupMenuItem<String>(
            value: 'rechazar',
            child: Text('Rechazar'),
          ),
        ],
        child: const Icon(Icons.more_vert),
      ),
      onTap: () => context.push(
        DetallesPostulantePage.route,
        extra: {
          'adoptante': adoptante,
          'detalles': postulaciones[postIndex]['detalles'],
        },
      ),
    );
  }

  // Gestionar la postulación seleccionada
  void gestionarPostulacion(String accion, int mascotaIndex, int postIndex) {
    setState(() {
      if (accion == 'aceptar') {
        mascotasPostuladas[mascotaIndex]['postulaciones'][postIndex]['status'] =
            'Aceptada';
      } else if (accion == 'rechazar') {
        mascotasPostuladas[mascotaIndex]['postulaciones'][postIndex]['status'] =
            'Rechazada';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Postulación ${accion == 'aceptar' ? 'aceptada' : 'rechazada'}')),
    );
  }
}
