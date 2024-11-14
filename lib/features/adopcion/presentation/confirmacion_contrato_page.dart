import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_button_widget.dart';
import 'package:hogar_petfecto/features/adopcion/models/get_all_mascotas_response_model.dart';
import 'package:hogar_petfecto/features/adopcion/providers/adopcion_use_case.dart';
import 'package:hogar_petfecto/features/common/presentation/custom_success_page.dart';
import 'package:hogar_petfecto/features/seguridad/providers/user_provider.dart';
import 'package:intl/intl.dart';

class ConfirmacionContratoPage extends ConsumerWidget {
  const ConfirmacionContratoPage({super.key, required this.mascota});
  final GetAllMascotasDto mascota;
  static const String route = '/confirmacion_contrato';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);

    String getTodayDateString() {
      final today = DateTime.now();
      return DateFormat('yyyy-MM-dd').format(today); // Adjust format as needed
    }

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Confirmación de Contrato'),
      body: Padding(
        padding: const EdgeInsets.all(Margins.largeMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección del contrato
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contrato de Adopción',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: Margins.mediumMargin),
                    Text(
                      'Yo, ${user!.persona.razonSocial}, con documento de identidad ${user!.personaDni}, '
                      'me comprometo a cuidar y brindar un hogar adecuado a la mascota ${mascota.nombre}, '
                      'un(a) [${mascota.tipoMascota?.tipo ?? 'Especie desconocida'}], a partir de la fecha ${getTodayDateString()}.',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: Margins.mediumMargin),
                    const Text(
                      'Al aceptar este contrato, me comprometo a:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: Margins.mediumMargin),
                    const Text(
                      '1. Proveer alimento, agua y refugio adecuado para la mascota.\n'
                      '2. Brindar atención veterinaria cuando sea necesario y mantener al día sus vacunas y controles de salud.\n'
                      '3. No abandonar, maltratar ni utilizar la mascota para fines ilegales o inadecuados.\n'
                      '4. Informar a la organización de cualquier cambio significativo en la situación de la mascota, incluyendo pérdida o enfermedad grave.\n'
                      '5. Devolver la mascota a la organización si, por cualquier motivo, no puedo seguir cuidándola adecuadamente.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: Margins.mediumMargin),
                    const Text(
                      'Entiendo que el incumplimiento de este contrato podría resultar en la anulación de la adopción y en la devolución de la mascota a la organización. '
                      'He leído y comprendido los términos de este contrato, y acepto cumplirlos para garantizar el bienestar de la mascota adoptada.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Margins.largeMargin),
            // Botón de aceptar
            CustomButton(
              text: 'Aceptar y Confirmar Adopción',
              onPressed: () async {
                cargarAdopcion(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  cargarAdopcion(BuildContext context, WidgetRef ref) async {
    await ref.read(cargarPostulacionUseCaseProvider(mascota.id!).future);

    // ref.invalidate(getMascotasForProtectoraProvider);
    context.go(
      '${CustomSuccessPage.route}?message=¡Adopción de ${mascota.nombre} confirmada con éxito!',
    );
  }
}

