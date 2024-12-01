import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/features/merchandising/models/lista_productos_response_model.dart';
import 'package:hogar_petfecto/features/merchandising/providers/carrito_state_notifier.dart';

class DescripcionProductoPage extends ConsumerStatefulWidget {
  const DescripcionProductoPage({super.key, required this.product});
  final Productos product;
  static const String route = '/descripcion_producto';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DescripcionProductoPageState();
}

class _DescripcionProductoPageState
    extends ConsumerState<DescripcionProductoPage> {
  @override
  Widget build(BuildContext context) {
    final imageBytes = widget.product.imagen != null
        ? base64Decode(widget.product.imagen!)
        : null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Center(
              child: Image.memory(
                imageBytes!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16.0),

            // Nombre del producto
            Text(
              widget.product.titulo ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),

            // Precio del producto
            Text(
              '\$${widget.product.precio}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16.0),

            // Descripción del producto
            Text(
              widget.product.descripcion ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24.0),

            // Botón de agregar al carrito
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ref
                      .read(carritoProvider.notifier)
                      .agregarProducto(widget.product);
                  context.pop();

                  // Aquí se manejará la lógica para agregar al carrito
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('${widget.product.titulo} agregado al carrito'),
                    ),
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
