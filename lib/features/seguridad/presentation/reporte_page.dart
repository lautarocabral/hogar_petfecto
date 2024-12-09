import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphic/graphic.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/features/seguridad/models/reports_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/providers/reporte_use_case.dart';

class ReportePage extends ConsumerStatefulWidget {
  const ReportePage({super.key});
  static const String route = '/reporte';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportePageState();
}

class _ReportePageState extends ConsumerState<ReportePage> {
  @override
  Widget build(BuildContext context) {
    final reportsAsyncValue = ref.watch(reportsUseCaseProvider);
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Reporte de Ventas'),
      body: reportsAsyncValue.when(
        data: (reportsAsyncValue) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reporte Detallado de Ventas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView.separated(
                    itemCount: reportsAsyncValue.reportes!.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      var reporte = reportsAsyncValue.reportes![index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            reporte.usuarioNombre![0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          reporte.usuarioNombre ?? 'Usuario Desconocido',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          'Total Ventas: \$${reporte.total}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Gráfico de Ventas por Protectora',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: Chart(
                    data: convertirEstadisticasAVentasMap(
                        reportsAsyncValue.reportes!),
                    variables: {
                      'empleado': Variable(
                        accessor: (Map map) => map['empleado'] as String,
                      ),
                      'ventas': Variable(
                        scale: LinearScale(
                          min: 0,
                        ),
                        accessor: (Map map) => map['ventas'] as int,
                      ),
                    },
                    marks: [
                      IntervalMark(
                        elevation: SizeEncode(value: 5.0),
                        color: ColorEncode(value: Colors.blueAccent),
                        size: SizeEncode(value: 15),
                      ),
                    ],
                    axes: [
                      Defaults.horizontalAxis,
                      Defaults.verticalAxis,
                    ],
                    selections: {
                      'tooltip': PointSelection(
                        dim: Dim.x,
                      ),
                    },
                    tooltip: TooltipGuide(
                      followPointer: [false, true],
                      align: Alignment.topLeft,
                      variables: ['empleado', 'ventas'],
                      multiTuples: true,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error al cargar reportes: $error'),
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> convertirEstadisticasAVentasMap(
    List<Reportes> estadisticas) {
  return estadisticas.map((ventaStat) {
    return {
      'empleado': ventaStat.usuarioNombre ?? 'Desconocido',
      'ventas': ventaStat.cantidadDePedidos ?? 0,
    };
  }).toList();
}
