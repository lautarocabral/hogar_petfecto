import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/features/veterinaria/providers/ofertas_use_case.dart';
import 'package:image_picker/image_picker.dart';

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

              return Card(
                elevation: 5,
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(oferta.imagen ?? ''),
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
                        isExpired
                            ? 'Oferta Expirada'
                            : 'Válida hasta: ${oferta.fechaFin}'.split(' ')[0],
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
    // await ref.read(ofertasProvider.notifier).deleteOferta(ofertaId);
  }

  void _showAddOfertaDialog(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final tituloController = TextEditingController();
    final descripcionController = TextEditingController();
    final descuentoController = TextEditingController();
    final fechaInicioController = TextEditingController();
    final fechaFinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Nueva Oferta'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: tituloController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El título es obligatorio';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                  ),
                 GestureDetector(
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
                  TextFormField(
                    controller: descuentoController,
                    decoration:
                        const InputDecoration(labelText: 'Descuento (%)'),
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
                  TextFormField(
                    controller: fechaInicioController,
                    decoration: const InputDecoration(
                        labelText: 'Fecha de Inicio (yyyy-MM-dd)'),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          DateTime.tryParse(value) == null) {
                        return 'Ingrese una fecha válida';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: fechaFinController,
                    decoration: const InputDecoration(
                        labelText: 'Fecha de Fin (yyyy-MM-dd)'),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          DateTime.tryParse(value) == null) {
                        return 'Ingrese una fecha válida';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // ref.read(ofertasProvider.notifier).addOferta(
                  //       tituloController.text,
                  //       descripcionController.text,
                  //       double.parse(descuentoController.text),
                  //       DateTime.parse(fechaInicioController.text),
                  //       DateTime.parse(fechaFinController.text),
                  //     );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}

