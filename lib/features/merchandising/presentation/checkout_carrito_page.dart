import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/features/merchandising/models/lista_productos_response_model.dart';
import 'package:hogar_petfecto/features/merchandising/providers/carrito_state_notifier.dart';
import 'package:hogar_petfecto/features/merchandising/providers/crear_pedido_use_case.dart';

class CheckoutCarritoPage extends ConsumerStatefulWidget {
  static const String route = '/checkout_carrito';

  const CheckoutCarritoPage({super.key});

  @override
  ConsumerState<CheckoutCarritoPage> createState() =>
      _CheckoutCarritoPageState();
}

class _CheckoutCarritoPageState extends ConsumerState<CheckoutCarritoPage> {
  final Map<int, bool> _selectedProtectoras = {};

  @override
  Widget build(BuildContext context) {
    final carritoNotifier = ref.read(carritoProvider.notifier);
    final pedidosPorProtectora =
        carritoNotifier.obtenerPedidosPorProtectora(); // Agrupa los pedidos
    final totalPrice = carritoNotifier.calcularPrecioTotal();

    // Inicializa el estado de selección si es la primera vez
    pedidosPorProtectora.forEach((pedido) {
      _selectedProtectoras.putIfAbsent(pedido['protectoraId'], () => true);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: pedidosPorProtectora.length,
                itemBuilder: (context, index) {
                  final pedido = pedidosPorProtectora[index];
                  final protectoraId = pedido['protectoraId'];
                  final nombreProtectora = pedido['nombreProtectora'];
                  final productos = pedido['productos'] as List<Productos>;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _selectedProtectoras[protectoraId],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedProtectoras[protectoraId] =
                                            value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Protectora: $nombreProtectora',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${productos.length} Productos',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: productos.length,
                            itemBuilder: (context, prodIndex) {
                              final producto = productos[prodIndex];
                              final imageBytes = producto.imagen != null
                                  ? base64Decode(producto.imagen!)
                                  : null;
                              return ListTile(
                                leading: imageBytes != null
                                    ? Image.memory(
                                        imageBytes,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.image_not_supported,
                                        size: 50),
                                title: Text(producto.titulo ?? 'Producto'),
                                subtitle: Text('\$${producto.precio ?? 0.0}'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Filtrar los pedidos seleccionados
                      final pedidosSeleccionados = pedidosPorProtectora
                          .where((pedido) =>
                              _selectedProtectoras[pedido['protectoraId']] ==
                              true)
                          .toList();

                      if (pedidosSeleccionados.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Selecciona al menos un pedido para continuar'),
                          ),
                        );
                        return;
                      }

                      // Construir el cuerpo consolidado para la solicitud
                      final body = {
                        "pedidos": pedidosSeleccionados.map((pedido) {
                          return {
                            "protectoraId": pedido["protectoraId"],
                            "productos":
                                (pedido["productos"] as List<Productos>)
                                    .map((producto) => {"id": producto.id})
                                    .toList(),
                          };
                        }).toList(),
                      };

                      try {
                        // Hacer una única llamada al backend con toda la lista de pedidos
                        await ref.read(crearPedidoUseCaseProvider(body).future);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Pedidos seleccionados creados exitosamente')),
                        );

                        carritoNotifier.vaciarCarrito();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al crear pedidos: $e')),
                        );
                      }
                    },
                    child: const Text('Proceder con los Pedidos'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
