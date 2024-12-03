import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/merchandising/models/ventas_response_model.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/oc_pdf_page.dart';
import 'package:hogar_petfecto/features/merchandising/providers/orden_compra_use_case.dart';
import 'package:hogar_petfecto/features/merchandising/providers/venta_use_case.dart';
import 'package:path_provider/path_provider.dart';

class HistorialVentasPage extends ConsumerStatefulWidget {
  const HistorialVentasPage({super.key});
  static const String route = '/historial-ventas';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HistoriaVentalsPageState();
}

class _HistoriaVentalsPageState extends ConsumerState<HistorialVentasPage> {
  @override
  Widget build(BuildContext context) {
    final listaVentasAsyncValue = ref.watch(listaVentasUseCaseProvider);
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Historial de Ventas',
        goBack: () {
          GoRouter.of(context).pop();
        },
      ),
      body: listaVentasAsyncValue.when(
        data: (listaVentasAsyncValue) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: listaVentasAsyncValue.pedidos?.length,
              itemBuilder: (context, index) {
                return buildVentaCard(listaVentasAsyncValue.pedidos![index]);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error al cargar lista de mascotas: $error'),
        ),
      ),
    );
  }

  // Tarjeta para mostrar cada venta
  Widget buildVentaCard(Pedidos pedido) {
    var fecha = pedido.fecha;
    var producto = '';
    var cantidad = 0;
    for (var item in pedido.lineaPedido!) {
      producto = '$producto, ${item.producto!.titulo!}';
      cantidad = cantidad + item.cantidad!;
    }

    var precio = pedido.monto;
    var comprador = pedido.cliente!.cuil;

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          '${producto.substring(2)}',
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: $fecha'),
            Text('Items vendidos: $cantidad'),
            Text('Id de pago: ${pedido.idPago}'),
            Text('Total: \$${(precio)}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            verDetallesVenta(pedido);
          },
        ),
      ),
    );
  }

  // Acción para ver detalles de la venta
  void verDetallesVenta(Pedidos pedido) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Detalles de la Venta',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Productos:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 8),
              for (var linea in pedido.lineaPedido!)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${linea.producto?.titulo ?? 'Sin título'}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        '\$${linea.producto?.precio?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'x${linea.cantidad}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      '+ 15%',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${(pedido.lineaPedido!.fold<double>(
                          0,
                          (sum, linea) =>
                              sum +
                              (linea.producto?.precio ?? 0) * linea.cantidad!,
                        ) * 1.15).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                // Leer el archivo PDF usando el provider
                final filedoc = await ref
                    .read(ordenCompraUseCaseProvider(pedido.id!).future);

                if (filedoc != null) {
                  await guardarPdfDesdeBase64(
                          filedoc.file!, "reporteOrdenCompra.pdf")
                      .then((path) {
                    context.push(
                      OcPdfPage.route,
                      extra: path,
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('No se pudo cargar el archivo PDF')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Error al obtener el archivo PDF: $e')),
                );
              }
            },
            child: const Text('Ver PDF'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cerrar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> guardarPdfDesdeBase64(
      String base64Str, String nombreArchivo) async {
    final bytes = base64Decode(base64Str);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$nombreArchivo');

    await file.writeAsBytes(bytes);
    return file.path;
  }
}
