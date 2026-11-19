class EnderecoModel {
  final String cep, logradouro, complemento, bairro, localidade, uf, ddd;

  const EnderecoModel({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.ddd,
  });

  factory EnderecoModel.fromJson(Map<String, dynamic> json) => EnderecoModel(
    cep: (json['cep'] ?? '').toString(),
    logradouro: (json['logradouro'] ?? '').toString(),
    complemento: (json['complemento'] ?? '').toString(),
    bairro: (json['bairro'] ?? '').toString(),
    localidade: (json['localidade'] ?? '').toString(),
    uf: (json['uf'] ?? '').toString(),
    ddd: (json['ddd'] ?? '').toString(),
  );

  Map<String, dynamic> toJson() => {
    'cep': cep, 'logradouro': logradouro, 'complemento': complemento,
    'bairro': bairro, 'localidade': localidade, 'uf': uf, 'ddd': ddd,
  };

  String get enderecoCompleto =>
      [logradouro, bairro, '$localidade - $uf', cep]
          .where((e) => e.trim().isNotEmpty)
          .join(', ');
}
