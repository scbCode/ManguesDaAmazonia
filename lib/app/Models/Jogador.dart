
class Jogador {
  int id;
  int pontos;
  String faseAtual;
  String nome;

  Jogador({required this.id,required this.nome, required this.pontos, required this.faseAtual});

  factory Jogador.fromMap(Map<String, dynamic> json) => new Jogador(
    id: json["id"],
    nome: json["nome"],
    pontos: json["pontos"],
    faseAtual: json["faseAtual"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nome": nome,
    "pontos": pontos,
    "faseAtual": faseAtual,
  };

}

