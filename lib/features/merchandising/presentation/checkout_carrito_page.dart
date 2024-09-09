import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_button_widget.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/listado_productos_page.dart';

class CheckoutCarritoPage extends StatelessWidget {
  final List<Product> cartItems; // Lista de productos en el carrito
  final double totalPrice; // Precio total del carrito

  const CheckoutCarritoPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  static const String route = '/checkout_carrito';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Checkout'),
      body: Padding(
        padding: const EdgeInsets.all(Margins.largeMargin),
        child: Column(
          children: [
            // Título
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Revisar pedido',
                  style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Gap(20),
            // Lista de productos en el carrito
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartItems[index];
                  return ListTile(
                    leading: Image.network(
                      product.imageUrl,
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Lógica para eliminar el producto del carrito
                      },
                    ),
                  );
                },
              ),
            ),
            const Gap(20),
            // Total a pagar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(20),
            // Botón para proceder al pago
            CustomButton(
              text: 'Pagar',
              onPressed: () {
                // Lógica para proceder con el pago
              },
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
