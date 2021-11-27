
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
  late AnimationController _controller;
  Tween<double> _tween = Tween(begin: 0.9, end: 1.5);
  Repository repository = Repository();
  late Jogador jogador;
  bool v_telaInicial=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _controller.repeat(reverse: true);

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
            Visibility(visible: !v_telaInicial,child:
              intro()),
            Visibility(visible: v_telaInicial,child:
              telaInicial())

          ]),
      );
  }

 Widget intro(){
  return
    Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children:[
         Container(
           alignment: Alignment.center,
           width: MediaQuery.of(context).size.width*.9,
           height: MediaQuery.of(context).size.height*.9,
           decoration: BoxDecoration(color:Colors.white,
               boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 5,spreadRadius: 2)],
               borderRadius: BorderRadius.circular(35)),
           padding: EdgeInsets.all(12),
           child:
           ScaleTransition(
               scale: _tween.animate(CurvedAnimation(parent: _controller, curve: Curves.easeInExpo)),
               child:Text("Animação",style:
               TextStyle(fontSize: 16,fontWeight: FontWeight.bold,
                   fontFamily: 'MochiyPopPOne'),)),
         ),
         GestureDetector(
             onTap: (){
               setState(() {
                 v_telaInicial=true;
               });
             },
             child:
         Container(
           padding: EdgeInsets.fromLTRB(24,12,24,12),
           margin: EdgeInsets.all(12),
           child:
           Text("Pular"),
           decoration: BoxDecoration(color: Colors.black26,borderRadius: BorderRadius.circular(35)),))
       ]);

 }

 Widget telaInicial(){
   return
     Column(
       crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.start,
         children:[

            Icon(Icons.audiotrack),

            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*.9,
                child:
            Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children:[
             Text("Tela inicial",style:
             TextStyle(fontSize: 16,fontWeight: FontWeight.normal,
                 fontFamily: 'MochiyPopPOne'),),

          
          Container(
              margin: EdgeInsets.all(56),
              child: 
          Stack(children: [

              Container(
                width: MediaQuery.of(context).size.width*.7,
                height: 40,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.grey[200])),
                    Container(
                      width: MediaQuery.of(context).size.width*.5,
                      height: 40,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.green)),

          ])),

          OutlinedButton(onPressed: (){
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => GameMap()),
             );
          }, child: Text("Jogar"))

    ]))
         ]);
 }

}