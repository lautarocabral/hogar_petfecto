import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/confirmacion_contrato_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/descripcion_mascota_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/listado_mascotas_page.dart';
import 'package:hogar_petfecto/features/common/presentation/custom_error_page.dart';
import 'package:hogar_petfecto/features/common/presentation/custom_success_page.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/checkout_carrito_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/descripcion_producto_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/listado_productos_page.dart';
import 'package:hogar_petfecto/features/publicacion/presentation/carga_mascota.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/login_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_veterinaria_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/subscription_page.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/veterinaria_descripcion_page.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/veterinaria_map_page.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    // initialLocation: lastVisitedRoute ??
    //     HomePage
    //         .route, // Restaurar la última ruta o usar una ruta predeterminada
    routes: [
      // Seguridad
      GoRoute(
        path: LoginPage.route,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: SignUpScreen.route,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: SignUpVeterinariaPage.route,
        builder: (context, state) => const SignUpVeterinariaPage(),
      ),
      GoRoute(
        path: SubscriptionPage.route,
        builder: (context, state) => const SubscriptionPage(),
      ),
      GoRoute(
        path: HomePage.route,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: ListadoMascotasPage.route,
        builder: (context, state) => const ListadoMascotasPage(),
      ),
      GoRoute(
        path: DescripcionMascotaPage.route,
        builder: (context, state) => const DescripcionMascotaPage(),
      ),
      GoRoute(
        path: ConfirmacionContratoPage.route,
        builder: (context, state) => const ConfirmacionContratoPage(),
      ),
      //Generic
      GoRoute(
        path: CustomSuccessPage.route,
        builder: (context, state) {
          final message =
              state.uri.queryParameters['message'] ?? 'Operación exitosa';
          final onAccept = state.extra as VoidCallback?;
          return CustomSuccessPage(
            message: message,
            onAccept: onAccept ?? () => context.go(HomePage.route),
          );
        },
      ),
      GoRoute(
        path: CustomErrorPage.route,
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>?;

          final errorMessage = extraData?['errorMessage'] ?? 'Hubo un error';
          final onRetry = state.extra as VoidCallback?;
          return CustomErrorPage(
            errorMessage: errorMessage,
            onRetry: onRetry ?? () => context.go(HomePage.route),
          );
        },
      ),
      // Publicacion
      GoRoute(
        path: CargaMascota.route,
        builder: (context, state) => const CargaMascota(),
      ),
      // Merchandising
      GoRoute(
        path: ListadoProductos.route,
        builder: (context, state) => const ListadoProductos(),
      ),
      GoRoute(
        path: DescripcionProductoPage.route,
        builder: (context, state) {
          final product = state.extra as Product;
          return DescripcionProductoPage(product: product);
        },
      ),
      GoRoute(
        path: CheckoutCarritoPage.route,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          final items = args!['cartItems'] as List<dynamic>;
          final totalPrice = items.fold(0.0, (sum, item) => sum + item.price);
          return CheckoutCarritoPage(
            cartItems: List<Product>.from(items),
            totalPrice: totalPrice,
          );
        },
      ),
      // Veterinarias
      GoRoute(
        path: VeterinariaMapPage.route,
        builder: (context, state) => const VeterinariaMapPage(),
      ),
      GoRoute(
        path: VeterinariaDescripcionPage.route,
        builder: (context, state) {
          // Cast seguro de state.extra a Map<String, String>
          final extraData = state.extra as Map<String, String>?;

          final veterinariaNombre = extraData?['nombre'] ?? 'Sin nombre';
          final veterinariaDescripcion =
              extraData?['descripcion'] ?? 'Sin descripción';

          return VeterinariaDescripcionPage(
            veterinariaNombre: veterinariaNombre,
            veterinariaDescripcion: veterinariaDescripcion,
          );
        },
      ),
    ],
  );
}
