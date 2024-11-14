import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_button_widget.dart';
import 'package:hogar_petfecto/features/adopcion/models/get_all_mascotas_response_model.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/confirmacion_contrato_page.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

class DescripcionMascotaPage extends StatelessWidget {
  final GetAllMascotasDto mascota;

  const DescripcionMascotaPage({Key? key, required this.mascota})
      : super(key: key);

  static const String route = '/descripcion_mascota';
  String _formatFechaNacimiento(String? fechaNacimiento) {
    if (fechaNacimiento == null) {
      return 'Desconocida';
    }

    try {
      DateTime date = DateTime.parse(fechaNacimiento);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'Fecha no válida';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Descripción'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height / 2,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: mascota.imagen != null
                      ? MemoryImage(base64Decode(mascota.imagen!))
                          as ImageProvider
                      : const AssetImage('assets/images/default_pet.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Margins.smallMargin),
              child: Text(
                mascota.nombre ?? 'Nombre desconocido',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Margins.smallMargin),
              child: Text(
                'Edad: ${mascota.peso ?? 'N/A'} kg \nFecha de nacimiento: ${_formatFechaNacimiento(mascota.fechaNacimiento)}',
                style: const TextStyle(fontSize: 16),
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
            Padding(
              padding: const EdgeInsets.all(Margins.smallMargin),
              child: Text(
                mascota.descripcion ??
                    'Aquí va la descripción detallada de la mascota. Puedes incluir información sobre su comportamiento, cuidados especiales y cualquier otro dato relevante.',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: Margins.largeMargin),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: 'Postularme',
                  onPressed: () async {
                    context.push(
                      ConfirmacionContratoPage.route,
                      extra:
                          mascota, // Pasamos la información de la mascota como extra
                    );
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
