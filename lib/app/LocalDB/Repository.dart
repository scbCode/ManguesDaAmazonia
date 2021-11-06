
import 'package:mangues_da_amazonia/app/LocalDB/AppDatabase.dart';
import 'package:mangues_da_amazonia/app/Models/Jogador.dart';

class Repository {

  late AppDatabase dataBase;

  Repository();

  initBD(){
    dataBase.initDB();
  }

  setJogador(Jogador jogador){
    dataBase.setJogador(jogador);
  }

  Future<Jogador> getJogador(int id){
    return dataBase.getJogador(id);
  }

}