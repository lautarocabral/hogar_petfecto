import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/core/utils/validators.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_button_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/adopcion/providers/mascotas_use_case.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AltaMascotaPage extends ConsumerStatefulWidget {
  const AltaMascotaPage({super.key});
  static const String route = '/alta_mascota';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AltaMascotaPageState();
}

class _AltaMascotaPageState extends ConsumerState<AltaMascotaPage> {
  final _formCargaMascotaKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  bool _aptoDepto = false;
  bool _aptoPerros = false;
  bool _vacunado = false;
  bool _castrado = false;
  String _sexo = 'Macho';
  int? _tipoMascotaId;
  // String _estado = 'Disponible';

  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> cargarMascota() async {
    if (_image != null) {
      if (_formCargaMascotaKey.currentState?.validate() ?? false) {
        try {
          final bytes = await _image!.readAsBytes();
          final base64Image = base64Encode(bytes);

          final credentials = {
            'tipoMascota': _tipoMascotaId,
            'nombre': _nombreController.text,
            'peso': double.parse(_pesoController.text),
            'aptoDepto': _aptoDepto,
            'aptoPerros': _aptoPerros,
            'fechaNacimiento': _fechaNacimientoController.text,
            'castrado': _castrado,
            'sexo': _sexo,
            'descripcion': _descripcionController.text,
            'vacunado': _vacunado,
            'adoptado': false,
            'imagen': base64Image,
          };

          // Call provider to save the mascota
          await ref.read(cargarMascotasProvider(credentials).future);

          // Invalidate getMascotasForProtectoraProvider to refresh the list
          ref.invalidate(getMascotasForProtectoraProvider);

          _formCargaMascotaKey.currentState?.reset();

          await ScaffoldMessenger.of(context)
              .showSnackBar(
                const SnackBar(
                  content: Text('Mascota Registrada con éxito'),
                  duration: Duration(seconds: 1),
                ),
              )
              .closed;

          context.pop();
        } on DioException catch (e) {
          // Use ApiClient's handleError to display the error for non-401 errors
          ref.read(apiClientProvider).handleError(context, e);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe subir una imagen'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tipoMascotaAsyncValue = ref.watch(getTipoMascotasProvider);
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Cargar mascota'),
      body: tipoMascotaAsyncValue.when(
        data: (tipoMascotaAsyncValue) {
          return Padding(
            padding: const EdgeInsets.all(Margins.largeMargin),
            child: Form(
              key: _formCargaMascotaKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen de la mascota
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
                            : Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey,
                                  size: 100,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Nombre de la mascota
                    CustomTextField(
                      hintText: 'Nombre',
                      controller: _nombreController,
                      textInputAction: TextInputAction.next,
                      validator: Validators.fieldRequired,
                      prefixIcon: const Icon(Icons.pets), // Icono decorativo
                      keyboardType: TextInputType.text, // Acepta solo números
                    ),
                    const SizedBox(height: 16.0),
                    CustomTextField(
                      hintText: 'Peso (kg)',
                      controller: _pesoController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el peso';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Por favor ingrese un número válido';
                        }
                        return null;
                      },
                      prefixIcon: const Icon(
                          Icons.format_list_numbered), // Icono decorativo
                      keyboardType: TextInputType.number, // Acepta solo números
                    ),
                    const SizedBox(height: 16.0),

                    // Fecha de nacimiento
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
                            // birthdateController.text =
                            //     '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                            _fechaNacimientoController.text = pickedDate
                                .toUtc()
                                .toIso8601String()
                                .split('T')
                                .first;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor seleccione la fecha de nacimiento';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Apto para departamento
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

                    // Apto para vivir con perros
                    SwitchListTile(
                      title: const Text('¿Apto para Vivir con Perros?'),
                      value: _aptoPerros,
                      onChanged: (bool value) {
                        setState(() {
                          _aptoPerros = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Sexo
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.pets),
                        hintText: 'Género',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      value: _sexo,
                      items: const [
                        DropdownMenuItem(value: 'Macho', child: Text('Macho')),
                        DropdownMenuItem(
                            value: 'Hembra', child: Text('Hembra')),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _sexo = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    SwitchListTile(
                      title: const Text('Castrado?'),
                      value: _castrado,
                      onChanged: (bool value) {
                        setState(() {
                          _castrado = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // Vacunado
                    SwitchListTile(
                      title: const Text('¿Vacunado?'),
                      value: _vacunado,
                      onChanged: (bool value) {
                        setState(() {
                          _vacunado = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Tipo de Mascota
                    DropdownButtonFormField<int>(
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor ingrese el tipo de mascota';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.pets),
                        hintText: 'Tipo de mascota',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      value: _tipoMascotaId,
                      items: tipoMascotaAsyncValue.tiposMascotas?.map((tipo) {
                        return DropdownMenuItem(
                          value: tipo.id,
                          child: Text(tipo.tipo ?? ''),
                        );
                      }).toList(),
                      onChanged: (int? value) {
                        setState(() {
                          _tipoMascotaId = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _descripcionController,
                      maxLines:
                          5,
                      validator: Validators.fieldRequired,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.pets),
                        hintText: 'Descripcion',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Botón de guardar
                    Center(
                      child: CustomButton(
                        text: 'Cargar mascota',
                        onPressed: cargarMascota,
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
          child: Text('Error al cargar tipo de mascotas: $error'),
        ),
      ),
    );
  }
}
