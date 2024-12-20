import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart';
import 'package:hogar_petfecto/features/veterinaria/providers/cambiar_estado_use_case.dart';

enum SubscriptionPlan { Anual, Mensual }

class RenovarSuscripcionPage extends ConsumerStatefulWidget {
  const RenovarSuscripcionPage({
    super.key,
  });
  static const String route = '/renovar_suscription_page';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RenovarSuscripcionPageState();
}

class _RenovarSuscripcionPageState
    extends ConsumerState<RenovarSuscripcionPage> {
  SubscriptionPlan selectedPlan = SubscriptionPlan.Mensual;

  final TextEditingController cardNumberController = TextEditingController();
  final MaskedTextController expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController cardHolderNameController =
      TextEditingController();

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    cardHolderNameController.dispose();
    super.dispose();
  }

  Future<void> renovarSuscripcion(context) async {
    try {
      final credentials = {
        'suscripcionId': 1,
        'tipoPlan': selectedPlan.index,
        'estado': true
      };

      await ref.read(cambiarEstadoUseCaseProvider(credentials).future);

      // Notificación de éxito
      await ScaffoldMessenger.of(context)
          .showSnackBar(
            const SnackBar(
              content: Text('Veterinaria registrada con éxito'),
              duration: Duration(seconds: 1),
            ),
          )
          .closed;

      // Regresa a la pantalla anterior
      GoRouter.of(context).go(HomePage.route);
    } on DioException catch (e) {
      // Use ApiClient's handleError to display the error for non-401 errors
      ref.read(apiClientProvider).handleError(context, e);
    }
  }

  Future<void> _launchUrlAndConfirm(
      BuildContext context, SubscriptionPlan plan) async {
    final theme = Theme.of(context);
    String link = plan == SubscriptionPlan.Anual
        ? 'https://mpago.la/11VsDMS'
        : 'https://mpago.la/2zJ3GfM';

    try {
      await launchUrl(
        Uri.parse(link),
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: theme.colorScheme.surface,
            navigationBarColor: theme.colorScheme.surface,
          ),
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: theme.colorScheme.surface,
          preferredControlTintColor: theme.colorScheme.onSurface,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    // Espera 3 segundos antes de mostrar el diálogo de confirmación
    await Future.delayed(Duration(seconds: 3));
    await _showConfirmationDialog(context);
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmación de Pago'),
        content: Text('¿Finalizaste el pago?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Sí'),
          ),
        ],
      ),
    );

    if (result == true) {
      await renovarSuscripcion(context);
    }
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
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // await _launchUrl(context, selectedPlan);
                    await _launchUrlAndConfirm(context, selectedPlan);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
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
