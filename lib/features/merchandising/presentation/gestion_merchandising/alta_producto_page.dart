import 'package:flutter/material.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AltaProductoPage extends StatefulWidget {
  const AltaProductoPage({super.key});

  static const String route = '/alta_producto';

  @override
  _AltaProductoPageState createState() => _AltaProductoPageState();
}

class _AltaProductoPageState extends State<AltaProductoPage> {
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  File? _image;

  // Lista de categorías simulada
  List<String> categorias = ['Categoría 1', 'Categoría 2', 'Categoría 3'];
  String? selectedCategoria;

  // Función para seleccionar una imagen desde la galería o cámara
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Alta de Producto'),
      body: SingleChildScrollView(
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
              keyboardType: TextInputType.numberWithOptions(decimal: true),
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
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              value: selectedCategoria,
              items: categorias.map((String categoria) {
                return DropdownMenuItem<String>(
                  value: categoria,
                  child: Text(categoria),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategoria = newValue;
                });
              },
              hint: const Text('Seleccione una categoría'),
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
      ),
    );
  }

  void _guardarProducto() {
    // Aquí implementas la lógica para guardar el producto
    // Accedes a los datos ingresados a través de los controladores
    final descripcion = descripcionController.text;
    final stock = int.tryParse(stockController.text) ?? 0;
    final precio = double.tryParse(precioController.text) ?? 0.0;
    final categoria = selectedCategoria;

    print(
        'Producto guardado: $descripcion, $stock unidades, precio: $precio, categoría: $categoria');

    if (_image != null) {
      print('Imagen seleccionada: ${_image!.path}');
    } else {
      print('No se ha seleccionado imagen.');
    }

    // Mostrar un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto guardado exitosamente')),
    );

    // Limpiar los campos
    descripcionController.clear();
    stockController.clear();
    precioController.clear();
    setState(() {
      selectedCategoria = null;
      _image = null;
    });
  }
}
