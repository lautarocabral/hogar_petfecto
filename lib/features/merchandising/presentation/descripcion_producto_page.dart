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
  int _cantidad = 1;

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
            Center(
              child: Image.memory(
                imageBytes!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.product.titulo ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              '\$${widget.product.precio}',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.product.descripcion ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24.0),

            // Selector de cantidad
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_cantidad > 1) _cantidad--;
                    });
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  '$_cantidad',
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  onPressed: () {
                    if (_cantidad < widget.product.stock!) {
                      setState(() {
                        _cantidad++;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'No puedes agregar más de ${widget.product.stock} unidades'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  final agregado = ref
                      .read(carritoProvider.notifier)
                      .agregarProducto(widget.product, _cantidad);

                  if (agregado) {
                    // Producto agregado exitosamente
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${widget.product.titulo} (x$_cantidad) agregado al carrito'),
                      ),
                    );
                    context.pop();
                  } else {
                    // Producto ya está en el carrito
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${widget.product.titulo} ya está en el carrito'),
                      ),
                    );
                  }
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
