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
import 'package:hogar_petfecto/features/seguridad/providers/modulo_seguridad_use_case.dart';

class RecuperarClave extends ConsumerStatefulWidget {
  const RecuperarClave({super.key});

  static const String route = '/password-recovery';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecuperarClaveState();
}

class _RecuperarClaveState extends ConsumerState<RecuperarClave> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your new password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPasswordRecoveryForm(),
    );
  }

  Widget _buildPasswordRecoveryForm() {
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Recuperacion de contaseña',
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headlineSmall,
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
                hintText: 'New Password',
                obscureText: true,
                controller: _newPasswordController,
                textInputAction: TextInputAction.done,
                focusNode: _passwordFocusNode,
                validator: _passwordValidator,
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'Recuperar Clave',
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final credentials = {
                      'email': _emailController.text,
                      'newPassword': _newPasswordController.text,
                    };

                    try {
                      await ref.read(
                          recuperarClaveUseCaseProvider(credentials).future);

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Clave recuperada con exito!'),
                          ),
                        );
                        context.pushReplacement('/');
                      }
                    } on DioException catch (e) {
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
