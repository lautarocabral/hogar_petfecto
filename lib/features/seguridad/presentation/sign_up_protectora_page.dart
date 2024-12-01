import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/core/utils/validators.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/seguridad/providers/perfil_provider.dart';

class SignUpProtectoraPage extends ConsumerStatefulWidget {
  const SignUpProtectoraPage({super.key});
  static const String route = '/sign_up_protectora_page';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SignUpProtectoraPageState();
}

class _SignUpProtectoraPageState extends ConsumerState<SignUpProtectoraPage> {
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController volunteersController = TextEditingController();
  final TextEditingController mascotasController = TextEditingController();
  final _formProtectoraKey = GlobalKey<FormState>();

  Future<void> registrarProtectora() async {
    if (_formProtectoraKey.currentState?.validate() ?? false) {
      try {
        final credentials = {
          'capacidad': int.parse(capacityController.text),
          'nroVoluntarios': int.parse(volunteersController.text),
          'cantidadInicialMascotas': int.parse(mascotasController.text),
          'nombreProtectora':'',
        };

        await ref.read(protectoraProvider(credentials).future);

        _formProtectoraKey.currentState?.reset();

        await ScaffoldMessenger.of(context)
            .showSnackBar(
              const SnackBar(
                content: Text('Protectora Registrada con éxito'),
                duration: Duration(seconds: 2),
              ),
            )
            .closed;

        context.pop();
      } on DioException catch (e) {
        // Use ApiClient's handleError to display the error for non-401 errors
        ref.read(apiClientProvider).handleError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Protectora'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formProtectoraKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                CustomTextField(
                  hintText: 'Capacidad de la Protectora (cantidad de mascotas)',
                  controller: capacityController,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.home),
                  keyboardType: TextInputType.number,
                  validator: Validators.fieldRequired,
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  hintText: 'Número de Voluntarios',
                  controller: volunteersController,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.people),
                  keyboardType: TextInputType.number,
                  validator: Validators.fieldRequired,
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  hintText: 'Cantidad actual de mascotas',
                  controller: mascotasController,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.pets),
                  keyboardType: TextInputType.number,
                  validator: Validators.fieldRequired,
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: registrarProtectora,
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
      ),
    );
  }
}
