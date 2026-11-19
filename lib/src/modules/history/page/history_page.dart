import 'package:material_ui/material_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../home/model/endereco_model.dart';
import '../controller/history_controller.dart';
import '../../../shared/colors/app_colors.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:geocoding/geocoding.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final controller = HistoryController();

  @override
  void initState() {
    super.initState();
    controller.carregar();
  }

  Future<void> rota(EnderecoModel e) async {
    try {
      final q = [e.logradouro, e.bairro, e.localidade, e.uf, 'Brasil']
          .where((x) => x.isNotEmpty).join(', ');
      final geocoding = Geocoding();
      final p = await geocoding.locationFromAddress(q);
      if (p.isEmpty) throw Exception();
      final maps = await MapLauncher.installedMaps;
      if (maps.isEmpty) throw Exception();
      await maps.first.showDirections(
        destination: Coords(p.first.latitude, p.first.longitude),
        directionsMode: DirectionsMode.driving,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nao foi possivel abrir a rota deste endereco.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      title: const Text('Historico de consultas'),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      actions: [IconButton(
        tooltip: 'Limpar historico',
        icon: const Icon(Icons.delete_outline),
        onPressed: () async {
          final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
            title: const Text('Limpar historico?'),
            content: const Text('Todos os enderecos salvos serao removidos.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Limpar')),
            ],
          ));
          if (ok == true) await controller.limpar();
        },
      )],
    ),
    body: Observer(builder: (_) {
      if (controller.carregando.value) return const Center(child: CircularProgressIndicator());
      if (controller.erro.value != null) return Center(child: Text(controller.erro.value!));
      if (controller.itens.isEmpty) return const Center(child: Text('Nenhuma consulta realizada ainda.'));
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.itens.length,
        itemBuilder: (_, i) {
          final e = controller.itens[i];
          return Card(child: ListTile(
            leading: const Icon(Icons.location_on, color: AppColors.primary),
            title: Text(e.logradouro.isEmpty ? 'Endereco sem logradouro' : e.logradouro),
            subtitle: Text('${e.cep} • ${e.localidade}/${e.uf}'),
            trailing: IconButton(icon: const Icon(Icons.directions), onPressed: () => rota(e)),
          ));
        },
      );
    }),
  );
}
