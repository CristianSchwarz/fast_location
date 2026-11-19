import '../../../http/dio_client.dart';

class CepRepository {
  Future<Map<String, dynamic>> buscarCep(String cep) async {
    final response = await DioClient.instance.get('/$cep/json/');
    final data = Map<String, dynamic>.from(response.data as Map);
    if (data['erro'] == true || data.containsKey('erro')) {
      throw Exception('CEP nao encontrado.');
    }
    return data;
  }

  Future<List<Map<String, dynamic>>> buscarEndereco({
    required String uf,
    required String cidade,
    required String logradouro,
  }) async {
    final path = '/${Uri.encodeComponent(uf)}/${Uri.encodeComponent(cidade)}/${Uri.encodeComponent(logradouro)}/json/';
    final response = await DioClient.instance.get(path);
    return (response.data as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }
}
