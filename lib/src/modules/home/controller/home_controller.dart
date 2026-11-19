
import 'package:mobx/mobx.dart';
import '../model/endereco_model.dart';
import '../service/cep_service.dart';

class HomeController {
  final CepService service;

  HomeController({CepService? service})
      : service = service ?? CepService();

  final carregando = Observable(false);
  final endereco = Observable<EnderecoModel?>(null);
  final resultados = ObservableList<EnderecoModel>();
  final erro = Observable<String?>(null);

  Future<void> buscarCep(String valor) async {
    final cep = valor.replaceAll(RegExp(r'\D'), '');

    if (cep.length != 8) {
      runInAction(() => erro.value = 'Digite um CEP com 8 números.');
      return;
    }

    runInAction(() {
      carregando.value = true;
      erro.value = null;
      endereco.value = null;
      resultados.clear();
    });

    try {
      final item = await service.buscarCep(cep);
      runInAction(() => endereco.value = item);
    } catch (_) {
      runInAction(() {
        erro.value = 'CEP não encontrado ou falha na conexão.';
      });
    } finally {
      runInAction(() => carregando.value = false);
    }
  }

  Future<void> buscarEndereco({
    required String uf,
    required String cidade,
    required String logradouro,
  }) async {
    if (uf.trim().length != 2 ||
        cidade.trim().isEmpty ||
        logradouro.trim().isEmpty) {
      runInAction(() => erro.value = 'Informe UF, cidade e logradouro.');
      return;
    }

    runInAction(() {
      carregando.value = true;
      erro.value = null;
      endereco.value = null;
      resultados.clear();
    });

    try {
      final lista = await service.buscarEndereco(
        uf: uf.trim().toUpperCase(),
        cidade: cidade.trim(),
        logradouro: logradouro.trim(),
      );

      runInAction(() {
        resultados.addAll(lista);
        if (lista.isEmpty) {
          erro.value = 'Nenhum endereço encontrado.';
        }
      });
    } catch (_) {
      runInAction(() {
        erro.value = 'Falha ao pesquisar endereço. Confira os dados e tente novamente.';
      });
    } finally {
      runInAction(() => carregando.value = false);
    }
  }

  void selecionar(EnderecoModel item) {
    runInAction(() {
      endereco.value = item;
      resultados.clear();
      erro.value = null;
    });
  }
}
