import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/features/adopcion/presentation/listado_mascotas_page.dart';
import 'package:hogar_petfecto/features/merchandising/presentation/listado_productos_page.dart';
import 'package:hogar_petfecto/features/publicacion/presentation/carga_mascota.dart';
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
              title: const Text('Gestion de veterinarias'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Gestion de merchandising'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Gestion de usuarios'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Margins.largeMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildWelcomeCard(),
              const SizedBox(height: 20),
              buildBannerButton(
                  context, 'Encontra a tu amigo \npeludo!', Icons.pets, () {
                context.push(ListadoMascotasPage.route);
              }),
              const SizedBox(height: 10),
              buildBannerButton(context, 'Encontrale un hogar!', Icons.store,
                  () {
                context.push(CargaMascota.route);
              }),
              const SizedBox(height: 10),
              buildBannerButton(
                  context, 'Encontra tu veterinaria!', Icons.local_hospital,
                  () {
                context.push(VeterinariaMapPage.route);
              }),
              const SizedBox(height: 10),
              buildBannerButton(context, 'Merchandising', Icons.info, () {
                context.push(ListadoProductos.route);
              }),
            ],
          ),
        ),
      ),
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
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '¡Bienvenido a Hogar Pet-fecto!',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
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
