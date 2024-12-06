import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_text_field_widget.dart';
import 'package:hogar_petfecto/core/utils/validators.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart';
import 'package:hogar_petfecto/features/seguridad/models/veterinaria_model.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/subscription_page.dart';
import 'package:hogar_petfecto/features/seguridad/providers/perfil_provider.dart';
import 'package:latlong2/latlong.dart';

class ProfileCompletionCoordinatorPage extends ConsumerStatefulWidget {
  final List<int> permissionIds;

  const ProfileCompletionCoordinatorPage({
    super.key,
    required this.permissionIds,
  });

  static const String route = '/unified-form';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileCompletionCoordinatorPageState();
}

class _ProfileCompletionCoordinatorPageState
    extends ConsumerState<ProfileCompletionCoordinatorPage> {
  final _adoptanteKey = GlobalKey<FormState>();
  final _clienteKey = GlobalKey<FormState>();
  final _protectoraKey = GlobalKey<FormState>();
  final _veterinariaKey = GlobalKey<FormState>();
  int currentStep = 0;

  // Controllers y estados para cada formulario
  // ADOPTANTE
  final TextEditingController adoptanteOcupacionController =
      TextEditingController();
  final TextEditingController adoptanteNroMascotasController =
      TextEditingController();
  bool adoptanteExperience = false;
  String? adoptanteEstadoCivil;
  bool hasExperienceWithPets = false;
  // CLIENTE
  final TextEditingController clienteCuilController = TextEditingController();
  final TextEditingController clienteOcupacionController =
      TextEditingController();
  // PROTECTORA
  final TextEditingController protectoraCapacityController =
      TextEditingController();
  final TextEditingController protectoraVolunteersController =
      TextEditingController();
  final TextEditingController protectoraCantidadMascotasController =
      TextEditingController();
  // VETERINARIA
  final TextEditingController veterinariaClinicNameController =
      TextEditingController();
  final TextEditingController veterinariaAddressController =
      TextEditingController();
  final TextEditingController veterinariaPhoneController =
      TextEditingController();

  LatLng? selectedLocation;
  final LatLng initialLocation = const LatLng(-32.916421, -60.754828);

  @override
  void dispose() {
    // Limpia los controladores para evitar fugas de memoria
    adoptanteOcupacionController.dispose();
    adoptanteNroMascotasController.dispose();
    clienteCuilController.dispose();
    clienteOcupacionController.dispose();
    protectoraCapacityController.dispose();
    protectoraVolunteersController.dispose();
    protectoraCantidadMascotasController.dispose();
    veterinariaClinicNameController.dispose();
    veterinariaAddressController.dispose();
    veterinariaPhoneController.dispose();
    super.dispose();
  }

  Future<void> _submitCurrentForm() async {
    final currentPermission = widget.permissionIds[currentStep];

    try {
      switch (currentPermission) {
        case 1: // Adoptante
          if ((_adoptanteKey.currentState?.validate() ?? false) &&
              (adoptanteEstadoCivil?.isNotEmpty ?? false)) {
            final adoptanteData = {
              'estadoCivil': adoptanteEstadoCivil,
              'ocupacion': adoptanteOcupacionController.text,
              'experienciaMascotas': adoptanteExperience,
              'nroMascotas': int.parse(adoptanteNroMascotasController.text),
            };
            await ref.read(adoptanteProvider(adoptanteData).future);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Datos de Adoptante completados!')),
            );
          }
          break;

        case 2: // Cliente
          if (_clienteKey.currentState?.validate() ?? false) {
            final clienteData = {
              'cuil': clienteCuilController.text,
              'ocupacion': clienteOcupacionController.text,
            };
            await ref.read(clienteProvider(clienteData).future);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Datos de Cliente completados!')),
            );
          }
          break;
        case 3: // Veterinaria
          if (selectedLocation != null) {
            if (_veterinariaKey.currentState?.validate() ?? false) {
              var veterinariaModel = VeterinariaModel(
                nombre: veterinariaClinicNameController.text,
                latitud: selectedLocation!.latitude,
                longitud: selectedLocation!.longitude,
                telefono: veterinariaPhoneController.text,
                direccionLocal: veterinariaAddressController.text,
                suscripciones: [],
              );
              context.push(
                SubscriptionPage.route,
                extra: veterinariaModel,
              );
            }
          }
          break;

        case 4: // Protectora
          if (_protectoraKey.currentState?.validate() ?? false) {
            final credentials = {
              'capacidad': int.parse(protectoraCapacityController.text),
              'nroVoluntarios': int.parse(protectoraVolunteersController.text),
              'cantidadInicialMascotas':
                  int.parse(protectoraCantidadMascotasController.text),
              'nombreProtectora': '',
            };

            await ref.read(protectoraProvider(credentials).future);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Datos de protectora completados!')),
            );
          }
          break;

        default:
          throw Exception("Permiso desconocido: $currentPermission");
      }

      // Avanzar al siguiente paso
      if (currentStep < widget.permissionIds.length - 1) {
        setState(() {
          currentStep++;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Todos los formularios completados')),
        );
        context.go('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar formulario: $e')),
      );
    }
  }

  Widget _buildForm() {
    final currentPermission = widget.permissionIds[currentStep];

    switch (currentPermission) {
      case 1: // Adoptante
        return Form(
          key: _adoptanteKey,
          child: Column(
            children: [
              Text(
                'Adoptante',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              CustomTextField(
                hintText: 'Ocupacion',
                controller: adoptanteOcupacionController,
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.work), // Icono decorativo
                keyboardType: TextInputType.text, // Acepta solo números
                validator: Validators.fieldRequired,
              ),
              const SizedBox(height: 16.0),

              // Estado Civil (para adoptante)
              DropdownButtonFormField<String>(
                value: adoptanteEstadoCivil,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: 'Estado Civil',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                items: ['Soltero/a', 'Casado/a', 'Divorciado/a', 'Viudo/a']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    adoptanteEstadoCivil = newValue;
                  });
                },
              ),
              const SizedBox(height: 16.0),

              // Experiencia con Mascotas (sí/no)
              const Text('¿Tiene experiencia con mascotas?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              SwitchListTile(
                title: const Text('Experiencia con Mascotas'),
                value: hasExperienceWithPets,
                onChanged: (bool value) {
                  setState(() {
                    hasExperienceWithPets = value;
                  });
                },
                secondary: Icon(
                  hasExperienceWithPets ? Icons.pets : Icons.pets_outlined,
                ), // Cambia el ícono según el estado
              ),
              const SizedBox(height: 16.0),

              // Número de Mascotas (para adoptante)
              CustomTextField(
                hintText: 'Número de Mascotas',
                controller: adoptanteNroMascotasController,
                textInputAction: TextInputAction.done,
                validator: Validators.fieldRequired,
                prefixIcon:
                    const Icon(Icons.format_list_numbered), // Icono decorativo
                keyboardType: TextInputType.number, // Acepta solo números
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        );

      case 2: // Cliente
        return Form(
          key: _clienteKey,
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              Text(
                'Cliente',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              // CUIL (para cliente)
              CustomTextField(
                hintText: 'CUIL',
                controller: clienteCuilController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.badge),
                keyboardType: TextInputType.number,
                validator: Validators.cuil,
              ),
              const SizedBox(height: 16.0),

              // Ocupación (para cliente)
              CustomTextField(
                hintText: 'Ocupación',
                controller: clienteOcupacionController,
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.work),
                validator: Validators.fieldRequired,
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        );

      case 3: // Veterinaria
        return Form(
          key: _veterinariaKey,
          child: Column(
            children: [
              Text(
                'Veterinaria',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
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
                controller: veterinariaClinicNameController,
                textInputAction: TextInputAction.next,
                validator: Validators.fieldRequired,
              ),
              const SizedBox(height: 16.0),

              // Dirección
              CustomTextField(
                hintText: 'Dirección',
                controller: veterinariaAddressController,
                textInputAction: TextInputAction.next,
                validator: Validators.fieldRequired,
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
                        // addressController.text =
                        //     'Lat: ${point.latitude}, Lng: ${point.longitude}';
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
                controller: veterinariaPhoneController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.phone,
                validator: Validators.fieldRequired,
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        );

      case 4: // Protectora
        return Form(
          key: _protectoraKey,
          child: Column(
            children: [
              Text(
                'Protectora',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              CustomTextField(
                hintText: 'Capacidad de la Protectora (cantidad de mascotas)',
                controller: protectoraCapacityController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.home),
                keyboardType: TextInputType.number,
                validator: Validators.fieldRequired,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                hintText: 'Número de Voluntarios',
                controller: protectoraVolunteersController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.people),
                keyboardType: TextInputType.number,
                validator: Validators.fieldRequired,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                hintText: 'Cantidad actual de mascotas',
                controller: protectoraCantidadMascotasController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.pets),
                keyboardType: TextInputType.number,
                validator: Validators.fieldRequired,
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        );

      default:
        return const Text('Formulario desconocido');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Complete su Perfil'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Actualización de Perfil Requerida',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Debido a un cambio en sus permisos, es necesario completar los siguientes formularios para acceder completamente a la aplicación.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            _buildForm(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitCurrentForm,
              child: Text(
                currentStep < widget.permissionIds.length - 1
                    ? 'Siguiente'
                    : 'Finalizar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
