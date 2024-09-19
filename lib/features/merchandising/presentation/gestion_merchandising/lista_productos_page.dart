import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/routes/app_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/gestion_merchandising/alta_producto_page.dart';

class Producto {
  final int id;
  final String descripcion;
  int stock;
  final double precio;
  final String categoria;

  Producto({
    required this.id,
    required this.descripcion,
    required this.stock,
    required this.precio,
    required this.categoria,
  });
}

class ListaProductosPage extends StatefulWidget {
  const ListaProductosPage({super.key});

  static const String route = '/lista_productos';

  @override
  _ListaProductosPageState createState() => _ListaProductosPageState();
}

class _ListaProductosPageState extends State<ListaProductosPage> {
  List<Producto> productos = [
    Producto(
        id: 1,
        descripcion: "Producto 1",
        stock: 10,
        precio: 99.99,
        categoria: "Categoría 1"),
    Producto(
        id: 2,
        descripcion: "Producto 2",
        stock: 20,
        precio: 199.99,
        categoria: "Categoría 2"),
    Producto(
        id: 3,
        descripcion: "Producto 3",
        stock: 15,
        precio: 299.99,
        categoria: "Categoría 3"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Gestión de Merchandising'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Listado de Productos',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  Producto producto = productos[index];
                  return Card(
                    elevation: 3.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(producto.id.toString()),
                      ),
                      title: Text(producto.descripcion),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Stock: ${producto.stock}'),
                          Text(
                              'Precio: \$${producto.precio.toStringAsFixed(2)}'),
                          Text('Categoría: ${producto.categoria}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Navegar a la pantalla de edición de producto
                              _editarProducto(producto);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Confirmación y acción de eliminar producto
                              _confirmarEliminarProducto(context, producto);
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
          // Navegar a la pantalla de agregar nuevo producto
          _agregarProducto();
        },
        label: const Text('Agregar Producto'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _confirmarEliminarProducto(BuildContext context, Producto producto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
              '¿Estás seguro de que deseas eliminar el producto "${producto.descripcion}"?'),
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
                  productos.remove(producto);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _agregarProducto() {
    // Lógica para agregar un nuevo producto
    // Navegar a una pantalla de formulario o agregar directamente
    // setState(() {
    //   productos.add(Producto(
    //     id: productos.length + 1,
    //     descripcion: "Nuevo Producto",
    //     stock: 0,
    //     precio: 0.0,
    //     categoria: "Nueva Categoría",
    //   ));
    // });
    context.push(AltaProductoPage.route);
  }

  void _editarProducto(Producto producto) {
    // Lógica para editar un producto
    // Navegar a una pantalla de edición con los datos del producto
    // Para este ejemplo, solo vamos a actualizar el stock
    setState(() {
      producto.stock += 5;
    });
  }
}
