import '../model/endereco_model.dart';
import '../repositories/cep_repository.dart';
import '../repositories/historico_repository.dart';

class CepService {
  final CepRepository api;
  final HistoricoRepository historico;

  CepService({CepRepository? api, HistoricoRepository? historico})
      : api = api ?? CepRepository(),
        historico = historico ?? HistoricoRepository();

  Future<EnderecoModel> buscarCep(String cep) async {
    final json = await api.buscarCep(cep);
    final endereco = EnderecoModel.fromJson(json);
    await historico.salvar(endereco);
    return endereco;
  }

  Future<List<EnderecoModel>> buscarEndereco({
    required String uf,
    required String cidade,
    required String logradouro,
  }) async {
    final lista = await api.buscarEndereco(
      uf: uf, cidade: cidade, logradouro: logradouro,
    );
    final enderecos = lista.map(EnderecoModel.fromJson).toList();
    for (final item in enderecos) {
      await historico.salvar(item);
    }
    return enderecos;
  }
}
