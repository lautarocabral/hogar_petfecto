import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart';

class SignUpProtectoraPage extends StatefulWidget {
  const SignUpProtectoraPage({super.key});

  static const String route = '/sign_up_protectora_page';

  @override
  SignUpProtectoraPageState createState() => SignUpProtectoraPageState();
}

class SignUpProtectoraPageState extends State<SignUpProtectoraPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController volunteersController = TextEditingController();
  final TextEditingController mascotasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Protectora'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen decorativa
              // Center(
              //   child: Image.asset(
              //     'assets/images/signup_protectora.png', // Imagen decorativa
              //     height: 150,
              //     width: 150,
              //   ),
              // ),
              const SizedBox(height: 16.0),

              // // Dirección
              // CustomTextField(
              //   hintText: 'Dirección de la Protectora',
              //   controller: addressController,
              //   textInputAction: TextInputAction.next,
              //   prefixIcon: const Icon(Icons.location_on), // Icono decorativo
              // ),
              // const SizedBox(height: 16.0),

              CustomTextField(
                hintText: 'Capacidad de la Protectora (cantidad de mascotas)',
                controller: capacityController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.home),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),

              CustomTextField(
                hintText: 'Número de Voluntarios',
                controller: volunteersController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.people),
                keyboardType: TextInputType.number,
              ),
              
              const SizedBox(height: 24.0),

              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.go(HomePage.route);
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text(
                    'Registrarme',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
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
