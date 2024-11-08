import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/core/utils/validators.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/seguridad/providers/auth_provider.dart';
import 'package:hogar_petfecto/features/seguridad/providers/localidad_provincia_provider.dart';
import 'package:hogar_petfecto/features/seguridad/models/provincia_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/models/localidad_response_model.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});
  static const String route = '/sign_up_page';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final TextEditingController dniController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  ProvinciaDtos? selectedProvince;
  LocalidadDtos? selectedCity;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Obtenemos las provincias
    final provinciaAsyncValue = ref.watch(provinciaProvider);

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Registro'),
      body: provinciaAsyncValue.when(
        data: (provinces) {
          selectedProvince ??= provinces.isNotEmpty ? provinces.first : null;

          final localidadAsyncValue =
              ref.watch(localidadProvider(selectedProvince!.id!));

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/hogar_petfecto_logo.png',
                        scale: 2,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    CustomTextField(
                      hintText: 'DNI',
                      controller: dniController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.person),
                      validator: Validators.dni,
                    ),
                    const SizedBox(height: 16.0),
                    CustomTextField(
                      hintText: 'Nombre o Razón Social',
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.account_circle),
                      validator: Validators.fieldRequired,
                    ),
                    const SizedBox(height: 16.0),
                    // Fecha de Nacimiento (para adoptante)
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.date_range),
                        // hintText: hintText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
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
                            // birthdateController.text =
                            //     '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                            birthdateController.text = pickedDate
                                .toUtc()
                                .toIso8601String()
                                .split('T')
                                .first;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Dirección
                    CustomTextField(
                      hintText: 'Dirección',
                      controller: addressController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.location_on),
                      validator: Validators.fieldRequired,
                    ),
                    const SizedBox(height: 16.0),

                    // Correo Electrónico
                    CustomTextField(
                      hintText: 'Correo Electrónico',
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.email),
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16.0),

                    // Teléfono (opcional)
                    CustomTextField(
                      hintText: 'Teléfono (opcional)',
                      controller: phoneController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.phone),
                      validator: Validators.fieldRequired,
                    ),
                    const SizedBox(height: 16.0),

                    // Contraseña
                    CustomTextField(
                      hintText: 'Contraseña',
                      obscureText: true,
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.lock),
                      validator: Validators.fieldRequired,
                    ),
                    const SizedBox(height: 16.0),

                    // Confirmar Contraseña
                    CustomTextField(
                      hintText: 'Confirmar Contraseña',
                      obscureText: true,
                      controller: confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(Icons.lock_outline),
                      validator: (pass) {
                        if (pass != passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24.0),
                    const SizedBox(height: 8),
                    // Dropdown para Provincias
                    DropdownButtonFormField<ProvinciaDtos>(
                      value: selectedProvince,
                      items: provinces.map<DropdownMenuItem<ProvinciaDtos>>(
                          (ProvinciaDtos province) {
                        return DropdownMenuItem<ProvinciaDtos>(
                          value: province,
                          child: Text(province.provinciaNombre ?? ''),
                        );
                      }).toList(),
                      onChanged: (ProvinciaDtos? newValue) {
                        setState(() {
                          selectedProvince = newValue!;
                          selectedCity =
                              null; // Reseteamos la localidad al cambiar de provincia
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Provincia'),
                    ),
                    const SizedBox(height: 8),
                    // Dropdown para Localidades (dependiente de la provincia seleccionada)
                    localidadAsyncValue.when(
                      data: (cities) {
                        selectedCity ??=
                            cities.isNotEmpty ? cities.first : null;

                        return DropdownButtonFormField<LocalidadDtos>(
                          value: selectedCity,
                          items: cities.map<DropdownMenuItem<LocalidadDtos>>(
                              (LocalidadDtos city) {
                            return DropdownMenuItem<LocalidadDtos>(
                              value: city,
                              child: Text(city.localidadNombre ?? ''),
                            );
                          }).toList(),
                          onChanged: (LocalidadDtos? newValue) {
                            setState(() {
                              selectedCity = newValue;
                            });
                          },
                          decoration:
                              const InputDecoration(labelText: 'Localidad'),
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stackTrace) => Center(
                        child: Text('Error al cargar localidades: $error'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            try {
                              final credentials = {
                                'dni': dniController.text,
                                'razonSocial': nameController.text,
                                'localidadId': selectedCity!.id,
                                'direccion': addressController.text,
                                'telefono': phoneController.text,
                                'fechaNacimiento': birthdateController.text,
                                'email': emailController.text,
                                'password': passwordController.text,
                              };
                              await ref
                                  .read(signUpProvider(credentials).future);
                              _formKey.currentState?.reset();

                              await ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Usuario Registrado con éxito'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  )
                                  .closed;
                              context.pop();
                            } on DioException catch (e) {
                              // Use ApiClient's handleError to display the error
                              ref
                                  .read(apiClientProvider)
                                  .handleError(context, e);
                            }
                          }
                          // context.go('/home');
                        },
                        icon:
                            const Icon(Icons.arrow_forward), // Icono decorativo
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
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error al cargar provincias: $error'),
        ),
      ),
    );
  }
}
