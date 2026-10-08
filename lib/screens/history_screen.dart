import 'package:flutter/material.dart';

import '../models/point_model.dart';
import '../services/point_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }

  String formatarHora(DateTime data) {
    return '${data.hour.toString().padLeft(2, '0')}:'
        '${data.minute.toString().padLeft(2, '0')}:'
        '${data.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final List<PointModel> registros = PointService.listarRegistros();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Ponto'),
        centerTitle: true,
      ),

      body: registros.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80),
                  SizedBox(height: 20),
                  Text(
                    'Nenhum ponto registrado.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Os registros aparecerão aqui.'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: registros.length,
              itemBuilder: (context, index) {
                final registro = registros[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 30,
                            ),

                            const SizedBox(width: 10),

                            const Text(
                              'Ponto registrado',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const Divider(),

                        Text('Data: ${formatarData(registro.dataHora)}'),

                        const SizedBox(height: 5),

                        Text('Horário: ${formatarHora(registro.dataHora)}'),

                        const SizedBox(height: 5),

                        Text(
                          'Distância: '
                          '${registro.distancia.toStringAsFixed(1)} metros',
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'Latitude: '
                          '${registro.latitude.toStringAsFixed(6)}',
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'Longitude: '
                          '${registro.longitude.toStringAsFixed(6)}',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
