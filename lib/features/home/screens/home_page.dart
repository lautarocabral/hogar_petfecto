import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_mascota/lista_mascotas_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_postulaciones/gestion_postulaciones_adoptante_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/gestion_postulaciones/gestion_postulaciones_protectora_page.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/listado_mascotas_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/gestion_merchandising/lista_productos_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/historial_merchandising/historial_ventas_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/historial_merchandising/historial_compras_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/listado_productos_page.dart';
import 'package:hogar_petfecto/features/seguridad/models/login_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/gestion_grupos/lista_grupos_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/gestion_usuarios/lista_usuarios_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_adoptante_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_client_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_protectora_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_veterinaria_page.dart';
import 'package:hogar_petfecto/features/seguridad/providers/user_provider.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/gestion_suscripciones_page.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/qr_code_page.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/qr_scanner_page.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/veterinaria_facilities_edit_page.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/veterinaria_map_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static const String route = '/home';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(
    BuildContext context,
  ) {
    final user = ref.watch(userStateNotifierProvider);
    print('User in home: $user');

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Inicio',
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    // Scaffold.of(context).openDrawer();
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
              ],
            );
          },
        ),
      ),
      drawer: buildDrawer(user),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Padding(
          padding: const EdgeInsets.all(Margins.largeMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildWelcomeCard(),
              const SizedBox(height: 20),
              // MASCOTAS
              if (user.grupos.any(
                  (grupo) => grupo.permisos.any((permiso) => permiso.id == 1)))
                buildBannerButton(
                  context,
                  'Encontra a tu amigo \npeludo!',
                  Icons.pets,
                  () {
                    context.push(ListadoMascotasPage.route);
                  },
                ),
              const Gap(10),
              if (user.grupos.any(
                  (grupo) => grupo.permisos.any((permiso) => permiso.id == 4)))
                buildBannerButton(
                  context,
                  'Gestion de mascotas',
                  Icons.info,
                  () {
                    context.push(ListaMascotasPage.route);
                  },
                ),
              if (user.grupos.any(
                  (grupo) => grupo.permisos.any((permiso) => permiso.id == 2)))
                const Gap(10),
              // MERCHANDISING
              if (user.grupos.any(
                  (grupo) => grupo.permisos.any((permiso) => permiso.id == 2)))
                buildBannerButton(
                  context,
                  'Merchandising',
                  Icons.shopping_bag,
                  () {
                    context.push(ListadoProductosPage.route);
                  },
                ),
              if (user.grupos.any(
                  (grupo) => grupo.permisos.any((permiso) => permiso.id == 4)))
                const Gap(10),
              if (user.grupos.any(
                  (grupo) => grupo.permisos.any((permiso) => permiso.id == 4)))
                buildBannerButton(
                  context,
                  'Gestion de \nMerchandising',
                  Icons.shopping_cart,
                  () {
                    context.push(ListaProductosPage.route);
                  },
                ),
              if (user.grupos.any(
                  (grupo) => grupo.permisos.any((permiso) => permiso.id == 3)))
                const Gap(10),
              // VETERINARIA
              if (!user.grupos.any(
                  (grupo) => grupo.permisos.any((permiso) => permiso.id == 3)))
                buildBannerButton(
                  context,
                  'Encontra tu veterinaria!',
                  Icons.local_hospital,
                  () {
                    context.push(VeterinariaMapPage.route);
                  },
                ),

              if (user.grupos.any(
                  (grupo) => grupo.permisos.any((permiso) => permiso.id == 3)))
                const Gap(10),
              if (user.grupos.any(
                  (grupo) => grupo.permisos.any((permiso) => permiso.id == 3)))
                buildBannerButton(
                  context,
                  'Mis instalaciones',
                  Icons.medical_services,
                  () {
                    context.push(VeterinariaFacilitiesEditPage.route);
                  },
                ),
              // const Gap(10),
              if (user.grupos.any((grupo) => grupo.id == 2)) buildGuestCard(),
              const Gap(10),
              buildBannerButton(context, 'Generar QR', Icons.qr_code, () {
                context.push(QrCodePage.route);
              }),
              const Gap(10),
            ],
          ),
        ),
      ),
      floatingActionButton: user.grupos.any((grupo) =>
                  grupo.permisos.any((permiso) => permiso.id == 3)) ==
              true
          ? FloatingActionButton(
              onPressed: () {
                context.push(
                    QrScannerPage.route); // Navegar a la página de escaneo QR
              },
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  Card buildWelcomeCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Image(
                image: AssetImage('assets/hogar_petfecto_intro_logo.png'),
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Aquí podrás encontrar tu próxima mascota, gestionar tus adopciones y mucho más.',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card buildGuestCard() {
    return Card(
      elevation: 6.0,
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_circle, color: Colors.blueAccent, size: 28),
                const SizedBox(width: 10),
                Text(
                  'Perfil Incompleto',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Para acceder a todos nuestros servicios, completa tu perfil en el menú lateral.',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                //  Scaffold.of(context).openDrawer();
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: const Icon(Icons.edit, color: Colors.white),
              label: Text(
                'Completar perfil',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildBannerButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isEnabled = true,
  }) {
    return GestureDetector(
      onTap: isEnabled
          ? onTap
          : null, // Solo llama a onTap si el botón está habilitado
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: isEnabled
              ? Colors.blueAccent
              : Colors.grey, // Cambia el color según el estado
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16.0),
            Icon(
              icon,
              color: Colors.white.withOpacity(
                  isEnabled ? 1.0 : 0.5), // Cambia la opacidad del icono
              size: 32.0,
            ),
            const SizedBox(width: 16.0),
            Text(
              title,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white.withOpacity(
                      isEnabled ? 1.0 : 0.5), // Cambia la opacidad del texto
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer buildDrawer(UsuarioResponseDto user) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: CircleAvatar(
              foregroundImage: AssetImage('assets/hogar_petfecto_logo.png'),
            ),
          ),
          if (user.grupos
              .any((grupo) => grupo.permisos.any((permiso) => permiso.id == 9)))
            ListTile(
              title: const Text('Gestion de usuarios'),
              onTap: () {
                context.push(ListaUsuariosPage.route);
              },
            ),
          if (user.grupos
              .any((grupo) => grupo.permisos.any((permiso) => permiso.id == 9)))
            ListTile(
              title: const Text('Gestion de grupos'),
              onTap: () {
                context.push(ListaGruposPage.route);
              },
            ),
          if (user.grupos.any((grupo) =>
                  grupo.permisos.any((permiso) => permiso.id == 5)) &&
              !user.grupos.any(
                  (grupo) => grupo.permisos.any((permiso) => permiso.id == 1)))
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Soy Adoptante!'),
              onTap: () {
                context.push(SignUpAdoptantePage.route);
              },
            ),
          if (user.grupos.any((grupo) =>
                  grupo.permisos.any((permiso) => permiso.id == 8)) &&
              !user.grupos.any(
                  (grupo) => grupo.permisos.any((permiso) => permiso.id == 4)))
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Soy Protectora!'),
              onTap: () {
                context.push(SignUpProtectoraPage.route);
              },
            ),
          if (user.grupos.any((grupo) =>
                  grupo.permisos.any((permiso) => permiso.id == 6)) &&
              !user.grupos.any(
                  (grupo) => grupo.permisos.any((permiso) => permiso.id == 2)))
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Quiero Merchandising!'),
              onTap: () {
                context.push(SignUpClientPage.route);
              },
            ),
          if (user.grupos.any((grupo) =>
                  grupo.permisos.any((permiso) => permiso.id == 7)) &&
              !user.grupos.any(
                  (grupo) => grupo.permisos.any((permiso) => permiso.id == 3)))
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Quiero Publicar mi veterinaria!'),
              onTap: () {
                context.push(SignUpVeterinariaPage.route);
              },
            ),
          if (user.grupos
              .any((grupo) => grupo.permisos.any((permiso) => permiso.id == 1)))
            ListTile(
              title: const Text('Mis postulaciones'),
              onTap: () {
                context.push(GestionPostulacionesAdoptantePage.route);
              },
            ),
          if (user.grupos
              .any((grupo) => grupo.permisos.any((permiso) => permiso.id == 4)))
            ListTile(
              title: const Text('Seleccionar adoptantes'),
              onTap: () {
                context.push(GestionPostulacionesProtectoraPage.route);
              },
            ),
          if (user.grupos
              .any((grupo) => grupo.permisos.any((permiso) => permiso.id == 2)))
            ListTile(
              title: const Text('Mis Compras'),
              onTap: () {
                context.push(HistorialComprasPage.route);
              },
            ),
          if (user.grupos
              .any((grupo) => grupo.permisos.any((permiso) => permiso.id == 4)))
            ListTile(
              title: const Text('Mis Ventas'),
              onTap: () {
                context.push(HistorialVentasPage.route);
              },
            ),
          if (user.grupos
              .any((grupo) => grupo.permisos.any((permiso) => permiso.id == 3)))
            ListTile(
              title: const Text('Mi Suscripcion'),
              onTap: () {
                context.push(GestionSuscripcionesPage.route);
              },
            ),
        ],
      ),
    );
  }
}
