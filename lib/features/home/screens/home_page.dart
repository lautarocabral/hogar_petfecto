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
import 'package:hogar_petfecto/features/merchandising/presentation/historial_merchandising/historia_ventas_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/historial_merchandising/historial_compras_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/listado_productos_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/gestion_grupos/lista_grupos_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/gestion_usuarios/lista_usuarios_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_adoptante_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_client_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_protectora_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/sign_up_veterinaria_page.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inicio',
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: CircleAvatar(
                foregroundImage: AssetImage('assets/hogar_petfecto_logo.png'),
              ),
            ),
            ListTile(
              title: const Text('Gestion de usuarios'),
              onTap: () {
                context.push(ListaUsuariosPage.route);
              },
            ),
            ListTile(
              title: const Text('Gestion de grupos'),
              onTap: () {
                context.push(ListaGruposPage.route);
              },
            ),
            ListTile(
              leading: Icon(Icons.lock_outline),
              title: const Text('Soy Adoptante!'),
              onTap: () {
                context.push(SignUpAdoptantePage.route);
              },
            ),
            ListTile(
              leading: Icon(Icons.lock_outline),
              title: const Text('Soy Protectora!'),
              onTap: () {
                context.push(SignUpProtectoraPage.route);
              },
            ),
            ListTile(
              leading: Icon(Icons.lock_outline),
              title: const Text('Quiero Merchandising!'),
              onTap: () {
                context.push(SignUpClientPage.route);
              },
            ),
            ListTile(
              leading: Icon(Icons.lock_outline),
              title: const Text('Quiero Publicar mi veterinaria!'),
              onTap: () {
                context.push(SignUpVeterinariaPage.route);
              },
            ),
            ListTile(
              title: const Text('Mis postulaciones'),
              onTap: () {
                context.push(GestionPostulacionesAdoptantePage.route);
              },
            ),
            ListTile(
              title: const Text('Seleccionar adoptantes'),
              onTap: () {
                context.push(GestionPostulacionesProtectoraPage.route);
              },
            ),
            ListTile(
              title: const Text('Mis Compras'),
              onTap: () {
                context.push(HistorialComprasPage.route);
              },
            ),
            ListTile(
              title: const Text('Mis Ventas'),
              onTap: () {
                context.push(HistorialVentasPage.route);
              },
            ),
            ListTile(
              title: const Text('Mi Suscripcion'),
              onTap: () {
                context.push(GestionSuscripcionesPage.route);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
            bottom: 20), // Para evitar que el FAB solape el contenido
        child: Padding(
          padding: const EdgeInsets.all(Margins.largeMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildWelcomeCard(),
              const SizedBox(height: 20),
              // MASCOTAS
              buildBannerButton(
                  context, 'Encontra a tu amigo \npeludo!', Icons.pets, () {
                context.push(ListadoMascotasPage.route);
              }),
              const Gap(10),
              buildBannerButton(context, 'Gestion de mascotas', Icons.info, () {
                context.push(ListaMascotasPage.route);
              }),
              const Gap(10),
              // MERCHANDISING
              buildBannerButton(context, 'Merchandising', Icons.shopping_bag,
                  () {
                context.push(ListadoProductos.route);
              }),
              const Gap(10),
              buildBannerButton(
                  context, 'Gestion de \nMerchandising', Icons.shopping_cart,
                  () {
                context.push(ListaProductosPage.route);
              }),
              const Gap(10),

              // VETERINARIA
              buildBannerButton(
                  context, 'Encontra tu veterinaria!', Icons.local_hospital,
                  () {
                context.push(VeterinariaMapPage.route);
              }),
              const Gap(10),
              buildBannerButton(
                  context, 'Mis instalaciones', Icons.medical_services, () {
                context.push(VeterinariaFacilitiesEditPage.route);
              }),
              const Gap(10),
              buildBannerButton(context, 'Generar QR', Icons.qr_code, () {
                context.push(QrCodePage.route);
              }),
              const Gap(10),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .push(QrScannerPage.route); // Navegar a la página de escaneo QR
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
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

  GestureDetector buildBannerButton(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16.0),
            Icon(icon, color: Colors.white, size: 32.0),
            const SizedBox(width: 16.0),
            Text(
              title,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
