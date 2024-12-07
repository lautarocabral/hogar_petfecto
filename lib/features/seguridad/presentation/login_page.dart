import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/core/widgets/custom_button_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/coordinator/profile_coordinator_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/recuperar_clave.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_page.dart';
import 'package:hogar_petfecto/features/seguridad/providers/auth_provider.dart';
import 'package:hogar_petfecto/features/seguridad/providers/user_provider.dart';
import 'package:permission_handler/permission_handler.dart'; // Importa tu GenericState

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  static const String route = '/';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Llamar a la función asincrónica desde initState
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    await requestPermissions();
  }

  Future<void> requestPermissions() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
    } else {
      // Si el permiso es denegado, puedes volver a solicitarlo o mostrar un mensaje.
      // También puedes verificar si el usuario ha seleccionado "No volver a preguntar".
      var newStatus = await Permission.location.request();
      if (newStatus.isPermanentlyDenied) {
        // Puedes abrir la configuración para que el usuario habilite los permisos manualmente
        openAppSettings();
      }
    }
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildLoginForm(),
    );
  }

  Widget _buildLoginForm() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Margins.largeMargin),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/hogar_petfecto_logo.png',
                scale: 0.5,
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Login',
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: 'Email',
                controller: _emailController,
                textInputAction: TextInputAction.next,
                focusNode: _emailFocusNode,
                nextFocusNode: _passwordFocusNode,
                validator: _emailValidator,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: 'Password',
                obscureText: true,
                controller: _passwordController,
                textInputAction: TextInputAction.done,
                focusNode: _passwordFocusNode,
                validator: _passwordValidator,
              ),
              const SizedBox(height: 5 ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push(RecuperarClave.route);
                    },
                    child: const Text(
                      'Recuperar clave',
                      style: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  context.push(SignUpPage.route);
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'Login',
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final credentials = {
                      'email': _emailController.text,
                      'password': _passwordController.text,
                    };

                    try {
                      await ref.read(loginProvider(credentials).future);

                      var user = ref.read(userStateNotifierProvider);
                      if (mounted) {
                        if (user!.hasToUpdateProfile.isNotEmpty) {
                          context.pushReplacement(
                            ProfileCompletionCoordinatorPage.route,
                            extra: user.hasToUpdateProfile,
                          );
                        } else {
                          context.pushReplacement('/home');
                        }
                      }
                    } on DioException catch (e) {
                      // Display the error message for non-401 errors
                      ref.read(apiClientProvider).handleError(context, e);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
