class ExercicioModel {
  String id;
  String nome;
  String treino;
  String descricao;
  String? urlImagem;

  ExercicioModel(
      {required this.id,
      required this.nome,
      required this.treino,
      required this.descricao});

  ExercicioModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        nome = map["nome"],
        treino = map["treino"],
        descricao = map["descricao"],
        urlImagem = map["urlImagem"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "treino": treino,
      "descricao": descricao,
      "urlImagem": urlImagem
    };
  }
}
