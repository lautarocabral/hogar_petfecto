import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_adoptante_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_protectora_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_veterinaria_page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String route = '/sign_up_page';

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController dniController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String selectedProvince = 'Provincia 1';
  String selectedCity = 'Localidad 1';

  // Listas de provincias y localidades
  final List<String> provinces = ['Provincia 1', 'Provincia 2', 'Provincia 3'];
  final Map<String, List<String>> citiesByProvince = {
    'Provincia 1': ['Localidad 1', 'Localidad 2'],
    'Provincia 2': ['Localidad 3', 'Localidad 4'],
    'Provincia 3': ['Localidad 5', 'Localidad 6'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Registro'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con imagen
              Center(
                child: Image.asset(
                  'assets/hogar_petfecto_logo.png',
                  scale: 5,
                ),
              ),
              const SizedBox(height: 16.0),

              // DNI
              CustomTextField(
                hintText: 'DNI',
                controller: dniController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.person), // Icono decorativo
              ),
              const SizedBox(height: 16.0),

              // Nombre o Razón Social
              CustomTextField(
                hintText: 'Nombre o Razón Social',
                controller: nameController,
                textInputAction: TextInputAction.next,
                prefixIcon:
                    const Icon(Icons.account_circle), // Icono decorativo
              ),
              const SizedBox(height: 16.0),

              // Dirección
              CustomTextField(
                hintText: 'Dirección',
                controller: addressController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.location_on), // Icono decorativo
              ),
              const SizedBox(height: 16.0),

              // Correo Electrónico
              CustomTextField(
                hintText: 'Correo Electrónico',
                controller: emailController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.email), // Icono decorativo
              ),
              const SizedBox(height: 16.0),

              // Teléfono (opcional)
              CustomTextField(
                hintText: 'Teléfono (opcional)',
                controller: phoneController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.phone), // Icono decorativo
              ),
              const SizedBox(height: 16.0),

              // Contraseña
              CustomTextField(
                hintText: 'Contraseña',
                obscureText: true,
                controller: passwordController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.lock), // Icono decorativo
              ),
              const SizedBox(height: 16.0),

              // Confirmar Contraseña
              CustomTextField(
                hintText: 'Confirmar Contraseña',
                obscureText: true,
                controller: confirmPasswordController,
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.lock_outline), // Icono decorativo
              ),
              const SizedBox(height: 24.0),

              // Provincia
              const Text('Provincia',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                value: selectedProvince,
                items: provinces.map((String province) {
                  return DropdownMenuItem<String>(
                    value: province,
                    child: Text(province),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedProvince = value!;
                    selectedCity = citiesByProvince[selectedProvince]!.first;
                  });
                },
              ),
              const SizedBox(height: 24.0),

              // Localidad
              const Text('Localidad',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                value: selectedCity,
                items: citiesByProvince[selectedProvince]!.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedCity = value!;
                  });
                },
              ),
              const SizedBox(height: 24.0),

              // Botón Continuar con ícono
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Las contraseñas no coinciden'),
                        ),
                      );
                    } else {
                      context.go('/home');
                    }
                  },
                  icon: const Icon(Icons.arrow_forward), // Icono decorativo
                  label: const Text(
                    'Ingresar',
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

              // Texto Subrayado de Iniciar Sesión
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: const Text(
                  '¿Ya tienes cuenta? Iniciar sesión',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
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
