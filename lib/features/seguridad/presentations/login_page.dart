import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/state/generic_state.dart';
import 'package:hogar_petfecto/core/widgets/custom_button_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/seguridad/data/services/seguridad_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
      return 'Please enter your password';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seguridadNotifierProvider);

    return Scaffold(
      body: state is LoadingState
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(Margins.largeMargin),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style: GoogleFonts.lato(
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
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
                      const SizedBox(height: 40),
                      CustomButton(
                        text: 'Login',
                        onPressed: () async {
                          await ref
                              .read(seguridadNotifierProvider.notifier)
                              .loginUser(
                                _emailController.text,
                                _passwordController.text,
                              );
                          if (state is SuccessState) {
                            context.go('/home');
                          }
                          if (_formKey.currentState?.validate() ?? false) {}
                        },
                      ),
                      if (state is ErrorState)
                        Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
