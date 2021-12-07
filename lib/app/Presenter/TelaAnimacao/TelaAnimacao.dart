
import 'package:animated_rotation/animated_rotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mangues_da_amazonia/app/LocalDB/Repository.dart';
import 'package:mangues_da_amazonia/app/Models/Jogador.dart';
import 'package:mangues_da_amazonia/app/Presenter/GameMap/GameMap.dart';
import 'package:mangues_da_amazonia/app/Presenter/home/Home.dart';
import 'package:mobx/mobx.dart';


class TelaAnimacao extends StatefulWidget {

  TelaAnimacao();

  @override
  _TelaAnimacao createState() => _TelaAnimacao();
}

class _TelaAnimacao extends State<TelaAnimacao> with SingleTickerProviderStateMixin  {
  Repository repository = Repository();
  late Jogador jogador;
  bool v_telaInicial=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    repository.initBD();
    getJogador_().then((value) => setState((){  print(value.nome);}));

  }

  Future<dynamic> getJogador_(){
    return repository.getJogador();
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              intro(),
            ]),
      );
  }

  Widget intro(){
    return
      Stack(children: [

        Container(
          alignment:Alignment.center,
          height:MediaQuery.of(context).size.height,
          width:MediaQuery.of(context).size.width,
          child: new Image.asset('lib/assets/images/tela_03.jpg'),
        ),

        Positioned (
            bottom:MediaQuery.of(context).size.height*.05,
            right: MediaQuery.of(context).size.width*.025,
            child:
            GestureDetector(
                onTap: (){
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  });
                },
                child:
                Container(
                  child:
                  Image.asset(
                    "lib/assets/images/elementos/botao_pular.png",
                     height:MediaQuery.of(context).size.height*.25,
                    width:MediaQuery.of(context).size.width*.25,),
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(100)),)))
      ],);

  }



}