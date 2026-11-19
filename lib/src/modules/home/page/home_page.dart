
import 'package:material_ui/material_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:geocoding/geocoding.dart';

import '../../../shared/colors/app_colors.dart';
import '../controller/home_controller.dart';
import '../model/endereco_model.dart';
import '../../history/page/history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();

  final cep = TextEditingController();
  final uf = TextEditingController();
  final cidade = TextEditingController();
  final logradouro = TextEditingController();

  bool buscaPorEndereco = false;

  @override
  void dispose() {
    cep.dispose();
    uf.dispose();
    cidade.dispose();
    logradouro.dispose();
    super.dispose();
  }

  Future<void> abrirRota(EnderecoModel item) async {
    try {
      final query = [
        item.logradouro,
        item.bairro,
        item.localidade,
        item.uf,
        'Brasil',
      ].where((e) => e.trim().isNotEmpty).join(', ');

      final geocoding = Geocoding();
      final locais = await geocoding.locationFromAddress(query);

      if (locais.isEmpty) {
        throw Exception('Endereco sem coordenadas');
      }

      final coords = Coords(
        locais.first.latitude,
        locais.first.longitude,
      );

      final maps = await MapLauncher.installedMaps;

      if (maps.isEmpty) {
        throw Exception('Nenhum aplicativo de mapas instalado');
      }

      await maps.first.showDirections(
        destination: coords,
        directionsMode: DirectionsMode.driving,
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Nao foi possivel abrir a rota. Confira se ha um app de mapas instalado.',
          ),
        ),
      );
    }
  }

  Widget campo(
    TextEditingController c,
    String label, {
    TextInputType type = TextInputType.text,
    int? max,
  }) {
    return TextField(
      controller: c,
      keyboardType: type,
      maxLength: max,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('FastLocation'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Historico',
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoryPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              const Text(
                'Consulte um endereco',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),

              const SizedBox(height: 8),

              const Text('Pesquise por CEP ou por endereco.'),

              const SizedBox(height: 18),

              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: false,
                    label: Text('Por CEP'),
                    icon: Icon(Icons.pin),
                  ),
                  ButtonSegment(
                    value: true,
                    label: Text('Por endereco'),
                    icon: Icon(Icons.location_city),
                  ),
                ],
                selected: {buscaPorEndereco},
                onSelectionChanged: (s) {
                  setState(() {
                    buscaPorEndereco = s.first;
                  });
                },
              ),

              const SizedBox(height: 16),

              if (!buscaPorEndereco) ...[
                campo(
                  cep,
                  'CEP',
                  type: TextInputType.number,
                  max: 8,
                ),

                ElevatedButton.icon(
                  onPressed: () => controller.buscarCep(cep.text),
                  icon: const Icon(Icons.search),
                  label: const Text('Consultar CEP'),
                ),
              ] else ...[
                campo(
                  uf,
                  'UF (ex.: SC)',
                  max: 2,
                ),

                const SizedBox(height: 10),

                campo(
                  cidade,
                  'Cidade (ex.: Jaragua do Sul)',
                ),

                const SizedBox(height: 10),

                campo(
                  logradouro,
                  'Logradouro (ex.: Avenida Getulio Vargas)',
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    controller.buscarEndereco(
                      uf: uf.text,
                      cidade: cidade.text,
                      logradouro: logradouro.text,
                    );
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar endereco'),
                ),
              ],

              const SizedBox(height: 22),

              Observer(
                builder: (_) {
                  if (controller.carregando.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (controller.erro.value != null) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          controller.erro.value!,
                          style: const TextStyle(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    );
                  }

                  final item = controller.endereco.value;

                  if (item != null) {
                    return _cardEndereco(
                      item,
                      principal: true,
                    );
                  }

                  if (controller.resultados.isNotEmpty) {
                    return Column(
                      children: controller.resultados
                          .map((e) => _cardEndereco(e))
                          .toList(),
                    );
                  }

                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'O endereco consultado aparecera aqui.',
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardEndereco(
    EnderecoModel e, {
    bool principal = false,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (principal)
              const Text(
                'Ultimo endereco consultado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

            Text('CEP: ${e.cep}'),
            Text('Logradouro: ${e.logradouro}'),

            if (e.complemento.isNotEmpty)
              Text('Complemento: ${e.complemento}'),

            Text('Bairro: ${e.bairro}'),
            Text('Cidade: ${e.localidade}'),
            Text('Estado: ${e.uf}'),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => abrirRota(e),
                icon: const Icon(Icons.directions),
                label: const Text('Traçar rota'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
