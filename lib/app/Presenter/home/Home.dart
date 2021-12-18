
import 'package:animated_rotation/animated_rotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mangues_da_amazonia/app/LocalDB/Repository.dart';
import 'package:mangues_da_amazonia/app/Models/Jogador.dart';
import 'package:mangues_da_amazonia/app/Presenter/GameMap/GameMap.dart';
import 'package:mobx/mobx.dart';


class Home extends StatefulWidget {
  bool selo=false;

  Home(this.selo);

  @override
  _Home createState() => _Home(selo);
}

class _Home extends State<Home> with SingleTickerProviderStateMixin  {
  Repository repository = Repository();
  late Jogador jogador;
  bool v_telaInicial=false;
  bool selo=false;

  _Home(this.selo);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);


  }

  Future<dynamic> getJogador_(){
    return repository.getJogador();
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(

        alignment: Alignment.center,
        child: Stack(
            children:[

              Container(
                alignment:Alignment.center,
                height:MediaQuery.of(context).size.height,
                width:MediaQuery.of(context).size.width,
                child: new Image.asset('lib/assets/images/tela_04.jpg',  width:MediaQuery.of(context).size.width,fit: BoxFit.cover,),
              ),

              Positioned(
                  top: 5,
                  right: MediaQuery.of(context).size.width*.025,
                  child:
                  Container(
                      padding: EdgeInsets.all(15),
                      alignment:Alignment.center,
                      child: Image.asset('lib/assets/images/elementos/botao_audio.png',
                        width:MediaQuery.of(context).size.width*.04,fit: BoxFit.cover,)
                  )),

              Positioned(
                  top: 5,
                  right: MediaQuery.of(context).size.width*.1,
                  child:
                  Container(
                      padding: EdgeInsets.all(15),
                      alignment:Alignment.center,
                      child: Image.asset('lib/assets/images/elementos/botao_opcao.png',
                        width:MediaQuery.of(context).size.width*.04,fit: BoxFit.cover,)
                  )),

              Positioned(
                  bottom: 0,
                  right: MediaQuery.of(context).size.width*.05,
                  child:
              GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GameMap(0)),
                        );
                      },
                   child:
              Container(
                  padding: EdgeInsets.all(15),
                  alignment:Alignment.center,
                  width: MediaQuery.of(context).size.width*.4,
                  child: Image.asset('lib/assets/images/elementos/botao_jogar.png',fit: BoxFit.cover,)))),

              Visibility(visible: selo,
                  child:
                  Positioned(
                      top: MediaQuery.of(context).size.height*.3,
                      right: MediaQuery.of(context).size.width*.05,
                      child:
              GestureDetector(
                  onTap:(){
                    setState(() {
                    });
                  },child:
                  Image.asset('lib/assets/images/elementos/selo.png',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height*.2,
                    width: MediaQuery.of(context).size.width*.2))
              )),


            ]),
      );
  }


 Widget telaInicial(){
   return
     Column(
       crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.start,
         children:[

            Icon(Icons.audiotrack),



    ]);
 }

}