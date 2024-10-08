import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart';

class SignUpAdoptantePage extends StatefulWidget {
  const SignUpAdoptantePage({super.key});

  static const String route = '/sign_up_adoptant_client_page';

  @override
  SignUpAdoptantePageState createState() => SignUpAdoptantePageState();
}

class SignUpAdoptantePageState extends State<SignUpAdoptantePage> {
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController mascotasController = TextEditingController();
  bool hasExperienceWithPets = false;
  String? estadoCivil; // Variable para almacenar el estado civil seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Adoptante'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),

              // Fecha de Nacimiento (para adoptante)
              TextField(
                decoration:
                    const InputDecoration(labelText: 'Fecha de Nacimiento'),
                controller: birthdateController,
                textInputAction: TextInputAction.next,
                onTap: () async {
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

              // Estado Civil (para adoptante)
              DropdownButtonFormField<String>(
                value: estadoCivil,
                decoration: const InputDecoration(labelText: 'Estado Civil'),
                items: ['Soltero/a', 'Casado/a', 'Divorciado/a', 'Viudo/a']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    estadoCivil = newValue;
                  });
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
                secondary: Icon(
                  hasExperienceWithPets ? Icons.pets : Icons.pets_outlined,
                ), // Cambia el ícono según el estado
              ),
              const SizedBox(height: 16.0),

              // Número de Mascotas (para adoptante)
              CustomTextField(
                hintText: 'Número de Mascotas',
                controller: mascotasController,
                textInputAction: TextInputAction.done,
                prefixIcon:
                    const Icon(Icons.format_list_numbered), // Icono decorativo
                keyboardType: TextInputType.number, // Acepta solo números
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
