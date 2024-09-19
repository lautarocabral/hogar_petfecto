import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Veterinaria {
  final int id;
  List<String> instalaciones;

  Veterinaria({
    required this.id,
    required this.instalaciones,
  });
}

class VeterinariaFacilitiesEditPage extends StatefulWidget {
  final Veterinaria veterinaria;

  const VeterinariaFacilitiesEditPage({required this.veterinaria, super.key});

  static const String route = '/veterinaria_facilities_edit';

  @override
  _VeterinariaFacilitiesEditPageState createState() =>
      _VeterinariaFacilitiesEditPageState();
}

class _VeterinariaFacilitiesEditPageState
    extends State<VeterinariaFacilitiesEditPage> {
  bool _isEditing = false;
  late List<String> _instalacionesSeleccionadas;

  List<String> todasLasInstalaciones = [
    'Sala de espera',
    'Área de cirugía',
    'Consultorios',
    'Rayos X',
    'Área de internación'
  ];

  @override
  void initState() {
    super.initState();
    _instalacionesSeleccionadas = List.from(widget.veterinaria.instalaciones);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing
              ? 'Editar Instalaciones'
              : 'Instalaciones de la Veterinaria',
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        // backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _isEditing ? _guardarInstalaciones : _toggleEditMode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Instalaciones de la Veterinaria',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),

            // Mostrar las instalaciones actuales o en modo de edición
            _isEditing ? _buildInstalacionesEdit() : _buildInstalacionesView(),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  // Modo de visualización de las instalaciones
  Widget _buildInstalacionesView() {
    if (_instalacionesSeleccionadas.isEmpty) {
      return const Text('No se han registrado instalaciones aún.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _instalacionesSeleccionadas.map((instalacion) {
        return ListTile(
          leading: const Icon(Icons.check, color: Colors.green),
          title: Text(instalacion),
        );
      }).toList(),
    );
  }

  // Modo de edición de las instalaciones
  Widget _buildInstalacionesEdit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: todasLasInstalaciones.map((instalacion) {
        return CheckboxListTile(
          title: Text(instalacion),
          value: _instalacionesSeleccionadas.contains(instalacion),
          onChanged: (bool? selected) {
            setState(() {
              if (selected == true) {
                _instalacionesSeleccionadas.add(instalacion);
              } else {
                _instalacionesSeleccionadas.remove(instalacion);
              }
            });
          },
        );
      }).toList(),
    );
  }

  // Alternar entre modo de edición y visualización
  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  // Guardar las instalaciones seleccionadas
  void _guardarInstalaciones() {
    setState(() {
      widget.veterinaria.instalaciones = List.from(_instalacionesSeleccionadas);
      _isEditing = false;
    });

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Instalaciones actualizadas')),
    );
  }
}
