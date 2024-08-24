import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_button_widget.dart';
import 'package:image_picker/image_picker.dart';

class CargaMascota extends StatefulWidget {
  const CargaMascota({super.key});
  static const String route = '/cargar_mascota';

  @override
  _CargaMascotaState createState() => _CargaMascotaState();
}

class _CargaMascotaState extends State<CargaMascota> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de los campos de texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();

  // Variables para campos booleanos y opciones
  bool _aptoDepto = false;
  bool _aptoPerros = false;
  bool _vacunado = false;
  String _sexo = 'Macho';
  String _tipoMascota = 'Perro';
  String _estado = 'Disponible';

  // Variable para almacenar la imagen seleccionada
  File? _image;

  // Método para seleccionar la imagen
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Cargar mascota'),
      body: Padding(
        padding: const EdgeInsets.all(Margins.largeMargin),
        child: Form(
          key: _formKey,
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
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Peso de la mascota
                TextFormField(
                  controller: _pesoController,
                  decoration: const InputDecoration(labelText: 'Peso (kg)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el peso';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Fecha de nacimiento
                TextFormField(
                  controller: _fechaNacimientoController,
                  decoration:
                      const InputDecoration(labelText: 'Fecha de Nacimiento'),
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
                  decoration: const InputDecoration(labelText: 'Sexo'),
                  value: _sexo,
                  items: const [
                    DropdownMenuItem(value: 'Macho', child: Text('Macho')),
                    DropdownMenuItem(value: 'Hembra', child: Text('Hembra')),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      _sexo = value!;
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
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Tipo de Mascota'),
                  value: _tipoMascota,
                  items: const [
                    DropdownMenuItem(value: 'Perro', child: Text('Perro')),
                    DropdownMenuItem(value: 'Gato', child: Text('Gato')),
                    // Agregar más opciones según sea necesario
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      _tipoMascota = value!;
                    });
                  },
                ),
                const SizedBox(height: 16.0),

                // Estado
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Estado'),
                  value: _estado,
                  items: const [
                    DropdownMenuItem(
                        value: 'Disponible', child: Text('Disponible')),
                    DropdownMenuItem(
                        value: 'Adoptado', child: Text('Adoptado')),
                    // Agregar más opciones según sea necesario
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      _estado = value!;
                    });
                  },
                ),
                const SizedBox(height: 16.0),

                // Botón de guardar
                Center(
                  child: CustomButton(
                    text: 'Cargar mascota',
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _image != null) {
                        // Aquí puedes manejar el guardado de los datos, incluyendo la imagen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Mascota guardada con éxito'),
                          ),
                        );
                        context.pop();
                      }
                    },
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
