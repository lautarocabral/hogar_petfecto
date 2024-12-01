import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/core/utils/validators.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/merchandising/models/lista_categorias_response_model.dart';
import 'package:hogar_petfecto/features/merchandising/models/lista_productos_response_model.dart';
import 'package:hogar_petfecto/features/merchandising/providers/editar_merchandising_use_case.dart';
import 'package:hogar_petfecto/features/merchandising/providers/lista_categoria_use_case.dart';
import 'package:hogar_petfecto/features/merchandising/providers/lista_merchandising_use_case.dart';
import 'package:image_picker/image_picker.dart';

class EditarProductoPage extends ConsumerStatefulWidget {
  const EditarProductoPage({
    super.key,
    required this.producto,
  });

  static const String route = '/editar_producto';

  final Productos producto;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditarProductoPageState();
}

class _EditarProductoPageState extends ConsumerState<EditarProductoPage> {
  late TextEditingController descripcionController;
  late TextEditingController stockController;
  late TextEditingController precioController;
  late TextEditingController tituloController;
  File? _image;
  late Categorias? selectedCategoria;
  final _formEditarMerchandisingKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    descripcionController =
        TextEditingController(text: widget.producto.descripcion);
    stockController =
        TextEditingController(text: widget.producto.stock.toString());
    precioController =
        TextEditingController(text: widget.producto.precio.toString());
    tituloController =
        TextEditingController(text: widget.producto.titulo);
    // Initialization moved to the build method where listaCategoriasAsyncValue is available.
    selectedCategoria = null;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _editarProducto() async {
    if (_formEditarMerchandisingKey.currentState?.validate() ?? false) {
      try {
        final base64Image =
            _image != null ? base64Encode(await _image!.readAsBytes()) : null;

        final credentials = {
          'productoId': widget.producto.id,
          'imagen': base64Image ?? widget.producto.imagen,
          'descripcion': descripcionController.text,
          'titulo': tituloController.text,
          'stock': int.parse(stockController.text),
          'precio': int.parse(double.parse(precioController.text).toStringAsFixed(0)),

          'categoriaId': selectedCategoria?.id ?? widget.producto.categoria?.id,
        };

        await ref.read(editarMerchandisingUseCaseProvider(credentials).future);

        ref.invalidate(listaMerchandisingUseCaseProvider);

        _formEditarMerchandisingKey.currentState?.reset();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto actualizado con éxito')),
        );
        Navigator.of(context).pop();
      } on DioException catch (e) {
        ref.read(apiClientProvider).handleError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final listaCategoriasAsyncValue = ref.watch(listaCategoriaUseCaseProvider);

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Editar Producto'),
      body: listaCategoriasAsyncValue.when(
        data: (listaCategoriasAsyncValue) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formEditarMerchandisingKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Editar Información del Producto',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  CustomTextField(
                    hintText: 'Titulo',
                    controller: tituloController,
                    textInputAction: TextInputAction.next,
                    validator: Validators.fieldRequired,
                    prefixIcon: const Icon(Icons.title_rounded),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 16.0),
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
                  CustomTextField(
                    hintText: 'Stock',
                    controller: stockController,
                    textInputAction: TextInputAction.next,
                    validator: Validators.fieldRequired,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextField(
                    hintText: 'Precio',
                    controller: precioController,
                    textInputAction: TextInputAction.next,
                    validator: Validators.fieldRequired,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Seleccionar Categoría',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<Categorias>(
                    value: selectedCategoria ??
                        listaCategoriasAsyncValue.categorias?.firstWhere(
                            (categoria) =>
                                categoria.id == widget.producto.categoria!.id),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.pets),
                      hintText: 'Categoria',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
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
                        selectedCategoria = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Subir Imagen del Producto',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: _image == null
                        ? (widget.producto.imagen != null
                            ? Image.memory(
                                base64Decode(widget.producto.imagen!),
                                height: 200.0,
                                fit: BoxFit.cover)
                            : const Text(
                                'No se ha seleccionado ninguna imagen.'))
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
                  Center(
                    child: ElevatedButton(
                      onPressed: _editarProducto,
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
                        'Guardar Cambios',
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
          child: Text('Error al cargar lista de categorías: $error'),
        ),
      ),
    );
  }
}
