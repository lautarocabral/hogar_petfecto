import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/utils/validators.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart';
import 'package:hogar_petfecto/features/seguridad/providers/perfil_provider.dart';

class SignUpClientPage extends ConsumerStatefulWidget {
  const SignUpClientPage({super.key});
  static const String route = '/sign_up_client_page';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SignUpClientPageState();
}

class _SignUpClientPageState extends ConsumerState<SignUpClientPage> {
  final TextEditingController cuilController = TextEditingController();
  final TextEditingController ocupacionController = TextEditingController();
  final _formClienteKey = GlobalKey<FormState>();
  Future<void> registrarCliente() async {
    if (_formClienteKey.currentState?.validate() ?? false) {
      try {
        final credentials = {
          'cuil': cuilController.text,
          'ocupacion': ocupacionController.text
        };
        await ref.read(clienteProvider(credentials).future);
        _formClienteKey.currentState?.reset();
        await ScaffoldMessenger.of(context)
            .showSnackBar(
              const SnackBar(
                content: Text('Protectora Registrado con éxito'),
                duration: Duration(seconds: 2),
              ),
            )
            .closed;
        context.pop();
      } on DioException catch (e) {
        final errorMessage = e.error.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Cliente'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formClienteKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),

                // CUIL (para cliente)
                CustomTextField(
                  hintText: 'CUIL',
                  controller: cuilController,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.badge),
                  keyboardType: TextInputType.number,
                  validator: Validators.cuil,
                ),
                const SizedBox(height: 16.0),

                // Ocupación (para cliente)
                CustomTextField(
                  hintText: 'Ocupación',
                  controller: ocupacionController,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.work),
                  validator: Validators.fieldRequired,
                ),
                const SizedBox(height: 24.0),

                Center(
                  child: ElevatedButton.icon(
                    onPressed: registrarCliente,
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
