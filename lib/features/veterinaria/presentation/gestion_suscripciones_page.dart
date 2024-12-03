import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/models/suscripcion_response_model.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/providers/cambiar_plan_use_case.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/providers/get_suscripcion_use_case.dart';
import 'package:intl/intl.dart';

class GestionSuscripcionesPage extends ConsumerStatefulWidget {
  const GestionSuscripcionesPage({super.key});
  static const String route = '/gestion-suscripciones';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GestionSuscripcionesPageState();
}

class _GestionSuscripcionesPageState
    extends ConsumerState<GestionSuscripcionesPage> {
  SubscriptionPlan selectedPlan =
      SubscriptionPlan.Mensual; // Simulación del plan actual
  bool isSubscribed =
      true; // Estado de si el cliente tiene una suscripción activa o no
  String _formatDate(String? fecha) {
    if (fecha == null) {
      return 'Desconocida';
    }

    try {
      DateTime date = DateTime.parse(fecha);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'Fecha no válida';
    }
  }

  @override
  Widget build(BuildContext context) {
    final suscripcionAsyncValue = ref.watch(getSuscripcionUseCaseProvider);

    return Scaffold(
        appBar: const CustomAppBarWidget(title: 'Gestionar Suscripción'),
        body: suscripcionAsyncValue.when(
          data: (suscripcionAsyncValue) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Estado de la suscripción
                    const Text(
                      'Estado de la Suscripción',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                  'Plan actual: ${suscripcionAsyncValue.suscripcion!.tipoPlan == TipoPlan.mensual ? 'Mensual' : 'Anual'}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                subtitle: Text(
                                  'Desde: ${_formatDate(suscripcionAsyncValue.suscripcion!.fechaInicio)}\nHasta: ${_formatDate(suscripcionAsyncValue.suscripcion!.fechaFin)}',
                                ),
                              ),

                              const SizedBox(height: 16.0),

                              // Botón para cambiar plan
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _cambiarPlan(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 50),
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
                                    minimumSize:
                                        const Size(double.infinity, 50),
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
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text('Error al cargar lista de productos: $error'),
          ),
        ));
  }

  // Función para cambiar el plan de suscripción
  void _cambiarPlan(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        // Variable local para almacenar el plan seleccionado temporalmente
        SubscriptionPlan? tempSelectedPlan = selectedPlan;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
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

                  // Radio para el plan mensual
                  ListTile(
                    title: const Text('Plan Mensual - USD 20'),
                    leading: Radio<SubscriptionPlan>(
                      value: SubscriptionPlan.Mensual,
                      groupValue: tempSelectedPlan,
                      onChanged: (SubscriptionPlan? value) {
                        modalSetState(() {
                          tempSelectedPlan = value;
                        });
                      },
                    ),
                  ),

                  // Radio para el plan anual
                  ListTile(
                    title: const Text('Plan Anual - USD 200'),
                    leading: Radio<SubscriptionPlan>(
                      value: SubscriptionPlan.Anual,
                      groupValue: tempSelectedPlan,
                      onChanged: (SubscriptionPlan? value) {
                        modalSetState(() {
                          tempSelectedPlan = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // Botón de guardar
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (tempSelectedPlan != null) {
                          // Crear las credenciales con el plan seleccionado
                          final credentials = {
                            'suscripcionId': 1,
                            'tipoPlan': tempSelectedPlan!.index,
                            'estado': true
                          };

                          try {
                            // Llamar al provider para actualizar el plan
                            await ref.read(
                                cambiarPlanUseCaseProvider(credentials).future);

                            // Refrescar la suscripción en el estado global
                            ref.invalidate(getSuscripcionUseCaseProvider);

                            // Actualizar el estado global del widget principal
                            setState(() {
                              selectedPlan = tempSelectedPlan!;
                            });

                            Navigator.pop(context); // Cerrar el modal
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Plan actualizado con éxito'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Error al cambiar el plan: $e')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Guardar Cambios',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            );
          },
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
///////////////////////////////////////////////////////////////////

enum SubscriptionPlan { Anual, Mensual }
