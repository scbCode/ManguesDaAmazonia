
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
  late  Image bg_image;
  late  Image garca_e_carangueijo;
  bool load= false;

  @override
  void didChangeDependencies()  {
    super.didChangeDependencies();
    bg_image = Image.asset('lib/assets/images/elementos/cenario_tralhoto.png' ,
      fit: BoxFit.cover,  height:MediaQuery.of(context).size.height,
      width:MediaQuery.of(context).size.width,);

    garca_e_carangueijo =
        Image.asset(
      "lib/assets/images/elementos/garca_e_carangueijo.png",
      height:MediaQuery.of(context).size.height*.6,);


    precacheImage(garca_e_carangueijo.image,context);
      precacheImage(bg_image.image,context).then((value) =>
        setState(() {
          load=true;
      }));

  }


  @override
  void dispose(){
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      !load ? Container(alignment: Alignment.center,color: Colors.white,
        child:
        Column(crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,children:[
              CircularProgressIndicator(color: Color(0xFF0E434B),)
            ]),) :
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.white,
              boxShadow: [BoxShadow(color:Colors.black26,blurRadius: 3,spreadRadius: 3)]),
          child:
          Stack(children: [
            bg_image,
            Positioned(top:MediaQuery.of(context).size.height*.07,right:-30,child:
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
            GestureDetector(onTap:(){finalizado();
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
              child:garca_e_carangueijo
             )),
            Positioned(
                bottom:-10,
                left:40,child:
            Container(
              margin: EdgeInsets.all(15),
              child:
              Image.asset(
                "lib/assets/images/elementos/arvore_falando.png",
                height:MediaQuery.of(context).size.height*.4,),)),
            Positioned(
                top:MediaQuery.of(context).size.height*.04,
                right:MediaQuery.of(context).size.width*.28,child:
            Container(
              child:SeisOlhos(2),)),
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