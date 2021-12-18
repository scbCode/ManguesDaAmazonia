
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'SeisOlhos/SeisOlhos.dart';

class FinalVermelho extends StatefulWidget {
  Function finalizado;
  FinalVermelho(this.finalizado);

  @override
  _FinalVermelho createState() => _FinalVermelho(finalizado);

}

class _FinalVermelho extends State<FinalVermelho> with SingleTickerProviderStateMixin {


  Function finalizado;
  _FinalVermelho(this.finalizado);

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.white,
              boxShadow: [BoxShadow(color:Colors.black26,blurRadius: 3,spreadRadius: 3)]),
          child:
          Stack(children: [


            Image.asset(
              "lib/assets/images/elementos/cenario_tralhoto.jpg",
              fit: BoxFit.cover,  height:MediaQuery.of(context).size.height,
              width:MediaQuery.of(context).size.width,),
            Positioned(top:MediaQuery.of(context).size.height*.01,right:-30,child:
            Container(
                margin: EdgeInsets.all(15),
                child:
                GestureDetector(onTap:(){
                  launch("https://youtu.be/qOODbkMOjKQ?t=1");
                },child:
                Image.asset(
                  "lib/assets/images/elementos/link_360.png",
                  height:MediaQuery.of(context).size.height*.35,
                  width:MediaQuery.of(context).size.width*.35,), ))),

            Positioned(
                bottom:0,
                right:MediaQuery.of(context).size.width*.35,child:
            GestureDetector(onTap:(){
              setState((){finalizado();});
            },child:
            Container(
              margin: EdgeInsets.all(15),
              child:
              Image.asset(
                "lib/assets/images/elementos/seta_2.png",
                height:MediaQuery.of(context).size.height*.25,
                width:MediaQuery.of(context).size.width*.25,),))),

            Positioned(
                bottom:0,
                left:-20,child:
            Container(
              child:
              Image.asset(
                "lib/assets/images/elementos/garca_e_carangueijo.png",
                height:MediaQuery.of(context).size.height*.6,),)),
            Positioned(
                bottom:-10,
                left:40,child:
            Container(
              margin: EdgeInsets.all(15),
              child:
              Image.asset(
                "lib/assets/images/elementos/carangueijo_conversando.png",
                height:MediaQuery.of(context).size.height*.4,),)),


            Positioned(
                top:MediaQuery.of(context).size.height*.06,
                right:MediaQuery.of(context).size.width*.28,child:

            Container(
              child:SeisOlhos(0),)),

            Positioned(
                bottom:0,
                right:MediaQuery.of(context).size.width*.1,child:
            Container(
              margin: EdgeInsets.all(15),
              child:
              Image.asset(
                "lib/assets/images/elementos/tralhoto.png",
                height:MediaQuery.of(context).size.height*.6,),)),

          ],)
      );

  }


}