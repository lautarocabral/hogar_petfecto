import 'package:flutter/material.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AltaMascotaPage extends StatefulWidget {
  const AltaMascotaPage({super.key});

  static const String route = '/alta_mascota';

  @override
  AltaMascotaPageState createState() => AltaMascotaPageState();
}

class AltaMascotaPageState extends State<AltaMascotaPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController fechaNacimientoController =
      TextEditingController();

  bool aptoDepto = false;
  bool aptoPerros = false;
  bool vacunado = false;
  String? selectedSexo;
  String? selectedEstado;
  String? selectedTipoMascota;

  File? _image;

  // Lista simulada de tipos de mascotas y estados
  List<String> tiposMascota = ['Perro', 'Gato'];
  List<String> estadosMascota = ['Disponible', 'Adoptado', 'En tratamiento'];

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
      appBar: const CustomAppBarWidget(title: 'Cargar mascota'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información de la Mascota',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),

            // Campo de nombre
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre de la Mascota',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Dropdown para tipo de mascota
            const Text(
              'Tipo de Mascota',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              value: selectedTipoMascota,
              items: tiposMascota.map((String tipo) {
                return DropdownMenuItem<String>(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedTipoMascota = newValue;
                });
              },
              hint: const Text('Seleccione un tipo de mascota'),
            ),
            const SizedBox(height: 16.0),

            // Campo de peso
            TextField(
              controller: pesoController,
              keyboardType:const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Peso (kg)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Fecha de nacimiento
            TextField(
              controller: fechaNacimientoController,
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
                    fechaNacimientoController.text =
                        '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Fecha de Nacimiento',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Selección de apto para departamento y perros
            SwitchListTile(
              title: const Text('¿Apto para departamento?'),
              value: aptoDepto,
              onChanged: (bool value) {
                setState(() {
                  aptoDepto = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('¿Apto para convivir con perros?'),
              value: aptoPerros,
              onChanged: (bool value) {
                setState(() {
                  aptoPerros = value;
                });
              },
            ),

            // Dropdown para sexo
            const SizedBox(height: 10.0),
            const Text(
              'Sexo',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              value: selectedSexo,
              items: ['Macho', 'Hembra'].map((String sexo) {
                return DropdownMenuItem<String>(
                  value: sexo,
                  child: Text(sexo),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSexo = newValue;
                });
              },
              hint: const Text('Seleccione el sexo'),
            ),

            // Selección de estado de vacunación
            SwitchListTile(
              title: const Text('¿Está vacunado?'),
              value: vacunado,
              onChanged: (bool value) {
                setState(() {
                  vacunado = value;
                });
              },
            ),

            // Dropdown para estado
            const SizedBox(height: 10.0),
            const Text(
              'Estado de la Mascota',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              value: selectedEstado,
              items: estadosMascota.map((String estado) {
                return DropdownMenuItem<String>(
                  value: estado,
                  child: Text(estado),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedEstado = newValue;
                });
              },
              hint: const Text('Seleccione un estado'),
            ),
            const SizedBox(height: 16.0),

            // Sección para subir imagen de la mascota
            const Text(
              'Subir Imagen de la Mascota',
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

            // Botón para guardar la mascota
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // _guardarMascota();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text(
                  'Guardar Mascota',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}