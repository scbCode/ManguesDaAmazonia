
import 'package:mangues_da_amazonia/app/LocalDB/AppDatabase.dart';
import 'package:mangues_da_amazonia/app/Models/Jogador.dart';

class Repository {

  late AppDatabase dataBase = AppDatabase();
  Jogador jogador = Jogador(pontos: 0,nome: "teste",faseAtual: "0", id: 100);

  Repository();

  initBD(){
    dataBase. initDB();
  }

  setJogador(){
    dataBase.setJogador(jogador);
  }

  Future<dynamic> getJogador(){
    return dataBase.getJogador(100);
  }

  setPontos(int pontos){
    jogador.pontos=pontos;
    dataBase.setJogador(jogador);
  }

}