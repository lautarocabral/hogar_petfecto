import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/subscription_page.dart';

class SignUpVeterinariaPage extends StatefulWidget {
  const SignUpVeterinariaPage({super.key});
  static const String route = '/sign_up_veterinaria';

  @override
  SignUpVeterinariaPageState createState() => SignUpVeterinariaPageState();
}

class SignUpVeterinariaPageState extends State<SignUpVeterinariaPage> {
  final TextEditingController clinicNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Variable para la ubicación seleccionada
  LatLng? selectedLocation;
  final LatLng initialLocation =
      const LatLng(-32.916421, -60.754828); // Ciudad de México

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Veterinaria'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/sign_up_veterinaria.png',
                  scale: 5,
                ),
              ),
              const SizedBox(height: 16.0),

              // Nombre de la Veterinaria
              CustomTextField(
                hintText: 'Nombre de la Veterinaria',
                controller: clinicNameController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16.0),

              // Dirección
              CustomTextField(
                hintText: 'Dirección',
                controller: addressController,
                textInputAction: TextInputAction.next,
                // readOnly: true,
              ),
              const SizedBox(height: 16.0),

              // Mapa para seleccionar la ubicación
              SizedBox(
                height: 300.0,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: initialLocation,
                    initialZoom: 13.0,
                    onTap: (tapPosition, point) {
                      // Actualiza la ubicación seleccionada y el campo de dirección
                      setState(() {
                        selectedLocation = point;
                        addressController.text =
                            'Lat: ${point.latitude}, Lng: ${point.longitude}';
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    if (selectedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: selectedLocation!,
                            width: 80.0,
                            height: 80.0,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40.0,
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // Teléfono de Contacto
              CustomTextField(
                hintText: 'Teléfono de Contacto',
                controller: phoneController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24.0),

              // Botón de Confirmación
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedLocation != null) {
                      // Navega a la página de suscripción con la información ingresada
                      context.push(SubscriptionPage.route);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Por favor, selecciona una ubicación en el mapa.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size(double.infinity, 50), // Botón ancho completo
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Confirmar y Suscribirse',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
