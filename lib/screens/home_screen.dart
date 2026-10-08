import 'package:flutter/material.dart';

import '../services/location_service.dart';
import '../services/point_service.dart';
import '../models/point_model.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationService locationService = LocationService();

  String localizacao = 'Verificando localização...';
  String distancia = '-- metros';

  double? distanciaAtual;
  bool dentroDoRaio = false;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    buscarLocalizacao();
  }

  Future<void> buscarLocalizacao() async {
    setState(() {
      carregando = true;
    });

    try {
      final position = await locationService.getCurrentLocation();

      final distanciaCalculada = locationService.calcularDistancia(position);

      final permitido = locationService.estaDentroDoRaio(distanciaCalculada);

      setState(() {
        localizacao =
            'Latitude: ${position.latitude.toStringAsFixed(6)}\n'
            'Longitude: ${position.longitude.toStringAsFixed(6)}';

        distancia = '${distanciaCalculada.toStringAsFixed(1)} metros';

        distanciaAtual = distanciaCalculada;
        dentroDoRaio = permitido;
        carregando = false;
      });
    } catch (e) {
      setState(() {
        localizacao = e.toString();
        distancia = '-- metros';
        dentroDoRaio = false;
        carregando = false;
      });
    }
  }

  Future<void> registrarPonto() async {
    if (carregando) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aguarde a localização ser encontrada.')),
      );
      return;
    }

    if (!dentroDoRaio) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você está a mais de 100 metros do local de trabalho.'),
        ),
      );
      return;
    }

    try {
      final position = await locationService.getCurrentLocation();

      final distanciaCalculada = locationService.calcularDistancia(position);

      final registro = PointModel(
        dataHora: DateTime.now(),
        latitude: position.latitude,
        longitude: position.longitude,
        distancia: distanciaCalculada,
      );

      PointService.adicionarRegistro(registro);

      setState(() {
        localizacao =
            'Latitude: ${position.latitude.toStringAsFixed(6)}\n'
            'Longitude: ${position.longitude.toStringAsFixed(6)}';

        distancia = '${distanciaCalculada.toStringAsFixed(1)} metros';

        distanciaAtual = distanciaCalculada;
        dentroDoRaio = locationService.estaDentroDoRaio(distanciaCalculada);
      });

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Text('Ponto registrado'),
              ],
            ),
            content: Text(
              'Seu ponto foi registrado com sucesso.\n\n'
              'Data: ${formatarData(registro.dataHora)}\n'
              'Hora: ${formatarHora(registro.dataHora)}\n'
              'Distância: ${registro.distancia.toStringAsFixed(1)} metros',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao registrar ponto: $e')));
    }
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Ponto'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
            icon: const Icon(Icons.history),
            tooltip: 'Histórico',
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: buscarLocalizacao,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Olá, Funcionário!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text('Confira sua localização antes de registrar o ponto.'),

              const SizedBox(height: 25),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.location_on, size: 50),

                      const SizedBox(height: 10),

                      const Text(
                        'Localização atual',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      if (carregando)
                        const CircularProgressIndicator()
                      else
                        Text(localizacao, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Distância até o trabalho',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        distancia,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        dentroDoRaio
                            ? 'Dentro da área permitida'
                            : 'Fora da área permitida',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: dentroDoRaio ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: registrarPonto,
                  icon: const Icon(Icons.access_time),
                  label: const Text(
                    'REGISTRAR PONTO',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              OutlinedButton.icon(
                onPressed: buscarLocalizacao,
                icon: const Icon(Icons.refresh),
                label: const Text('ATUALIZAR LOCALIZAÇÃO'),
              ),

              const SizedBox(height: 15),

              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.history),
                label: const Text('VER HISTÓRICO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
