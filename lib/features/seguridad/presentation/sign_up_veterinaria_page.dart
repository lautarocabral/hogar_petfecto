import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/subscription_page.dart';

class SignUpVeterinariaPage extends StatefulWidget {
  const SignUpVeterinariaPage({super.key});
  static const String route = '/sign_up_veterinaria';

  @override
  SignUpVeterinariaPageState createState() => SignUpVeterinariaPageState();
}

class SignUpVeterinariaPageState extends State<SignUpVeterinariaPage> {
  final TextEditingController clinicNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: const CustomAppBarWidget(title: 'Registro de veterinaria'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre de la Veterinaria
              CustomTextField(
                hintText: 'Nombre de la Veterinaria',
                controller: clinicNameController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16.0),

              // Dirección
              CustomTextField(
                hintText: 'Dirección',
                controller: addressController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16.0),

              // Teléfono de Contacto
              CustomTextField(
                hintText: 'Teléfono de Contacto',
                controller: phoneController,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.phone,
              ),
              const SizedBox(height: 24.0),

              // Botón de Confirmación
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Aquí decides cómo avanzar a la sección de suscripción
                    context.push(SubscriptionPage.route);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size(double.infinity, 50), // Botón ancho completo
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Confirmar y Suscribirse',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
