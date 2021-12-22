
import 'package:mangues_da_amazonia/app/LocalDB/AppDatabase.dart';
import 'package:mangues_da_amazonia/app/Models/Jogador.dart';
import 'package:sqflite/sqflite.dart';

class Repository {

  late AppDatabase dataBase = AppDatabase();
  late Database _database;
  static Jogador jogador = Jogador(nome: "-",fase_atual: "0", id: 1);

  Repository();

  initBD() async{
    await  dataBase. initDB();
  }

  setJogador(String nome) async{
    jogador.nome=nome;
   return await dataBase.setJogador(jogador);
  }
  updateJogador(String fase) async{
    jogador.fase_atual=fase.toString();
    await dataBase.updateJogador(jogador);
  }

  Future<dynamic> getJogador(int id) async {
    var jogador_ = await dataBase.getJogador(id);
    if (jogador_!=null)
      jogador = jogador_;
    return jogador_;
  }


}