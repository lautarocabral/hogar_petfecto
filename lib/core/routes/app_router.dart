import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/confirmacion_contrato_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/descripcion_mascota_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/listado_mascotas_page.dart';
import 'package:hogar_petfecto/features/common/presentation/custom_success_page.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/descripcion_producto_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/listado_productos_page.dart';
import 'package:hogar_petfecto/features/publicacion/presentation/carga_mascota.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/login_page.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    // initialLocation: lastVisitedRoute ??
    //     HomePage
    //         .route, // Restaurar la última ruta o usar una ruta predeterminada
    routes: [
      GoRoute(
        path: LoginPage.route,
        builder: (context, state) => const LoginPage(),
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
    ],
  );
}
