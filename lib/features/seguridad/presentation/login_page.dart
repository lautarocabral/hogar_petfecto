import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/state/generic_state.dart';
import 'package:hogar_petfecto/core/widgets/custom_button_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_page.dart';
import 'package:hogar_petfecto/features/seguridad/providers/seguridad_providers.dart';
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
    final state = ref.watch(seguridadNotifierProvider);

    return Scaffold(
      body: _buildState(state),
    );
  }

  Widget _buildState(GenericState state) {
    if (state is LoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is SuccessState) {
      // Redirige al home en caso de éxito
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
      return const SizedBox.shrink();
    } else {
      return _buildLoginForm(state);
    }
  }

  Widget _buildLoginForm(GenericState state) {
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
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  context.push(SignUpScreen.route);
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
                  // if (_formKey.currentState?.validate() ?? false) {
                  //   await ref
                  //       .read(seguridadNotifierProvider.notifier)
                  //       .loginUser(
                  //         _emailController.text,
                  //         _passwordController.text,
                  //       );
                  // }
                  context.go('/home');
                },
              ),
              if (state is ErrorState)
                Text(
                  state.message,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
