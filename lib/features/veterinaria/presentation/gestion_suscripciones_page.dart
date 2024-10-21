import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart';

class GestionSuscripcionesPage extends StatefulWidget {
  const GestionSuscripcionesPage({super.key});

  static const String route = '/gestion-suscripciones';

  @override
  GestionSuscripcionesPageState createState() =>
      GestionSuscripcionesPageState();
}

class GestionSuscripcionesPageState extends State<GestionSuscripcionesPage> {
  SubscriptionPlan selectedPlan =
      SubscriptionPlan.Mensual; // Simulación del plan actual
  bool isSubscribed =
      true; // Estado de si el cliente tiene una suscripción activa o no

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Gestionar Suscripción'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Estado de la suscripción
              const Text(
                'Estado de la Suscripción',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              isSubscribed
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.check_circle,
                              color: Colors.green),
                          title: Text(
                            'Plan actual: ${selectedPlan == SubscriptionPlan.Mensual ? 'Mensual' : 'Anual'}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                              'Renovación: ${selectedPlan == SubscriptionPlan.Mensual ? 'Cada mes' : 'Cada año'}'),
                        ),
                        const SizedBox(height: 16.0),

                        // Botón para cambiar plan
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _cambiarPlan(context);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Cambiar Plan',
                                style: TextStyle(fontSize: 18)),
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Botón para cancelar suscripción
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _cancelarSuscripcion(context);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Cancelar Suscripción',
                                style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        'No tienes una suscripción activa',
                        style: TextStyle(
                            fontSize: 18, color: Colors.grey.shade600),
                      ),
                    ),
              const SizedBox(height: 24.0),

              // Volver a la pantalla principal
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.go(HomePage.route);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Volver al Inicio',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función para cambiar el plan de suscripción
  void _cambiarPlan(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selecciona el nuevo plan de suscripción',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text('Plan Mensual - USD 20'),
                leading: Radio<SubscriptionPlan>(
                  value: SubscriptionPlan.Mensual,
                  groupValue: selectedPlan,
                  onChanged: (SubscriptionPlan? value) {
                    setState(() {
                      selectedPlan = value!;
                      Navigator.pop(context); // Cerrar el modal
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Plan Anual - USD 200'),
                leading: Radio<SubscriptionPlan>(
                  value: SubscriptionPlan.Anual,
                  groupValue: selectedPlan,
                  onChanged: (SubscriptionPlan? value) {
                    setState(() {
                      selectedPlan = value!;
                      Navigator.pop(context); // Cerrar el modal
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Función para cancelar la suscripción
  void _cancelarSuscripcion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancelar Suscripción'),
          content: const Text(
              '¿Estás seguro de que deseas cancelar tu suscripción? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isSubscribed = false;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Tu suscripción ha sido cancelada con éxito')),
                );
              },
              child: const Text('Sí, cancelar'),
            ),
          ],
        );
      },
    );
  }
}

enum SubscriptionPlan { Mensual, Anual }
