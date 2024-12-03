import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/features/merchandising/models/lista_productos_response_model.dart';

class CarritoItem {
  final Productos producto;
  final int cantidad;

  CarritoItem({required this.producto, required this.cantidad});

  CarritoItem copyWith({int? cantidad}) {
    return CarritoItem(
      producto: producto,
      cantidad: cantidad ?? this.cantidad,
    );
  }
}

class CarritoStateNotifier extends StateNotifier<List<CarritoItem>> {
  CarritoStateNotifier() : super([]);

  bool agregarProducto(Productos producto, int cantidad) {
    final index = state.indexWhere((item) => item.producto.id == producto.id);
    if (index != -1) {
      // Si el producto ya existe, verifica el stock
      final item = state[index];
      if (item.cantidad + cantidad > producto.stock!) {
        return false; // No se puede agregar más del stock disponible
      }

      // Incrementa la cantidad si no excede el stock
      final updatedItem = item.copyWith(cantidad: item.cantidad + cantidad);
      final updatedState = List<CarritoItem>.from(state);
      updatedState[index] = updatedItem;
      state = updatedState;
      return true;
    } else {
      // Si no existe, valida el stock antes de agregar
      if (cantidad > producto.stock!) {
        return false; // No se puede agregar más del stock disponible
      }
      state = [...state, CarritoItem(producto: producto, cantidad: cantidad)];
      return true;
    }
  }

  void actualizarCantidad(Productos producto, int nuevaCantidad) {
    final index = state.indexWhere((item) => item.producto.id == producto.id);
    if (index != -1) {
      // Verifica el stock antes de actualizar
      if (nuevaCantidad > producto.stock!) {
        return; // No se permite actualizar si supera el stock
      }

      final updatedItem = state[index].copyWith(cantidad: nuevaCantidad);
      final updatedState = List<CarritoItem>.from(state);
      updatedState[index] = updatedItem;
      state = updatedState;
    }
  }

  void eliminarProducto(Productos producto) {
    state = state.where((item) => item.producto.id != producto.id).toList();
  }

  void reducirCantidad(Productos producto) {
    final index = state.indexWhere((item) => item.producto.id == producto.id);
    if (index != -1) {
      final item = state[index];
      if (item.cantidad > 1) {
        final updatedItem = item.copyWith(cantidad: item.cantidad - 1);
        final updatedState = List<CarritoItem>.from(state);
        updatedState[index] = updatedItem;
        state = updatedState;
      } else {
        eliminarProducto(producto);
      }
    }
  }

  void vaciarCarrito() {
    state = [];
  }

  List<Map<String, dynamic>> obtenerPedidosPorProtectoraUI() {
    final pedidosAgrupados = <int, List<CarritoItem>>{};

    for (var item in state) {
      final protectoraId = item.producto.protectoraId!;
      pedidosAgrupados.putIfAbsent(protectoraId, () => []);
      pedidosAgrupados[protectoraId]!.add(item);
    }

    return pedidosAgrupados.entries.map((entry) {
      return {
        "protectoraId": entry.key,
        "nombreProtectora": entry.value.first.producto.nombreProtectora ??
            'Nombre no disponible',
        "productos": entry.value, // Keep as CarritoItem for UI
      };
    }).toList();
  }

  List<Map<String, dynamic>> obtenerFormatoParaRequest() {
    final pedidosAgrupados = <int, List<Map<String, int?>>>{};

    for (var item in state) {
      final protectoraId = item.producto.protectoraId!;
      pedidosAgrupados.putIfAbsent(protectoraId, () => []);
      pedidosAgrupados[protectoraId]!.add({
        "id": item.producto.id,
        "cantidad": item.cantidad,
      });
    }

    return pedidosAgrupados.entries.map((entry) {
      return {
        "protectoraId": entry.key,
        "productos": entry.value, // Serialized for request
      };
    }).toList();
  }

  double calcularPrecioTotal() {
    return state.fold(
      0.0,
      (total, item) => total + (item.producto.precio ?? 0.0) * item.cantidad,
    );
  }
}

final carritoProvider =
    StateNotifierProvider<CarritoStateNotifier, List<CarritoItem>>(
  (ref) => CarritoStateNotifier(),
);
