import 'package:mobx/mobx.dart';
import '../../home/model/endereco_model.dart';
import '../../home/repositories/historico_repository.dart';

class HistoryController {
  final HistoricoRepository repository;
  HistoryController({HistoricoRepository? repository})
      : repository = repository ?? HistoricoRepository();

  final carregando = Observable(false);
  final itens = ObservableList<EnderecoModel>();
  final erro = Observable<String?>(null);

  Future<void> carregar() async {
    runInAction(() {
      carregando.value = true;
      erro.value = null;
    });
    try {
      final lista = await repository.buscarTodos();
      runInAction(() {
        itens
          ..clear()
          ..addAll(lista);
      });
    } catch (_) {
      runInAction(() => erro.value = 'Nao foi possivel carregar o historico.');
    } finally {
      runInAction(() => carregando.value = false);
    }
  }

  Future<void> limpar() async {
    await repository.limpar();
    await carregar();
  }
}
