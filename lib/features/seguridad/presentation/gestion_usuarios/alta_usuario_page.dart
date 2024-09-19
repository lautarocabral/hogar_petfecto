import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/subscription_page.dart';

enum UserType { ClienteAdoptante, Protectora, Veterinaria }

class AltaUsuarioPage extends StatefulWidget {
  const AltaUsuarioPage({super.key});

  static const String route = '/alta_usuario';

  @override
  AltaUsuarioPageState createState() => AltaUsuarioPageState();
}

class AltaUsuarioPageState extends State<AltaUsuarioPage> {
  final TextEditingController dniController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController localidadController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Campos adicionales
  final TextEditingController cuilController = TextEditingController();
  final TextEditingController ocupacionController = TextEditingController();
  final TextEditingController fechaNacimientoController =
      TextEditingController();
  final TextEditingController capacidadController = TextEditingController();
  final TextEditingController voluntariosController = TextEditingController();
  final TextEditingController mascotasController = TextEditingController();

  bool experienciaMascotas = false;
  UserType selectedUserType = UserType.ClienteAdoptante;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Alta usuario'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tipo de Usuario
            Text(
              'Tipo de Usuario',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<UserType>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              value: selectedUserType,
              items: UserType.values.map((UserType type) {
                return DropdownMenuItem<UserType>(
                  value: type,
                  child: Text(
                    type.toString().split('.').last,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (UserType? value) {
                setState(() {
                  selectedUserType = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),

            // Formulario Común
            _buildFormularioComun(),

            const SizedBox(height: 20.0),

            // Campos específicos según el tipo de usuario
            if (selectedUserType == UserType.ClienteAdoptante)
              _buildFormularioClienteAdoptante()
            else if (selectedUserType == UserType.Protectora)
              _buildFormularioProtectora()
            else if (selectedUserType == UserType.Veterinaria)
              _buildFormularioVeterinaria(),

            const SizedBox(height: 20.0),

            if(selectedUserType != UserType.Veterinaria)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Validación y envío del formulario
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text(
                  'Guardar Usuario',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Formulario Común (para todos los tipos de usuario)
  Column _buildFormularioComun() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hintText: 'DNI',
          controller: dniController,
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          hintText: 'Nombre o Razón Social',
          controller: nombreController,
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          hintText: 'Dirección',
          controller: direccionController,
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          hintText: 'Localidad',
          controller: localidadController,
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          hintText: 'Correo Electrónico',
          controller: emailController,
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          hintText: 'Teléfono (opcional)',
          controller: telefonoController,
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          hintText: 'Nombre de Usuario',
          controller: usernameController,
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          hintText: 'Contraseña',
          controller: passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          hintText: 'Confirmar Contraseña',
          controller: confirmPasswordController,
          obscureText: true,
        ),
      ],
    );
  }

  // Formulario para Cliente/Adoptante
  Column _buildFormularioClienteAdoptante() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hintText: 'CUIL',
          controller: cuilController,
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          hintText: 'Ocupación',
          controller: ocupacionController,
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          hintText: 'Fecha de Nacimiento',
          controller: fechaNacimientoController,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              setState(() {
                fechaNacimientoController.text =
                    '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
              });
            }
          },
        ),
        const SizedBox(height: 10.0),
        SwitchListTile(
          title: const Text('¿Tiene experiencia con mascotas?'),
          value: experienciaMascotas,
          onChanged: (bool value) {
            setState(() {
              experienciaMascotas = value;
            });
          },
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          hintText: 'Número de Mascotas',
          controller: mascotasController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // Formulario para Protectora
  Column _buildFormularioProtectora() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hintText: 'Capacidad de la Protectora',
          controller: capacidadController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          hintText: 'Número de Voluntarios',
          controller: voluntariosController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          hintText: 'Cantidad de Mascotas bajo Cuidado',
          controller: mascotasController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // Formulario para Veterinaria
  Column _buildFormularioVeterinaria() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Los datos específicos de veterinarias se redireccionarán para el ingreso de tarjetas.',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () {
            context.push(SubscriptionPage.route);
          },
          child: const Text('Ingresar Datos de Tarjetas'),
        ),
      ],
    );
  }
}

