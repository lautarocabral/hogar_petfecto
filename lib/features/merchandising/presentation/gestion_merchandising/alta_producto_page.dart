import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/merchandising/models/lista_categorias_response_model.dart';
import 'package:hogar_petfecto/features/merchandising/providers/lista_categoria_use_case.dart';
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
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  File? _image;

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

  void _guardarProducto() {}

  @override
  Widget build(BuildContext context) {
    final listaCategoriasAsyncValue = ref.watch(listaCategoriaUseCaseProvider);
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Alta de Producto'),
      body: listaCategoriasAsyncValue.when(
        data: (listaCategoriasAsyncValue) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Información del Producto',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),

                // Campo de descripción
                TextField(
                  controller: descripcionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Campo de stock
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Campo de precio
                TextField(
                  controller: precioController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Precio',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Dropdown para categoría
                const Text(
                  'Seleccionar Categoría',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                DropdownButtonFormField<Categorias>(
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
                  decoration: const InputDecoration(labelText: 'Categoria'),
                ),
                const SizedBox(height: 16.0),

                // Sección para seleccionar una imagen
                const Text(
                  'Subir Imagen del Producto',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                      _guardarProducto();
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
