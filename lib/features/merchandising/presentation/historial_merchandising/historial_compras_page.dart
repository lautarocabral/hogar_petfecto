import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';

class HistorialComprasPage extends StatefulWidget {
  const HistorialComprasPage({super.key});

  static const String route = '/historial-compras';

  @override
  _HistorialComprasPageState createState() => _HistorialComprasPageState();
}

class _HistorialComprasPageState extends State<HistorialComprasPage> {
  // Simulación de compras realizadas
  final List<Map<String, dynamic>> historialCompras = [
    {
      'fecha': '01/10/2024',
      'producto': 'Cama para perros',
      'cantidad': 1,
      'precio': 30.00,
    },
    {
      'fecha': '20/09/2024',
      'producto': 'Collar para gatos',
      'cantidad': 2,
      'precio': 10.50,
    },
    {
      'fecha': '05/09/2024',
      'producto': 'Comida para perros',
      'cantidad': 3,
      'precio': 15.00,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Historial de Compras',
        goBack: () {
          GoRouter.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: historialCompras.length,
          itemBuilder: (context, index) {
            return buildCompraCard(index);
          },
        ),
      ),
    );
  }

  // Tarjeta para mostrar cada compra
  Widget buildCompraCard(int index) {
    var fecha = historialCompras[index]['fecha'];
    var producto = historialCompras[index]['producto'];
    var cantidad = historialCompras[index]['cantidad'];
    var precio = historialCompras[index]['precio'];

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          'Producto: $producto',
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: $fecha'),
            Text('Cantidad: $cantidad'),
            Text('Precio: \$${precio.toStringAsFixed(2)}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            verDetallesCompra(index);
          },
        ),
      ),
    );
  }

  // Acción para ver detalles de la compra
  void verDetallesCompra(int index) {
    var compra = historialCompras[index];
    // Aquí puedes navegar a una página de detalles o mostrar más información
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalles de la Compra'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Producto: ${compra['producto']}'),
            Text('Cantidad: ${compra['cantidad']}'),
            Text('Precio: \$${compra['precio'].toStringAsFixed(2)}'),
            Text('Fecha: ${compra['fecha']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
