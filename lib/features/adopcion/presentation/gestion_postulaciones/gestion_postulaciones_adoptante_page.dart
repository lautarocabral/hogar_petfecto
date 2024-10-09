import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';

class GestionPostulacionesAdoptantePage extends ConsumerStatefulWidget {
  const GestionPostulacionesAdoptantePage({super.key});

  static const String route = '/gestion-postulaciones-adoptante';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GestionPostulacionesAdoptantePageState();
}

class _GestionPostulacionesAdoptantePageState
    extends ConsumerState<GestionPostulacionesAdoptantePage> {
  final List<Map<String, String>> postulaciones = [
    {'name': 'Basilio', 'age': '3 años', 'status': 'Pendiente'},
    {'name': 'Firulais', 'age': '5 años', 'status': 'Aceptada'},
    {'name': 'Luna', 'age': '1 año', 'status': 'Pendiente'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Mis Postulaciones',
        goBack: () {
          GoRouter.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(Margins.largeMargin),
        child: ListView.builder(
          itemCount: postulaciones.length,
          itemBuilder: (context, index) {
            return buildPostulacionCard(index);
          },
        ),
      ),
    );
  }

  Widget buildPostulacionCard(int index) {
    var name = postulaciones[index]['name']!;
    var age = postulaciones[index]['age']!;
    var status = postulaciones[index]['status']!;

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
                eliminarPostulacion(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  void eliminarPostulacion(int index) {
    setState(() {
      postulaciones.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Postulación eliminada')),
    );
  }
}
