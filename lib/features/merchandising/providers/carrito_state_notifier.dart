import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/features/merchandising/models/lista_productos_response_model.dart';

class CarritoStateNotifier extends StateNotifier<List<Productos>> {
  CarritoStateNotifier() : super([]);

  // Agregar producto al carrito
  void agregarProducto(Productos producto) {
    state = [...state, producto];
  }

  // Eliminar producto del carrito
  void eliminarProducto(Productos producto) {
    state = state.where((item) => item.id != producto.id).toList();
  }

  // Vaciar carrito
  void vaciarCarrito() {
    state = [];
  }

  // Obtener lista de pedidos agrupados por protectora
  List<Map<String, dynamic>> obtenerPedidosPorProtectora() {
  // Agrupar productos por ProtectoraId
  final pedidosAgrupados = <int, List<Productos>>{};

  for (var producto in state) {
    final protectoraId = producto.protectoraId!;
    pedidosAgrupados.putIfAbsent(protectoraId, () => []);
    pedidosAgrupados[protectoraId]!.add(producto); // Agregar el objeto completo
  }

  // Convertir a lista de pedidos
  final pedidos = pedidosAgrupados.entries.map((entry) {
    final protectoraId = entry.key;
    final productos = entry.value;

    // Asumimos que todos los productos de una protectora tienen el mismo nombreProtectora
    final nombreProtectora = productos.first.nombreProtectora ?? 'Nombre no disponible';

    return {
      "protectoraId": protectoraId,
      "nombreProtectora": nombreProtectora,
      "productos": productos, // Lista completa de objetos Productos
    };
  }).toList();

  return pedidos;
}


  // Calcular el precio total
  double calcularPrecioTotal() {
    return state.fold(
        0.0, (total, producto) => total + (producto.precio ?? 0.0));
  }
}

final carritoProvider = StateNotifierProvider<CarritoStateNotifier, List<Productos>>(
  (ref) => CarritoStateNotifier(),
);

