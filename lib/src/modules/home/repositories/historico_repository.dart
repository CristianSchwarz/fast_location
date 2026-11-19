import 'package:hive/hive.dart';
import '../model/endereco_model.dart';

class HistoricoRepository {
  static const boxName = 'historico_enderecos';

  Future<void> salvar(EnderecoModel endereco) async {
    final box = await Hive.openBox(boxName);
    final key = endereco.cep;
    await box.put(key, endereco.toJson());
  }

  Future<List<EnderecoModel>> buscarTodos() async {
    final box = await Hive.openBox(boxName);
    return box.values
        .map((item) => EnderecoModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList()
        .reversed
        .toList();
  }

  Future<void> limpar() async {
    final box = await Hive.openBox(boxName);
    await box.clear();
  }
}
