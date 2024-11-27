import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/core/utils/validators.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_button_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/adopcion/models/mascotas_for_protectoras_response_model.dart';
import 'package:hogar_petfecto/features/adopcion/providers/mascotas_use_case.dart';
import 'package:image_picker/image_picker.dart';

class EditarMascotaPage extends ConsumerStatefulWidget {
  final MascotasDto mascota;
  const EditarMascotaPage({Key? key, required this.mascota}) : super(key: key);
  static const String route = '/editar_mascota';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditarMascotaPageState();
}

class _EditarMascotaPageState extends ConsumerState<EditarMascotaPage> {
  final _formEditMascotaKey = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _pesoController;
  late TextEditingController _fechaNacimientoController;

  bool _aptoDepto = false;
  bool _aptoPerros = false;
  bool _vacunado = false;
  bool _castrado = false;
  String _sexo = 'Macho';
  int? _tipoMascotaId;
  File? _image;

  @override
  void initState() {
    super.initState();
    final mascota = widget.mascota;
    _nombreController = TextEditingController(text: mascota.nombre);
    _pesoController = TextEditingController(text: mascota.peso.toString());
    _fechaNacimientoController =
        TextEditingController(text: mascota.fechaNacimiento);
    _aptoDepto = mascota.aptoDepto!;
    _aptoPerros = mascota.aptoPerros!;
    _vacunado = mascota.vacunado!;
    _castrado = mascota.castrado!;
    _sexo = mascota.sexo!;
    // _tipoMascotaId = mascota.tipoMascota!.id;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> editarMascota() async {
    if (_formEditMascotaKey.currentState?.validate() ?? false) {
      try {
        final base64Image = _image != null
            ? base64Encode(await _image!.readAsBytes())
            : widget.mascota.imagen;

        final updatedData = {
          'tipoMascota': {
            'id': widget.mascota.tipoMascota!.id,
            'tipo': widget.mascota.tipoMascota!.tipo
          },
          'nombre': _nombreController.text,
          'peso': double.parse(_pesoController.text),
          'aptoDepto': _aptoDepto,
          'aptoPerros': _aptoPerros,
          'fechaNacimiento': _fechaNacimientoController.text,
          'castrado': _castrado,
          'sexo': _sexo,
          'vacunado': _vacunado,
          'adoptado':false,
          'imagen': base64Image,
          'descripcion': widget.mascota.descripcion,
          'id': widget.mascota.id,
        };

        await ref.read(editarMascotaUseCaseProvider(updatedData).future);

        ref.invalidate(getMascotasForProtectoraProvider);

        _formEditMascotaKey.currentState?.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mascota actualizada con éxito')),
        );
        Navigator.of(context).pop();
      } on DioException catch (e) {
        ref.read(apiClientProvider).handleError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tipoMascotaAsyncValue = ref.watch(getTipoMascotasProvider);

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Editar mascota'),
      body: tipoMascotaAsyncValue.when(
        data: (tipoMascotaAsyncValue) {
          return Padding(
            padding: const EdgeInsets.all(Margins.largeMargin),
            child: Form(
              key: _formEditMascotaKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: _image != null
                            ? Image.file(
                                _image!,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              )
                            : Image.memory(
                                base64Decode(widget.mascota.imagen!),
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    CustomTextField(
                      hintText: 'Nombre',
                      controller: _nombreController,
                      textInputAction: TextInputAction.next,
                      validator: Validators.fieldRequired,
                      prefixIcon: const Icon(Icons.pets),
                    ),
                    const SizedBox(height: 16.0),
                    CustomTextField(
                      hintText: 'Peso (kg)',
                      controller: _pesoController,
                      textInputAction: TextInputAction.next,
                      validator: Validators.fieldRequired,
                      prefixIcon: const Icon(Icons.scale),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _fechaNacimientoController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.date_range),
                        hintText: 'Fecha de nacimiento',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _fechaNacimientoController.text =
                                pickedDate.toIso8601String().split('T').first;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    SwitchListTile(
                      title: const Text('¿Apto para Departamento?'),
                      value: _aptoDepto,
                      onChanged: (bool value) {
                        setState(() {
                          _aptoDepto = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    SwitchListTile(
                      title: const Text('Apto para convivir con otros perros?'),
                      value: _aptoPerros,
                      onChanged: (bool value) {
                        setState(() {
                          _aptoPerros = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    SwitchListTile(
                      title: const Text('¿Castrado?'),
                      value: _castrado,
                      onChanged: (bool value) {
                        setState(() {
                          _castrado = value;
                        });
                      },
                    ),
                     const SizedBox(height: 16.0),
                    SwitchListTile(
                      title: const Text('Vacunado?'),
                      value: _vacunado,
                      onChanged: (bool value) {
                        setState(() {
                          _vacunado = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: CustomButton(
                        text: 'Guardar cambios',
                        onPressed: editarMascota,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Error al cargar tipo de mascotas: $error')),
      ),
    );
  }
}
