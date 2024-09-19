import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';

class AltaGrupoPage extends StatefulWidget {
  const AltaGrupoPage({super.key});

  static const String route = '/alta_rol';

  @override
  AltaGrupoPageState createState() => AltaGrupoPageState();
}

class AltaGrupoPageState extends State<AltaGrupoPage> {
  final TextEditingController rolNameController = TextEditingController();

  // Lista de pantallas/funcionalidades a las que se puede asignar acceso
  final Map<String, bool> pantallasAcceso = {
    'Publicación de Animales': false,
    'Publicación de Merchandising': false,
    'Módulo de Veterinarias': false,
    'Gestión de Usuarios': false,
    'Gestión de Roles': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: const CustomAppBarWidget(title: 'Alta grupo'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre del Grupo',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 10.0),

            // Campo de texto para el nombre del rol
            TextField(
              controller: rolNameController,
              decoration: InputDecoration(
                labelText: 'Ingrese el nombre del rol',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),

            const SizedBox(height: 20.0),

            // Checkbox para seleccionar pantallas
            Text(
              'Acceso a Pantallas',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 10.0),

            // Lista de checkboxes para elegir a qué pantallas puede acceder el rol
            Expanded(
              child: ListView(
                children: pantallasAcceso.keys.map((String pantalla) {
                  return CheckboxListTile(
                    title: Text(
                      pantalla,
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                    value: pantallasAcceso[pantalla],
                    onChanged: (bool? value) {
                      setState(() {
                        pantallasAcceso[pantalla] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20.0),

            // Botón para guardar el nuevo rol
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Acción para guardar el nuevo rol
                  _guardarRol();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text(
                  'Guardar Rol',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _guardarRol() {
    // Aquí implementas la lógica para guardar el rol
    // Puedes acceder al nombre del rol con rolNameController.text
    // Y a las pantallas seleccionadas con pantallasAcceso

    final selectedPantallas = pantallasAcceso.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    // Guardar el rol y las pantallas permitidas
    print('Nuevo rol: ${rolNameController.text}');
    print('Acceso a las pantallas: $selectedPantallas');

    // Mostrar mensaje de éxito o redirigir a otra pantalla
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rol guardado exitosamente')),
    );

    // Limpiar formulario
    rolNameController.clear();
    setState(() {
      pantallasAcceso.updateAll((key, value) => false);
    });
  }
}
