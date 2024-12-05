import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/features/adopcion/models/get_all_mascotas_response_model.dart';
import 'package:hogar_petfecto/features/adopcion/models/mascotas_for_protectoras_response_model.dart';
import 'package:hogar_petfecto/features/adopcion/models/postulaciones_with_postulantes_response_model.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/confirmacion_contrato_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/descripcion_mascota_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_mascota/alta_mascota_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_mascota/edit_mascota_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_mascota/lista_mascotas_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_postulaciones/detalles_postulante_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_postulaciones/gestion_postulaciones_adoptante_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_postulaciones/gestion_postulaciones_protectora_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/listado_mascotas_page.dart';
import 'package:hogar_petfecto/features/common/presentation/custom_error_page.dart';
import 'package:hogar_petfecto/features/common/presentation/custom_success_page.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart';
import 'package:hogar_petfecto/features/merchandising/models/lista_productos_response_model.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/checkout_carrito_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/descripcion_producto_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/gestion_merchandising/alta_producto_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/gestion_merchandising/editar_producto_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/gestion_merchandising/lista_productos_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/historial_merchandising/historial_ventas_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/historial_merchandising/historial_compras_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/listado_productos_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/carga_mascota.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/oc_pdf_page.dart';
import 'package:hogar_petfecto/features/seguridad/models/lista_usuarios_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/models/veterinaria_model.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/gestion_grupos/alta_grupo_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/gestion_grupos/lista_grupos_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/gestion_usuarios/alta_usuario_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/gestion_usuarios/editar_usuario_page.dart';
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
import 'package:hogar_petfecto/features/veterinaria/presentation/renovar_suscripcion_page.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/veterinaria_descripcion_page.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/veterinaria_facilities_edit_page.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/veterinaria_map_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
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
        path: SignUpPage.route,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: SignUpVeterinariaPage.route,
        builder: (context, state) => const SignUpVeterinariaPage(),
      ),
      GoRoute(
        path: SubscriptionPage.route,
        builder: (context, state) {
          // Obtén el argumento desde `state.extra`
          final veterinariaModel = state.extra as VeterinariaModel?;

          return SubscriptionPage(
            veterinariaModel: veterinariaModel,
          );
        },
      ),
      GoRoute(
        path: EditarUsuarioPage.route,
        builder: (context, state) {
          final usuario = state.extra as UsuarioDtos;
          return EditarUsuarioPage(
            usuario: usuario,
          );
        },
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
        builder: (context, state) {
          final mascota = state.extra as GetAllMascotasDto;
          return DescripcionMascotaPage(mascota: mascota);
        },
      ),
      GoRoute(
        path: ConfirmacionContratoPage.route,
        builder: (context, state) {
          final mascota = state.extra as GetAllMascotasDto;
          return ConfirmacionContratoPage(mascota: mascota);
        },
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
      // GoRoute(
      //   path: CargaMascota.route,
      //   builder: (context, state) => const CargaMascota(),
      // ),
      GoRoute(
        path: ListaMascotasPage.route,
        builder: (context, state) => const ListaMascotasPage(),
      ),
      GoRoute(
        path: AltaMascotaPage.route,
        builder: (context, state) => const AltaMascotaPage(),
      ),
      GoRoute(
        path: EditarMascotaPage.route,
        builder: (context, state) {
          final mascota =
              state.extra as MascotasDto; // Retrieve the passed Mascota object
          return EditarMascotaPage(mascota: mascota);
        },
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
          final postulante =
              state.extra as Personas; // Recuperar el objeto `Personas`
          return DetallesPostulantePage(
            adoptante: postulante.razonSocial ?? 'Sin nombre',
            detalles: '''
          DNI: ${postulante.dni ?? 'Sin DNI'}
          Dirección: ${postulante.direccion ?? 'Sin dirección'}
          Teléfono: ${postulante.telefono ?? 'Sin teléfono'}
          Fecha de Nacimiento: ${postulante.fechaNacimiento ?? 'Sin fecha'}
          Estado Civil: ${postulante.estadoCivil ?? 'No especificado'}
          Ocupación: ${postulante.ocupacion ?? 'No especificada'}
          Experiencia con Mascotas: ${postulante.experienciaMascotas == true ? 'Sí' : 'No'}
          Número de Mascotas: ${postulante.nroMascotas ?? 0}
        ''',
          );
        },
      ),

      // Merchandising
      GoRoute(
        path: ListadoProductosPage.route,
        builder: (context, state) => const ListadoProductosPage(),
      ),
      GoRoute(
        path: DescripcionProductoPage.route,
        builder: (context, state) {
          final product = state.extra as Productos;
          return DescripcionProductoPage(product: product);
        },
      ),
      GoRoute(
        path: OcPdfPage.route,
        builder: (context, state) {
          final file = state.extra as String;
          return OcPdfPage(file: file);
        },
      ),
      GoRoute(
        path: CheckoutCarritoPage.route,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          final items = args!['cartItems'] as List<dynamic>;
          final totalPrice = items.fold(0.0, (sum, item) => sum + item.price);
          return const CheckoutCarritoPage();
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
        path: EditarProductoPage.route,
        builder: (context, state) {
          final args = state.extra as Productos;

          return EditarProductoPage(
            producto: args,
          );
        },
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
      GoRoute(
        path: RenovarSuscripcionPage.route,
        builder: (context, state) {
          return const RenovarSuscripcionPage();
        },
      ),
    ],
  );
}
