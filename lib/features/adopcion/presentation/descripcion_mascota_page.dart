import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_button_widget.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/confirmacion_contrato_page.dart';

class DescripcionMascotaPage extends StatelessWidget {
  const DescripcionMascotaPage({super.key});

  static const String route = '/descripcion_mascota';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Descripcion'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height / 2,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/basilio.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(Margins.smallMargin),
              child: Text(
                'Descripción de la Mascota',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(Margins.smallMargin),
              child: Text(
                'Aquí va la descripción detallada de la mascota. Puedes incluir información sobre su edad, raza, comportamiento, cuidados especiales, y cualquier otro dato relevante que el adoptante debería saber.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: Margins.largeMargin),
            // Botón de adoptar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: 'Postularme',
                  onPressed: () async {
                    context.push(ConfirmacionContratoPage.route);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
