import 'package:mangues_da_amazonia/app/Models/Jogador.dart';
import 'package:mobx/mobx.dart';

abstract class JogadorBase with Store {

  @observable
  late Jogador jogador;

  @action
  void setJogador(Jogador jogador){
    this.jogador = jogador;
  }

}