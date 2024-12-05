import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_button_widget.dart';
import 'package:hogar_petfecto/features/seguridad/models/lista_usuarios_response_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/features/seguridad/providers/modulo_seguridad_use_case.dart';

class EditarUsuarioPage extends ConsumerStatefulWidget {
  final UsuarioDtos usuario;

  const EditarUsuarioPage({super.key, required this.usuario});

  static const String route = '/editar_usuario';

  @override
  ConsumerState<EditarUsuarioPage> createState() => _EditarUsuarioPageState();
}

class _EditarUsuarioPageState extends ConsumerState<EditarUsuarioPage> {
  late TextEditingController _emailController;
  late TextEditingController _razonSocialController;
  late final TextEditingController _passwordController =
      TextEditingController();
  late final TextEditingController _repeatPasswordController =
      TextEditingController();
  List<int> gruposSeleccionados = []; // IDs de los grupos seleccionados

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.usuario.email);
    _razonSocialController =
        TextEditingController(text: widget.usuario.persona?.razonSocial ?? '');

    // Inicializar grupos seleccionados a partir del usuario
    gruposSeleccionados =
        widget.usuario.grupos?.map((grupo) => grupo.id!).toList() ?? [];
  }

  @override
  void dispose() {
    _emailController.dispose();

    _razonSocialController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'La contraseña no puede estar vacía';
    }
    if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  String? _validateRepeatPassword(String? repeatPassword) {
    if (repeatPassword != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  Future<void> _guardarCambios() async {
    final passwordError = _validatePassword(_passwordController.text);
    final repeatPasswordError =
        _validateRepeatPassword(_repeatPasswordController.text);

    if (passwordError != null || repeatPasswordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(passwordError ?? repeatPasswordError!),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final credentials = {
      'email': _emailController.text,
      'razonSocial': _razonSocialController.text,
      'password': _passwordController.text,
      'newRoles': gruposSeleccionados,
      'dni': widget.usuario.personaDni,
    };

    await ref.read(editarUsuarioUseCaseProvider(credentials));
  }

  @override
  Widget build(BuildContext context) {
    final listaGruposAsyncValue = ref.watch(listaGruposUseCaseProvider);

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Editar usuario',
        goBack: () {
          GoRouter.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _razonSocialController,
              decoration: InputDecoration(
                labelText: 'Razón Social',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _repeatPasswordController,
              decoration: InputDecoration(
                labelText: 'Repita Contraseña',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Text(
              'Grupos',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            listaGruposAsyncValue.when(
              data: (listaGrupos) {
                final gruposDisponibles = listaGrupos.gruposDto ?? [];
                return Wrap(
                  spacing: 8.0,
                  children: gruposDisponibles.map((grupo) {
                    final isSelected = gruposSeleccionados.contains(grupo.id);
                    return ChoiceChip(
                      label: Text(grupo.descripcion ?? 'Sin descripción'),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            gruposSeleccionados.add(grupo.id!);
                          } else {
                            gruposSeleccionados.remove(grupo.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Text('Error al cargar los grupos: $error'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Guardar',
                onPressed: () {
                  _guardarCambios();
                  // _enviarCredenciales();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
