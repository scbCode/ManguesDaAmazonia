
class Jogador {
  int id;
  String fase_atual;
  String nome;
  int som;

  Jogador({required this.id,required this.nome,  required this.fase_atual,  required this.som});

  factory Jogador.fromMap(Map<String, dynamic> json) => new Jogador(
    id: json["id"],
    nome: json["nome"],
    fase_atual: json["fase_atual"],
    som: json["som"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nome": nome,
    "fase_atual": fase_atual,
    "som": som,
  };

}

