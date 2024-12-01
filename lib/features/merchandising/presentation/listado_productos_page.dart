import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/checkout_carrito_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/descripcion_producto_page.dart';
import 'package:hogar_petfecto/features/merchandising/providers/carrito_state_notifier.dart';
import 'package:hogar_petfecto/features/merchandising/providers/lista_merchandising_cliente_use_case.dart';

class ListadoProductosPage extends ConsumerStatefulWidget {
  const ListadoProductosPage({super.key});
  static const String route = '/listado_productos';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListadoProductosPageState();
}

class _ListadoProductosPageState extends ConsumerState<ListadoProductosPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(carritoProvider.notifier).vaciarCarrito();
    });
  }

  void _filterProducts(String query) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final listaMerchandisingClienteAsyncValue =
        ref.watch(listaMerchandisingClienteUseCaseProvider);
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              // Aquí se manejará la lógica para agregar al carrito
              context.push(CheckoutCarritoPage.route, extra: {
                'cartItems': [],
              });
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Ir al carrito'),
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('Tienda'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Buscar productos...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterProducts,
            ),
          ),
        ),
      ),
      body: listaMerchandisingClienteAsyncValue.when(
        data: (listaMerchandisingClienteAsyncValue) {
          return ListView.builder(
            itemCount: listaMerchandisingClienteAsyncValue.productos?.length,
            itemBuilder: (context, index) {
              final product =
                  listaMerchandisingClienteAsyncValue.productos?[index];
              final imageBytes = listaMerchandisingClienteAsyncValue
                          .productos?[index].imagen !=
                      null
                  ? base64Decode(listaMerchandisingClienteAsyncValue
                      .productos![index].imagen!)
                  : null;
              return ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      imageBytes != null ? MemoryImage(imageBytes) : null,
                  child: imageBytes == null
                      ? const Icon(Icons.card_giftcard_sharp, size: 30)
                      : null,
                ),
                title: Text(product?.titulo ?? ''),
                subtitle: Text(product?.categoria?.nombre ?? ''),
                trailing: Text('\$${product?.precio}'),
                onTap: () {
                  context.push(
                    DescripcionProductoPage.route,
                    extra: product,
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error al cargar lista de productos: $error'),
        ),
      ),
    );
  }
}
