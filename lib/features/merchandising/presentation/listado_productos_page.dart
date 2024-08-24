import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/descripcion_producto_page.dart';

class ListadoProductos extends StatefulWidget {
  const ListadoProductos({super.key});
  static const String route = '/listado_productos';

  @override
  _ListadoProductosState createState() => _ListadoProductosState();
}

class _ListadoProductosState extends State<ListadoProductos> {
  // Controlador de la barra de búsqueda
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  final List<Product> _products = [
    Product(
      name: 'Producto 1',
      description: 'Descripción del producto 1',
      price: 100.0,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      name: 'Producto 2',
      description: 'Descripción del producto 2',
      price: 200.0,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      name: 'Producto 3',
      description: 'Descripción del producto 3',
      price: 300.0,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    // Agrega más productos aquí
  ];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _products;
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tienda'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Buscar productos...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterProducts,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          return ListTile(
            leading: Image.network(
              product.imageUrl,
              width: 50,
              height: 75,
              fit: BoxFit.cover,
            ),
            title: Text(product.name),
            subtitle: Text(product.description),
            trailing: Text('\$${product.price.toStringAsFixed(2)}'),
            onTap: () {
              // Aquí puedes manejar la lógica para agregar al carrito o comprar
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text('${product.name} agregado al carrito'),
              //   ),
              // );
              context.push(
                DescripcionProductoPage.route,
                extra: product,
              );
            },
          );
        },
      ),
    );
  }
}

class Product {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}
