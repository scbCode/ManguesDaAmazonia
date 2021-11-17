
import 'package:animated_rotation/animated_rotation.dart';
import 'package:flutter/material.dart';

class GameMap extends StatefulWidget {

  GameMap();

  @override
  _GameMap createState() => _GameMap();
}

class _GameMap extends State<GameMap> with SingleTickerProviderStateMixin  {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width*.7,
              height: MediaQuery.of(context).size.height*.7,
              decoration: BoxDecoration(color:Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 5,spreadRadius: 2)],
                  borderRadius: BorderRadius.circular(35)),
              padding: EdgeInsets.all(12),
              child:
              Text("MAPA",style:
                  TextStyle(fontSize: 16,fontWeight: FontWeight.bold,
                      fontFamily: 'MochiyPopPOne'),),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(24,12,24,12),
              margin: EdgeInsets.all(12),
              child:
              Text("iniciar"),
              decoration: BoxDecoration(color: Colors.black26,borderRadius: BorderRadius.circular(35)),)

          ]);

  }

  Widget formPerguntas(var title, List<String> perguntas){
    return
      Container(
        width: MediaQuery.of(context).size.width,
        child:
        Container(
          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30),
          boxShadow: [ BoxShadow()]),
          child: Column(children: [
            Container(child: Text(title,style:
            TextStyle(fontSize: 16,fontWeight: FontWeight.normal,
                fontFamily: 'MochiyPopPOne'),),)
        ],),));
  }


}