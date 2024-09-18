import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart'; // Importa el paquete

enum SubscriptionPlan { Mensual, Anual }

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  static const String route = '/subscription_page';

  @override
  SubscriptionPageState createState() => SubscriptionPageState();
}

class SubscriptionPageState extends State<SubscriptionPage> {
  SubscriptionPlan selectedPlan = SubscriptionPlan.Mensual;

  final TextEditingController cardNumberController = TextEditingController();
  final MaskedTextController expiryDateController =
      MaskedTextController(mask: '00/00'); // Usa MaskedTextController
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController cardHolderNameController =
      TextEditingController();

  @override
  void dispose() {
    // Limpiar los controladores cuando no se necesiten más
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    cardHolderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Suscripcion'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selección de plan
              const Text(
                'Seleccione un plan de suscripción',
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
                    });
                  },
                ),
              ),
              const SizedBox(height: 24.0),

              // Información de la tarjeta de crédito
              const Text(
                'Información de la Tarjeta de Crédito',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),

              // Número de tarjeta de crédito
              Row(
                children: [
                  const Icon(Icons.credit_card, size: 30.0, color: Colors.blue),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: cardNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 16,
                      decoration: InputDecoration(
                        hintText: 'Número de Tarjeta',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        counterText: '',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Fecha de expiración y CVV
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expiryDateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'MM/AA',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: cvvController,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      decoration: InputDecoration(
                        hintText: 'CVV',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        counterText: '',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Nombre del titular de la tarjeta
              TextField(
                controller: cardHolderNameController,
                decoration: InputDecoration(
                  hintText: 'Nombre del Titular',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // Botón de Confirmación de Suscripción
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Simular el proceso de suscripción
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Suscripción realizada con éxito')),
                    );
                    // Navegar a otra pantalla o finalizar el flujo
                    context.go(HomePage.route);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size(double.infinity, 50), // Botón ancho completo
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      const Text('Suscribirse', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
