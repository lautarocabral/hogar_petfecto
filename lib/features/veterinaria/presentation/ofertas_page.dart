import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/features/veterinaria/providers/ofertas_use_case.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class OfertasPage extends ConsumerStatefulWidget {
  const OfertasPage({super.key});
  static const String route = '/ofertas';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OfertasPageState();
}

class _OfertasPageState extends ConsumerState<OfertasPage> {
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

  @override
  Widget build(BuildContext context) {
    final ofertasAsyncValue = ref.watch(ofertasUseCaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ofertas Disponibles'),
      ),
      body: ofertasAsyncValue.when(
        data: (ofertas) {
          return ListView.builder(
            itemCount: ofertas.ofertas!.length,
            itemBuilder: (context, index) {
              final oferta = ofertas.ofertas![index];

              final isExpired =
                  DateTime.now().isAfter(DateTime.parse(oferta.fechaFin!));
              final imageBytes =
                  oferta.imagen != null ? base64Decode(oferta.imagen!) : null;
              return Card(
                elevation: 5,
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        imageBytes != null ? MemoryImage(imageBytes) : null,
                    child: imageBytes == null
                        ? const Icon(Icons.pets, size: 30)
                        : null,
                  ),
                  title: Text(
                    oferta.titulo ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isExpired ? Colors.grey : Colors.black,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(oferta.descripcion ?? ''),
                      Text('Descuento: ${oferta.descuento}%'),
                      Text(
                        'Válida hasta: ${_formatDate(oferta.fechaFin)}',
                        style: TextStyle(
                          color: isExpired ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteOferta(ref, oferta.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error al cargar las ofertas: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOfertaDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _deleteOferta(WidgetRef ref, int ofertaId) async {
    await ref.read(deleteOfertaUseCaseProvider(ofertaId).future);
    ref.invalidate(ofertasUseCaseProvider);
  }

  void _showAddOfertaDialog(BuildContext context, WidgetRef ref) {
    final _ofertaFormKey = GlobalKey<FormState>();
    final tituloController = TextEditingController();
    final descripcionController = TextEditingController();
    final descuentoController = TextEditingController();
    final fechaInicioController = TextEditingController();
    final fechaFinController = TextEditingController();
    File? _dialogImage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Agregar Nueva Oferta'),
              content: Form(
                key: _ofertaFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: tituloController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.turned_in_not_outlined),
                          hintText: 'Titulo',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El título es obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5.0),
                      TextFormField(
                        controller: descripcionController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.description),
                          hintText: 'Descripcion',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              _dialogImage = File(pickedFile.path);
                            });
                          }
                        },
                        child: _dialogImage != null
                            ? Image.file(
                                _dialogImage!,
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
                      const SizedBox(height: 5.0),
                      TextFormField(
                        controller: descuentoController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.discount_outlined),
                          hintText: 'Descuento (%)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              double.tryParse(value) == null) {
                            return 'Ingrese un descuento válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5.0),
                      TextFormField(
                        controller: fechaInicioController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.date_range),
                          hintText: 'Desde',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              DateTime.tryParse(value) == null) {
                            return 'Ingrese una fecha válida';
                          }
                          return null;
                        },
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
                              fechaInicioController.text =
                                  pickedDate.toIso8601String().split('T').first;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 5.0),
                      TextFormField(
                        controller: fechaFinController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.date_range),
                          hintText: 'Hasta',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              DateTime.tryParse(value) == null) {
                            return 'Ingrese una fecha válida';
                          }
                          return null;
                        },
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now().add(Duration(days: 30)),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              fechaFinController.text =
                                  pickedDate.toIso8601String().split('T').first;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_dialogImage != null) {
                      if (_ofertaFormKey.currentState!.validate()) {
                        final bytes = await _dialogImage!.readAsBytes();
                        final base64Image = base64Encode(bytes);
                        final credentialas = {
                          'id': 0,
                          'producto': tituloController.text,
                          'imagen': base64Image,
                          'titulo': tituloController.text,
                          'descripcion': descripcionController.text,
                          'descuento': double.parse(descuentoController.text),
                          'fechaInicio': fechaInicioController.text,
                          'fechaFin': fechaFinController.text,
                          'activo': true
                        };
                        await ref.read(
                            addOfertaUseCaseProvider(credentialas).future);
                        ref.invalidate(ofertasUseCaseProvider);
                        context.pop();
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Debe subir una imagen'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDate(String? fecha) {
    if (fecha == null) {
      return 'Desconocida';
    }

    try {
      DateTime date = DateTime.parse(fecha);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return 'Fecha no válida';
    }
  }
}
