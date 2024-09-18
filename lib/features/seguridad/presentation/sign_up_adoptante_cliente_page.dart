import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart';

class SignUpAdoptanteClientePage extends StatefulWidget {
  const SignUpAdoptanteClientePage({super.key});

  static const String route = '/sign_up_adoptant_client_page';

  @override
  SignUpAdoptanteClientePageState createState() =>
      SignUpAdoptanteClientePageState();
}

class SignUpAdoptanteClientePageState
    extends State<SignUpAdoptanteClientePage> {
  final TextEditingController cuilController = TextEditingController();
  final TextEditingController ocupacionController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController mascotasController = TextEditingController();

  bool hasExperienceWithPets = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Usuario'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen decorativa
              // Center(
              //   child: Image.asset(
              //     'assets/images/signup_adoptant_client.png', // Imagen decorativa
              //     height: 150,
              //     width: 150,
              //   ),
              // ),
              const SizedBox(height: 16.0),

              // CUIL (para cliente)
              CustomTextField(
                hintText: 'CUIL',
                controller: cuilController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.badge), // Icono decorativo
              ),
              const SizedBox(height: 16.0),

              // Ocupación (para cliente)
              CustomTextField(
                hintText: 'Ocupación',
                controller: ocupacionController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.work), // Icono decorativo
              ),
              const SizedBox(height: 16.0),

              // Fecha de Nacimiento (para adoptante)
              TextField(
                // hintText: 'Fecha de Nacimiento',
                decoration:
                    const InputDecoration(labelText: 'Fecha de Nacimiento'),
                controller: birthdateController,
                textInputAction: TextInputAction.next,
                // prefixIcon: Icon(Icons.cake), // Icono decorativo
                onTap: () async {
                  // Abrir selector de fecha
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      birthdateController.text =
                          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                    });
                  }
                },
              ),
              const SizedBox(height: 16.0),

              // Experiencia con Mascotas (sí/no)
              const Text('¿Tiene experiencia con mascotas?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              SwitchListTile(
                title: const Text('Experiencia con Mascotas'),
                value: hasExperienceWithPets,
                onChanged: (bool value) {
                  setState(() {
                    hasExperienceWithPets = value;
                  });
                },
                secondary: Icon(hasExperienceWithPets
                    ? Icons.pets
                    : Icons.pets_outlined), // Cambia el ícono según el estado
              ),
              const SizedBox(height: 16.0),

              // Número de Mascotas (para adoptante)
              CustomTextField(
                hintText: 'Número de Mascotas',
                controller: mascotasController,
                textInputAction: TextInputAction.done,
                prefixIcon:
                    const Icon(Icons.format_list_numbered), // Icono decorativo
                textInputType: TextInputType.number, // Acepta solo números
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
                    'Continuar',
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
