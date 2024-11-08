import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/core/utils/validators.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart';
import 'package:hogar_petfecto/features/seguridad/providers/perfil_provider.dart';

class SignUpAdoptantePage extends ConsumerStatefulWidget {
  const SignUpAdoptantePage({super.key});
  static const String route = '/sign_up_adoptant_client_page';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SignUpAdoptantePageState();
}

final TextEditingController ocupacionController = TextEditingController();
final TextEditingController nromascotasController = TextEditingController();
bool hasExperienceWithPets = false;
String? estadoCivil;
final _formAdoptanteKey = GlobalKey<FormState>();

class _SignUpAdoptantePageState extends ConsumerState<SignUpAdoptantePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Adoptante'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formAdoptanteKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),

                // Número de Mascotas (para adoptante)
                CustomTextField(
                  hintText: 'Ocupacion',
                  controller: ocupacionController,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.work), // Icono decorativo
                  keyboardType: TextInputType.text, // Acepta solo números
                  validator: Validators.fieldRequired,
                ),
                const SizedBox(height: 16.0),

                // Estado Civil (para adoptante)
                DropdownButtonFormField<String>(
                  value: estadoCivil,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    labelText: 'Estado Civil',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
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
                  controller: nromascotasController,
                  textInputAction: TextInputAction.done,
                  validator: Validators.fieldRequired,
                  prefixIcon: const Icon(
                      Icons.format_list_numbered), // Icono decorativo
                  keyboardType: TextInputType.number, // Acepta solo números
                ),
                const SizedBox(height: 24.0),

                // Botón Continuar con ícono
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if ((_formAdoptanteKey.currentState?.validate() ??
                              false) &&
                          (estadoCivil?.isNotEmpty ?? false)) {
                        final credentials = {
                          'estadoCivil': estadoCivil,
                          'ocupacion': ocupacionController.text,
                          'experienciaMascotas': hasExperienceWithPets,
                          'nroMascotas': int.parse(nromascotasController.text),
                        };

                        try {
                          await ref.read(adoptanteProvider(credentials).future);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Perfil creado con exito')),
                          );
                          if (mounted) {
                            context.go(HomePage.route);
                          }
                        } on DioException catch (e) {
                          // Use ApiClient's handleError to display the error for non-401 errors
                          ref.read(apiClientProvider).handleError(context, e);
                        }
                      }
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
      ),
    );
  }
}
