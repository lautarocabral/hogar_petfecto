import 'package:flutter/material.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/listado_productos_page.dart';

class DescripcionProductoPage extends StatelessWidget {
  final Product product;

  const DescripcionProductoPage({super.key, required this.product});

  static const String route = '/descripcion_producto';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Center(
              child: Image.network(
                product.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),

            // Nombre del producto
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),

            // Precio del producto
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16.0),

            // Descripción del producto
            Text(
              product.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24.0),

            // Botón de agregar al carrito
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Aquí se manejará la lógica para agregar al carrito
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('${product.name} agregado al carrito')),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Agregar al Carrito'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
