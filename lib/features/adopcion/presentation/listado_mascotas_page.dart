import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/descripcion_mascota_page.dart';

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
            childAspectRatio: 0.7, // Ajusta la proporción entre el ancho y alto de las tarjetas
          ),
          itemCount: 10, // Número de tarjetas que quieres mostrar
          itemBuilder: (context, index) {
            return buildCard();
          },
        ),
      ),
    );
  }

  Widget buildCard() {
    var heading = 'Basilio';
    var subheading = '3 años';
    var cardImage = const AssetImage('assets/images/basilio.png');

    return GestureDetector(
      onTap: () => context.push(DescripcionMascotaPage.route),
      child: Card(
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Asegura que los hijos ocupen todo el ancho disponible
          children: [
            Expanded(
              child: Ink.image(
                image: cardImage,
                fit: BoxFit.cover, // Ajusta la imagen sin recortes
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                contentPadding: EdgeInsets.zero, // Elimina el padding adicional del ListTile
                title: Text(
                  heading,
                  style: const TextStyle(fontSize: 16), // Ajusta el tamaño del texto
                ),
                subtitle: Text(
                  subheading,
                  style: const TextStyle(fontSize: 14), // Ajusta el tamaño del subtítulo
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
