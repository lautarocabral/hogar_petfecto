import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/confirmacion_contrato_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/descripcion_mascota_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_mascota/alta_mascota_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_mascota/lista_mascotas_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_postulaciones/detalles_postulante_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_postulaciones/gestion_postulaciones_adoptante_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_postulaciones/gestion_postulaciones_protectora_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/listado_mascotas_page.dart';
import 'package:hogar_petfecto/features/common/presentation/custom_error_page.dart';
import 'package:hogar_petfecto/features/common/presentation/custom_success_page.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/checkout_carrito_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/descripcion_producto_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/gestion_merchandising/alta_producto_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/gestion_merchandising/lista_productos_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/historial_merchandising/historia_ventas_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/historial_merchandising/historial_compras_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/listado_productos_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/carga_mascota.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/gestion_grupos/alta_grupo_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/gestion_grupos/lista_grupos_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/gestion_usuarios/alta_usuario_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/gestion_usuarios/lista_usuarios_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/login_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_adoptante_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_client_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_protectora_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_veterinaria_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/subscription_page.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/gestion_suscripciones_page.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/qr_code_page.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/qr_scanner_page.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/veterinaria_descripcion_page.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/veterinaria_facilities_edit_page.dart';
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
        path: SignUpAdoptantePage.route,
        builder: (context, state) => const SignUpAdoptantePage(),
      ),
      GoRoute(
        path: SignUpProtectoraPage.route,
        builder: (context, state) => const SignUpProtectoraPage(),
      ),
      GoRoute(
        path: SignUpClientPage.route,
        builder: (context, state) => const SignUpClientPage(),
      ),
      GoRoute(
        path: ListaUsuariosPage.route,
        builder: (context, state) => const ListaUsuariosPage(),
      ),
      GoRoute(
        path: AltaUsuarioPage.route,
        builder: (context, state) => const AltaUsuarioPage(),
      ),
      GoRoute(
        path: ListaGruposPage.route,
        builder: (context, state) => const ListaGruposPage(),
      ),
      GoRoute(
        path: AltaGrupoPage.route,
        builder: (context, state) => const AltaGrupoPage(),
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
      // Mascotas
      GoRoute(
        path: CargaMascota.route,
        builder: (context, state) => const CargaMascota(),
      ),
      GoRoute(
        path: ListaMascotasPage.route,
        builder: (context, state) => const ListaMascotasPage(),
      ),
      GoRoute(
        path: AltaMascotaPage.route,
        builder: (context, state) => const AltaMascotaPage(),
      ),
      GoRoute(
        path: GestionPostulacionesAdoptantePage.route,
        builder: (context, state) => const GestionPostulacionesAdoptantePage(),
      ),
      GoRoute(
        path: GestionPostulacionesProtectoraPage.route,
        builder: (context, state) => const GestionPostulacionesProtectoraPage(),
      ),
      GoRoute(
        path: DetallesPostulantePage.route,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          final adoptante = args!['adoptante'] as String;
          final detalles = args!['detalles'] as String;
          return DetallesPostulantePage(
            adoptante: adoptante,
            detalles: detalles,
          );
        },
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
      GoRoute(
        path: ListaProductosPage.route,
        builder: (context, state) => const ListaProductosPage(),
      ),
      GoRoute(
        path: AltaProductoPage.route,
        builder: (context, state) => const AltaProductoPage(),
      ),
      GoRoute(
        path: HistorialComprasPage.route,
        builder: (context, state) => const HistorialComprasPage(),
      ),
      GoRoute(
        path: HistorialVentasPage.route,
        builder: (context, state) => const HistorialVentasPage(),
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
      GoRoute(
        path: QrScannerPage.route,
        builder: (context, state) => const QrScannerPage(),
      ),
      GoRoute(
        path: VeterinariaFacilitiesEditPage.route,
        builder: (context, state) => VeterinariaFacilitiesEditPage(
          veterinaria: Veterinaria(
              id: 1, instalaciones: ['Sala de espera', 'Consultorios']),
        ),
      ),
      GoRoute(
        path: QrCodePage.route,
        builder: (context, state) => const QrCodePage(),
      ),
      GoRoute(
        path: GestionSuscripcionesPage.route,
        builder: (context, state) => const GestionSuscripcionesPage(),
      ),
    ],
  );
}
