import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/merchandising/models/lista_productos_response_model.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/gestion_merchandising/alta_producto_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/gestion_merchandising/editar_producto_page.dart';
import 'package:hogar_petfecto/features/merchandising/providers/editar_merchandising_use_case.dart';
import 'package:hogar_petfecto/features/merchandising/providers/eliminar_merchandising_use_case.dart';
import 'package:hogar_petfecto/features/merchandising/providers/lista_merchandising_use_case.dart';

class ListaProductosPage extends ConsumerStatefulWidget {
  const ListaProductosPage({super.key});
  static const String route = '/lista_productos';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListaProductosPageState();
}

class _ListaProductosPageState extends ConsumerState<ListaProductosPage> {
  void _confirmarEliminarProducto(BuildContext context, Productos producto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
              '¿Estás seguro de que deseas eliminar el producto ${producto.descripcion}?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:
                  const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await _eliminarProducto(producto.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _eliminarProducto(id) async {
    await ref.read(eliminarMerchandisingUseCaseProvider(id).future);
    ref.invalidate(listaMerchandisingUseCaseProvider);
  }

  void _agregarProducto() {
    context.push(AltaProductoPage.route);
  }

  void _editarProducto(Productos producto) {
    context.push(
      EditarProductoPage.route,
      extra: producto,
    );
  }

  @override
  Widget build(BuildContext context) {
    final listaMerchandisingAsyncValue =
        ref.watch(listaMerchandisingUseCaseProvider);

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Gestión de Merchandising'),
      body: listaMerchandisingAsyncValue.when(
        data: (listaMerchandisingAsyncValue) {
          {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Listado de Productos',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          listaMerchandisingAsyncValue.productos?.length ?? 1,
                      itemBuilder: (context, index) {
                        final imageBytes = listaMerchandisingAsyncValue
                                    .productos?[index].imagen !=
                                null
                            ? base64Decode(listaMerchandisingAsyncValue
                                .productos![index].imagen!)
                            : null;
                        return Card(
                          elevation: 3.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: imageBytes != null
                                  ? MemoryImage(imageBytes)
                                  : null,
                              child: imageBytes == null
                                  ? const Icon(Icons.card_giftcard_sharp,
                                      size: 30)
                                  : null,
                            ),
                            title: Text(listaMerchandisingAsyncValue
                                    .productos?[index].descripcion ??
                                ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Stock: ${listaMerchandisingAsyncValue.productos?[index].stock} '),
                                Text(
                                    'Precio: \$ ${listaMerchandisingAsyncValue.productos?[index].precio} '),
                                Text(
                                    'Categoría: ${listaMerchandisingAsyncValue.productos?[index].categoria?.nombre ?? '!!!!!!!!!'}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    // Navegar a la pantalla de edición de producto
                                    _editarProducto(listaMerchandisingAsyncValue
                                        .productos![index]);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    // Confirmación y acción de eliminar producto
                                    _confirmarEliminarProducto(
                                        context,
                                        listaMerchandisingAsyncValue
                                            .productos![index]);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            );
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error al cargar lista de mascotas: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navegar a la pantalla de agregar nuevo producto
          _agregarProducto();
        },
        label: const Text('Agregar Producto'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
