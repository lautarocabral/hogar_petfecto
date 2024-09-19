import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_mascota/alta_mascota_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/gestion_merchandising/lista_productos_page.dart';

class Mascota {
  final int id;
  final String nombre;
  final String tipoMascota;
  final double peso;
  final bool aptoDepto;
  final bool aptoPerros;
  final String sexo;
  final bool vacunado;
  String estado;
  final String imagenUrl; // Campo para la URL de la imagen

  Mascota({
    required this.id,
    required this.nombre,
    required this.tipoMascota,
    required this.peso,
    required this.aptoDepto,
    required this.aptoPerros,
    required this.sexo,
    required this.vacunado,
    required this.estado,
    required this.imagenUrl,
  });
}

class ListaMascotasPage extends StatefulWidget {
  const ListaMascotasPage({super.key});

  static const String route = '/lista_mascotas';

  @override
  ListaMascotasPageState createState() => ListaMascotasPageState();
}

class ListaMascotasPageState extends State<ListaMascotasPage> {
  List<Mascota> mascotas = [
    Mascota(
      id: 1,
      nombre: 'Max',
      tipoMascota: 'Perro',
      peso: 15.5,
      aptoDepto: true,
      aptoPerros: true,
      sexo: 'Macho',
      vacunado: true,
      estado: 'Disponible',
      imagenUrl: 'https://via.placeholder.com/150', // Imagen de ejemplo
    ),
    Mascota(
      id: 2,
      nombre: 'Luna',
      tipoMascota: 'Gato',
      peso: 4.3,
      aptoDepto: true,
      aptoPerros: false,
      sexo: 'Hembra',
      vacunado: true,
      estado: 'Adoptado',
      imagenUrl: 'https://via.placeholder.com/150', // Imagen de ejemplo
    ),
    Mascota(
      id: 3,
      nombre: 'Rocky',
      tipoMascota: 'Perro',
      peso: 20.1,
      aptoDepto: false,
      aptoPerros: true,
      sexo: 'Macho',
      vacunado: false,
      estado: 'En tratamiento',
      imagenUrl: 'https://via.placeholder.com/150', // Imagen de ejemplo
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Gestión de Mascotas'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Listado de Mascotas',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: mascotas.length,
                itemBuilder: (context, index) {
                  Mascota mascota = mascotas[index];
                  return Card(
                    elevation: 3.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            mascota.imagenUrl), // Imagen de la mascota
                      ),
                      title: Text(mascota.nombre),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tipo: ${mascota.tipoMascota}'),
                          Text('Peso: ${mascota.peso.toStringAsFixed(1)} kg'),
                          Text('Sexo: ${mascota.sexo}'),
                          Text('Estado: ${mascota.estado}'),
                          Text(
                            'Vacunado: ${mascota.vacunado ? 'Sí' : 'No'}',
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Navegar a la pantalla de edición de mascota
                              _editarMascota(mascota);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Confirmación y acción de eliminar mascota
                              _confirmarEliminarMascota(context, mascota);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navegar a la pantalla de agregar nueva mascota
          _agregarMascota();
        },
        label: const Text('Agregar Mascota'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _confirmarEliminarMascota(BuildContext context, Mascota mascota) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
              '¿Estás seguro de que deseas eliminar a la mascota "${mascota.nombre}"?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:
                  const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  mascotas.remove(mascota);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _agregarMascota() {
    // Lógica para agregar una nueva mascota
    // setState(() {
    //   mascotas.add(Mascota(
    //     id: mascotas.length + 1,
    //     nombre: 'Nueva Mascota',
    //     tipoMascota: 'Gato',
    //     peso: 3.5,
    //     aptoDepto: true,
    //     aptoPerros: true,
    //     sexo: 'Hembra',
    //     vacunado: false,
    //     estado: 'Disponible',
    //     imagenUrl: 'https://via.placeholder.com/150', // Imagen de ejemplo
    //   ));
    // });
    context.push(AltaMascotaPage.route);
  }

  void _editarMascota(Mascota mascota) {
    // Lógica para editar una mascota
    // Para este ejemplo, solo vamos a modificar el estado
    setState(() {
      mascota.estado = 'Adoptado';
    });
  }
}
