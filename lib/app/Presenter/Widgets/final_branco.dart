
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'SeisOlhos/SeisOlhos.dart';

class FinalBranco extends StatefulWidget {
  Function finalizado;
  FinalBranco(this.finalizado);

  @override
  _FinalBranco createState() => _FinalBranco(finalizado);

}

class _FinalBranco extends State<FinalBranco> with SingleTickerProviderStateMixin {


  Function finalizado;
  _FinalBranco(this.finalizado);

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
                "lib/assets/images/elementos/arvore_falando.png",
                height:MediaQuery.of(context).size.height*.4,),)),
          Stack(
            alignment: Alignment.center,
            fit: StackFit.passthrough,
            children:[
            Positioned(
                top:20,
                right:MediaQuery.of(context).size.width*.3,child:
            Container(
              margin: EdgeInsets.all(15),
              child:
              Image.asset(
                "lib/assets/images/elementos/caixa_dialogo.png",
                height:MediaQuery.of(context).size.height*.5,),)),

            Positioned(
                top:MediaQuery.of(context).size.height*.06,
                left:MediaQuery.of(context).size.width*.33,child:
            Container(
              height: MediaQuery.of(context).size.height*.3,
              width: MediaQuery.of(context).size.width*.4,
              padding: EdgeInsets.fromLTRB(0, 0, 35, 0),
              child:SeisOlhos(2),)),
            ]),
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