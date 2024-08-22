import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';

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
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Adopciones',
        goBack: () {
          GoRouter.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(Margins.largeMargin),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Número de columnas
            crossAxisSpacing: 10.0, // Espacio horizontal entre las tarjetas
            mainAxisSpacing: 10.0, // Espacio vertical entre las tarjetas
          ),
          itemCount: 10, // Número de tarjetas que quieres mostrar
          itemBuilder: (context, index) {
            return buildCard();
          },
        ),
      ),
    );
  }

  Card buildCard() {
    var heading = 'Basilio';
    var subheading = '3 años';
    var cardImage = const AssetImage('assets/images/basilio.png');
    // String supportingText = 'Convive con otros animales, apto departamento ...';
    return Card(
      elevation: 4.0,
      child: Column(
        children: [
          ListTile(
            title: Text(heading),
            subtitle: Text(subheading),
            trailing: const Icon(Icons.favorite_outline),
          ),
          SizedBox(
            height: 75.0, // Altura ajustada para la cuadrícula
            child: Ink.image(
              image: cardImage,
              fit: BoxFit.cover,
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(
          //       8.0), // Espaciado reducido para la cuadrícula
          //   alignment: Alignment.centerLeft,
          //   child: Text(supportingText),
          // ),
          // OverflowBar(
          //   children: [
          //     TextButton(
          //       child: const Text('Adoptar'),
          //       onPressed: () {/* ... */},
          //     ),
          //     TextButton(
          //       child: const Text('Mas info'),
          //       onPressed: () {/* ... */},
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
