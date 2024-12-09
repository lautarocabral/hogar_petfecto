import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/seguridad/providers/reporte_use_case.dart';
import 'package:intl/intl.dart';

class AuditoriaPage extends ConsumerStatefulWidget {
  const AuditoriaPage({super.key});
  static const String route = '/auditoria';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuditoriaPageState();
}

class _AuditoriaPageState extends ConsumerState<AuditoriaPage> {
  String _formatDate(String? fecha) {
    if (fecha == null) {
      return 'Desconocida';
    }

    try {
      DateTime date = DateTime.parse(fecha);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return 'Fecha no válida';
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventosAuditoriaAsyncValue = ref.watch(auditoriaUseCaseProvider);
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Auditoría de Eventos'),
      body: eventosAuditoriaAsyncValue.when(
        data: (eventosAuditoria) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Eventos de Auditoría',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: eventosAuditoria.events?.length,
                    itemBuilder: (context, index) {
                      var evento = eventosAuditoria.events?[index];
                      return Card(
                        elevation: 5.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              evento?.usuario ?? '', // Inicial del usuario
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            evento?.usuario ?? '',
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Acción: ${evento?.detalle}'),
                              Text('Email: ${evento?.email}'),
                              Text('Fecha: ${_formatDate(evento?.fecha)}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error al cargar eventos: $error'),
        ),
      ),
    );
  }
}
