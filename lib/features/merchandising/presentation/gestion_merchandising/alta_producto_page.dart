import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/core/utils/validators.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/merchandising/models/lista_categorias_response_model.dart';
import 'package:hogar_petfecto/features/merchandising/providers/alta_merchandising_use_case.dart';
import 'package:hogar_petfecto/features/merchandising/providers/lista_categoria_use_case.dart';
import 'package:hogar_petfecto/features/merchandising/providers/lista_merchandising_use_case.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AltaProductoPage extends ConsumerStatefulWidget {
  const AltaProductoPage({super.key});
  static const String route = '/alta_producto';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AltaProductoPageState();
}

class _AltaProductoPageState extends ConsumerState<AltaProductoPage> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  File? _image;
  final _formCargaMerchandisingKey = GlobalKey<FormState>();

  // Lista de categorías simulada
  Categorias? selectedCategoria;

  // Función para seleccionar una imagen desde la galería o cámara
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _guardarProducto() async {
    if (_image != null) {
      if (_formCargaMerchandisingKey.currentState?.validate() ?? false) {
        try {
          final bytes = await _image!.readAsBytes();
          final base64Image = base64Encode(bytes);

          final credentials = {
            'imagen': base64Image,
            'productoId': 0,
            'descripcion': descripcionController.text,
            'titulo': tituloController.text,
            'stock': int.parse(stockController.text),
            'precio': int.parse(precioController.text),
            'categoriaId': selectedCategoria?.id,
          };

          // Call provider to save the mascota
          await ref.read(altaMerchandisingUseCaseProvider(credentials).future);

          // Invalidate getMascotasForProtectoraProvider to refresh the list
          ref.invalidate(listaMerchandisingUseCaseProvider);

          _formCargaMerchandisingKey.currentState?.reset();

          await ScaffoldMessenger.of(context)
              .showSnackBar(
                const SnackBar(
                  content: Text('Producto cargado con éxito'),
                  duration: Duration(seconds: 1),
                ),
              )
              .closed;

          context.pop();
        } on DioException catch (e) {
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
    final listaCategoriasAsyncValue = ref.watch(listaCategoriaUseCaseProvider);
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Alta de Producto'),
      body: listaCategoriasAsyncValue.when(
        data: (listaCategoriasAsyncValue) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formCargaMerchandisingKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información del Producto',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  // Campo de Titulo
                  CustomTextField(
                    hintText: 'Titulo',
                    controller: tituloController,
                    textInputAction: TextInputAction.next,
                    validator: Validators.fieldRequired,
                    prefixIcon: const Icon(Icons.title_rounded),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 16.0),
                  // Campo de descripción
                  TextFormField(
                    controller: descripcionController,
                    maxLines: 5,
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
                  // Campo de stock
                  CustomTextField(
                    hintText: 'Stock',
                    controller: stockController,
                    textInputAction: TextInputAction.next,
                    validator: Validators.fieldRequired,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16.0),

                  // Campo de precio
                  CustomTextField(
                    hintText: 'Precio',
                    controller: precioController,
                    textInputAction: TextInputAction.next,
                    validator: Validators.fieldRequired,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16.0),
                  // Dropdown para categoría
                  const Text(
                    'Seleccionar Categoría',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<Categorias>(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.pets),
                      hintText: 'Categoria',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    value: selectedCategoria,
                    items: listaCategoriasAsyncValue.categorias
                        ?.map<DropdownMenuItem<Categorias>>(
                            (Categorias categoria) {
                      return DropdownMenuItem<Categorias>(
                        value: categoria,
                        child: Text(categoria.nombre ?? ''),
                      );
                    }).toList(),
                    onChanged: (Categorias? newValue) {
                      setState(() {
                        selectedCategoria = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Sección para seleccionar una imagen
                  const Text(
                    'Subir Imagen del Producto',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: _image == null
                        ? const Text('No se ha seleccionado ninguna imagen.')
                        : Image.file(_image!, height: 200.0, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 16.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Cámara'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo),
                        label: const Text('Galería'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),

                  // Botón para guardar el producto
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedCategoria == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Debe seleccionar una categoria'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } else {
                          _guardarProducto();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Text(
                        'Guardar Producto',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error al cargar lista de mascotas: $error'),
        ),
      ),
    );
  }
}
