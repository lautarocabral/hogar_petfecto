import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/seguridad/providers/user_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends ConsumerStatefulWidget {
  const QrCodePage({super.key});
  static const String route = '/qr_code';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QrCodePageState();
}

class _QrCodePageState extends ConsumerState<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userStateNotifierProvider);
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Mi QR'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Escanea este código QR para obtener tu descuento en veterinarias',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20.0),
              // Widget para mostrar el código QR
              QrImageView(
                data: user!.personaDni,
                version: QrVersions.auto,
                size: 320.0,
                gapless: false,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
