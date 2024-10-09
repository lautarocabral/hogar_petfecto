import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart';

class SignUpClientPage extends StatefulWidget {
  const SignUpClientPage({super.key});

  static const String route = '/sign_up_client_page';

  @override
  SignUpClientPageState createState() => SignUpClientPageState();
}

class SignUpClientPageState extends State<SignUpClientPage> {
  final TextEditingController cuilController = TextEditingController();
  final TextEditingController ocupacionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Cliente'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),

              // CUIL (para cliente)
              CustomTextField(
                hintText: 'CUIL',
                controller: cuilController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.badge), // Icono decorativo
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),

              // Ocupación (para cliente)
              CustomTextField(
                hintText: 'Ocupación',
                controller: ocupacionController,
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.work), // Icono decorativo
              ),
              const SizedBox(height: 24.0),

              // Botón Continuar con ícono
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Acción de continuación
                    context.go(HomePage.route);
                  },
                  icon: const Icon(Icons.arrow_forward), // Icono decorativo
                  label: const Text(
                    'Registrarme',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        Colors.blueAccent, // Cambia el color del botón
                    backgroundColor:
                        Colors.white, // Cambia el color del texto/ícono
                    minimumSize: const Size(
                        double.infinity, 50), // Botón de ancho completo
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
