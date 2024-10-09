import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';

class HistorialVentasPage extends StatefulWidget {
  const HistorialVentasPage({super.key});

  static const String route = '/historial-ventas';

  @override
  _HistorialVentasPageState createState() => _HistorialVentasPageState();
}

class _HistorialVentasPageState extends State<HistorialVentasPage> {
  // Simulación de ventas realizadas
  final List<Map<String, dynamic>> historialVentas = [
    {
      'fecha': '10/10/2024',
      'producto': 'Juguete para perros',
      'cantidad': 5,
      'precio': 50.00,
      'comprador': 'Carlos Pérez'
    },
    {
      'fecha': '25/09/2024',
      'producto': 'Arena para gatos',
      'cantidad': 10,
      'precio': 20.00,
      'comprador': 'Ana López'
    },
    {
      'fecha': '15/09/2024',
      'producto': 'Rascador para gatos',
      'cantidad': 3,
      'precio': 45.00,
      'comprador': 'Pedro Gómez'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Historial de Ventas',
        goBack: () {
          GoRouter.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: historialVentas.length,
          itemBuilder: (context, index) {
            return buildVentaCard(index);
          },
        ),
      ),
    );
  }

  // Tarjeta para mostrar cada venta
  Widget buildVentaCard(int index) {
    var fecha = historialVentas[index]['fecha'];
    var producto = historialVentas[index]['producto'];
    var cantidad = historialVentas[index]['cantidad'];
    var precio = historialVentas[index]['precio'];
    var comprador = historialVentas[index]['comprador'];

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
            Text('Cantidad vendida: $cantidad'),
            Text('Comprador: $comprador'),
            Text('Total: \$${(precio * cantidad).toStringAsFixed(2)}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            verDetallesVenta(index);
          },
        ),
      ),
    );
  }

  // Acción para ver detalles de la venta
  void verDetallesVenta(int index) {
    var venta = historialVentas[index];
    // Aquí puedes navegar a una página de detalles o mostrar más información
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalles de la Venta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Producto: ${venta['producto']}'),
            Text('Cantidad: ${venta['cantidad']}'),
            Text('Total: \$${(venta['precio'] * venta['cantidad']).toStringAsFixed(2)}'),
            Text('Fecha: ${venta['fecha']}'),
            Text('Comprador: ${venta['comprador']}'),
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
