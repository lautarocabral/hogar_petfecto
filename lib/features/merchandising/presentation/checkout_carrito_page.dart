import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/features/common/presentation/custom_success_page.dart';
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

    // Data for UI
    final pedidosPorProtectora =
        carritoNotifier.obtenerPedidosPorProtectoraUI();

    // Data for request
    final formatoParaRequest = carritoNotifier.obtenerFormatoParaRequest();

    final totalPrice = carritoNotifier.calcularPrecioTotal();

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
                  final productos = pedido['productos'] as List<CarritoItem>;

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
                              final item = productos[prodIndex];
                              final imageBytes = item.producto.imagen != null
                                  ? base64Decode(item.producto.imagen!)
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
                                title: Text(item.producto.titulo ?? 'Producto'),
                                subtitle: Text(
                                    'Cantidad: ${item.cantidad} - \$${(item.producto.precio ?? 0.0) * item.cantidad}'),
                                trailing: SizedBox(
                                  width:
                                      120, // Define un ancho máximo para los botones
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove,
                                            color: Colors.red),
                                        onPressed: () {
                                          if (item.cantidad > 1) {
                                            // Disminuir la cantidad del producto
                                            ref
                                                .read(carritoProvider.notifier)
                                                .actualizarCantidad(
                                                    item.producto,
                                                    item.cantidad - 1);
                                            setState(() {});
                                          } else {
                                            // Eliminar producto si la cantidad es 1
                                            ref
                                                .read(carritoProvider.notifier)
                                                .eliminarProducto(
                                                    item.producto);
                                            setState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    '${item.producto.titulo} eliminado del carrito'),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      Text(
                                        '${item.cantidad}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add,
                                            color: Colors.green),
                                        onPressed: () {
                                          if (item.cantidad <
                                              item.producto.stock!) {
                                            // Aumentar la cantidad del producto, respetando el stock
                                            ref
                                                .read(carritoProvider.notifier)
                                                .actualizarCantidad(
                                                    item.producto,
                                                    item.cantidad + 1);
                                            setState(() {});
                                          } else {
                                            // Mostrar mensaje si se excede el stock
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'No puedes agregar más de ${item.producto.stock} unidades de ${item.producto.titulo}'),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
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
                  '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${'${totalPrice.toStringAsFixed(2)} + 15%'}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${(double.parse(totalPrice.toStringAsFixed(2)) * 1.15).toStringAsFixed(2)}',
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
                      final pedidosSeleccionados = formatoParaRequest
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

                      final body = {"pedidos": pedidosSeleccionados};

                      try {
                        await ref.read(crearPedidoUseCaseProvider(body).future);

                        context.go(
                          '${CustomSuccessPage.route}?message=¡Compra exitosa!\n\nLa protectora te contactará\npara poder recibir tu compra',
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

class ProductoResponse {
  int? id;
  String? cantidad;

  ProductoResponse({this.id, this.cantidad});

  ProductoResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cantidad = json['cantidad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cantidad'] = cantidad;
    return data;
  }
}
