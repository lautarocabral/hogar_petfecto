import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_button_widget.dart';
import 'package:hogar_petfecto/features/common/presentation/custom_success_page.dart';

class ConfirmacionContratoPage extends StatelessWidget {
  const ConfirmacionContratoPage({super.key});
  static const String route = '/confirmacion_contrato';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Confirmación de Contrato'),
      body: Padding(
        padding: const EdgeInsets.all(Margins.largeMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección del contrato
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contrato de Adopción',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Margins.mediumMargin),
                    Text(
                      'Yo, [Nombre del Adoptante], con documento de identidad [Número de Documento], '
                      'me comprometo a cuidar y brindar un hogar adecuado a la mascota [Nombre de la Mascota], '
                      'un(a) [especie y raza], a partir de la fecha [Fecha de Adopción].',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: Margins.mediumMargin),
                    Text(
                      'Al aceptar este contrato, me comprometo a:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: Margins.mediumMargin),
                    Text(
                      '1. Proveer alimento, agua y refugio adecuado para la mascota.\n'
                      '2. Brindar atención veterinaria cuando sea necesario y mantener al día sus vacunas y controles de salud.\n'
                      '3. No abandonar, maltratar ni utilizar la mascota para fines ilegales o inadecuados.\n'
                      '4. Informar a la organización de cualquier cambio significativo en la situación de la mascota, incluyendo pérdida o enfermedad grave.\n'
                      '5. Devolver la mascota a la organización si, por cualquier motivo, no puedo seguir cuidándola adecuadamente.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: Margins.mediumMargin),
                    Text(
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
                context.go(
                    '${CustomSuccessPage.route}?message=¡Adopción confirmada con éxito!');
              },
            ),
          ],
        ),
      ),
    );
  }
}
