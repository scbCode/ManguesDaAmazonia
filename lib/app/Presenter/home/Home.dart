
import 'package:animated_rotation/animated_rotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mangues_da_amazonia/app/LocalDB/Repository.dart';
import 'package:mangues_da_amazonia/app/Models/Jogador.dart';
import 'package:mangues_da_amazonia/app/Presenter/GameMap/GameMap.dart';
import 'package:mobx/mobx.dart';


class Home extends StatefulWidget {

  Home();

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> with SingleTickerProviderStateMixin  {
  Repository repository = Repository();
  late Jogador jogador;
  bool v_telaInicial=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


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
                padding: EdgeInsets.all(15),
                alignment:Alignment.center,
                height:MediaQuery.of(context).size.height,
                width:MediaQuery.of(context).size.width,
                child: new Image.asset('lib/assets/images/tela_04.jpg',  width:MediaQuery.of(context).size.width,fit: BoxFit.cover,),
              ),

              Positioned(
                  bottom: 10,
                  right: MediaQuery.of(context).size.width*.06,
                  child:
              Container(
                  padding: EdgeInsets.all(15),
                  alignment:Alignment.center,
                  color:
                  Colors.white,
                  width: MediaQuery.of(context).size.width*.3,
                  height: MediaQuery.of(context).size.height*.35,
                  child:
              OutlinedButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameMap()),
                );
              }, child: Text("Jogar", style: TextStyle(fontSize:MediaQuery.of(context).size.width*.05),))))


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