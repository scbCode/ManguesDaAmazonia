
import 'dart:async';
import 'dart:ui';

import 'package:animated_rotation/animated_rotation.dart';
import 'package:flutter/material.dart';
import 'package:mangues_da_amazonia/app/Presenter/Widgets/MapBlack.dart';
import 'package:mangues_da_amazonia/app/Presenter/Widgets/MapRed.dart';
import 'package:mangues_da_amazonia/app/Presenter/Widgets/MapWhite.dart';

class GameMap extends StatefulWidget {

  GameMap();

  @override
  _GameMap createState() => _GameMap();
}

class _GameMap extends State<GameMap> with TickerProviderStateMixin  {

  late AnimationController _controller_red;
  late AnimationController _controller_black;
  late AnimationController _controller_white;
  Tween<double> _tween = Tween(begin: 1, end: 3);
  double width_red=1;
  double width_black=1;
  double width_white=1;
  int mapaSelect_red=0;
  bool form_red_v=false;
  late List<List<String>> form_red;
  late List<List<String>> form_black;
  late List<List<String>> form_white;
  int tempo = 0;

  late Timer _timer;
  int _start = 30;
  int totalTime = 30;
  int resp_red = 1;
  int resp_jogada = -1;
  bool acerto = false;
  bool map_red_finalizado= false;
  bool map_black_finalizado= false;
  bool map_white_finalizado= false;
  List<bool> acertos_red = [false,false,false,false,false];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller_red = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _controller_black = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _controller_white = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);

    form_black = [
      ["A) A","B) B","C) C","D) D","E) E"],
      ["A) 2","B) 3","C) 4","5) D","E) 6"],
      ["A) 2A","B) 3A","C) 4A","5) DA","E) 6A"],
      ["A) 1A","B) 2A","C) 3A","5) 4A","E) 5A"],
      ["A) 1A","B) 2A","C) 3A","5) 4A","E) 5A"],
    ];
    form_white = [
      ["A) A","B) B","C) C","D) D","E) E"],
      ["A) 2","B) 3","C) 4","5) D","E) 6"],
      ["A) 2A","B) 3A","C) 4A","5) DA","E) 6A"],
      ["A) 1A","B) 2A","C) 3A","5) 4A","E) 5A"],
      ["A) 1A","B) 2A","C) 3A","5) 4A","E) 5A"],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        alignment: Alignment.topCenter,
        child:
         intro(),
      );
  }

  Widget intro(){
    return
    Stack(
        alignment: Alignment.topCenter,
        children: [

          bg_map(),

          Visibility(visible: (width_red==1) && (width_black==1) && (width_white==1),child:
          Positioned(
              top: 0,
              child:
                 !map_red_finalizado ?
                  Image.asset('lib/assets/images/elementos/arvore_1.png',
                      width: MediaQuery
                      .of(context)
                      .size
                      .width*.5, fit: BoxFit.cover):
                 !map_black_finalizado && map_red_finalizado?
                  Image.asset('lib/assets/images/elementos/arvore_2.png',
                      width: MediaQuery
                          .of(context)
                          .size
                          .width*.5, fit: BoxFit.cover) :

                 Image.asset('lib/assets/images/elementos/arvore_3.png',
                     width: MediaQuery
                         .of(context)
                         .size
                         .width*.5, fit: BoxFit.cover),
              )),

          Visibility(visible: (width_red==1) && (width_black==1) && (width_white==1),child:
          lixos_map_vermelho()),

          Visibility(visible:!map_red_finalizado &&  (width_red==1) && (width_black==1) && (width_white==1),child:
          lixos_map_preto_desativado()),

          Visibility(visible:map_red_finalizado &&  (width_red==1) && (width_black==1) && (width_white==1),child:
          lixos_map_preto_ativado()),

          Visibility(visible: (width_red==1) && (width_black==1) && (width_white==1),child:
          lixos_map_branco_desativado()),

          Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child:
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 mainAxisSize: MainAxisSize.max,
                 children: [

                 GestureDetector(
                     onTap:(){setState(() {
                       print("MAPA VERMELHO");
                       width_red=3;
                       width_black=0.0;
                       width_white=0.0;
                     });},
                     child:
                     AnimatedSize(
                         curve: Curves.easeInOut,
                         duration: const Duration(milliseconds: 500),
                         child:
                     Container(
                    width: width_red==3 ? (MediaQuery.of(context).size.width) :
                    width_black==3 || width_white== 3 ? 0.0 :  MediaQuery.of(context).size.width*.3,
                         height: MediaQuery.of(context).size.height,
                         alignment: Alignment.center,
                         decoration: BoxDecoration(color:Colors.transparent),
                         child:
                         Visibility(child: MapRed((value){

                           if (!value)
                             setState(() {
                               width_red=1;
                               width_black=1.0;
                               width_white=1.0;
                               map_red_finalizado=false;
                          });
                             else
                           setState(() {
                             print("MAPA Finalizado");
                             width_red=1;
                             width_black=1.0;
                             width_white=1.0;
                             map_red_finalizado=true;
                           });
                         }),visible: width_red==3)
                       ,))),


                 GestureDetector(
                      onTap:(){
                        print("MAPA PRETO");
                        print(map_red_finalizado);
                        if (!map_black_finalizado && map_red_finalizado)
                          setState(() {
                            width_red=0;
                            width_black=3;
                            width_white=0;
                          });
                        },
                      child:
                      AnimatedSize(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 500),
                          child:
                         Container(
                             height: MediaQuery.of(context).size.height,
                             width: width_black==3  ? (MediaQuery.of(context).size.width)  :
                               width_red==3 || width_white == 3 ? 0.0 :
                              MediaQuery.of(context).size.width*.3,
                             alignment: Alignment.center,
                             decoration: BoxDecoration(color:Colors.transparent),
                             child:  Visibility(child:
                            MapBlack((value){
                                        if (!value)
                                          setState(() {
                                            width_red=1;
                                            width_black=1.0;
                                            width_white=1.0;
                                            map_black_finalizado=false;
                                          });
                                 else
                                        setState(() {
                                          width_red=1;
                                          width_black=1.0;
                                          width_white=1.0;
                                            map_black_finalizado=true;
                                        });
                                        }),visible: width_black==3)
                         ))),

                 GestureDetector(
                      onTap:(){
                        if (!map_white_finalizado && map_red_finalizado && map_black_finalizado)
                            setState(() {
                              width_red=0;
                              width_black=0;
                              width_white=3;
                            });
                        },
                      child:
                      AnimatedSize(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 500),
                          child:
                       Container(
                              height: MediaQuery.of(context).size.height,
                              width: width_white==3  ? (MediaQuery.of(context).size.width)  :
                              width_black==3 || width_red == 3 ? 0.0 :
                              MediaQuery.of(context).size.width*.3,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color:Colors.transparent),
                         child:
                       Visibility(child: MapWhite((value){
                         if (!value)
                           setState(() {
                             width_red=1;
                             width_black=1.0;
                             width_white=1.0;
                             map_white_finalizado=false;
                           });
                         else
                           setState(() {
                             width_red=1;
                             width_black=1.0;
                             width_white=1.0;
                             map_white_finalizado=true;
                           });
                       }),visible:
                       width_white==3),))),

               ],)
            )
          ]),

    ]);

  }

  Widget bg_map(){

    if (!map_red_finalizado) {
      return
        width_red != 3 ?
        new Image.asset('lib/assets/images/elementos/mapa_vermelho.png',
          width: MediaQuery
              .of(context)
              .size
              .width, fit: BoxFit.cover,) :
        new Image.asset('lib/assets/images/elementos/mangue_01_vermelho.jpg',
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width, fit: BoxFit.cover);
    }else
        if (map_red_finalizado && !map_black_finalizado){
          return
            width_black != 3 ?
            new Image.asset('lib/assets/images/elementos/mapa_completo.png',
              width: MediaQuery
                  .of(context)
                  .size
                  .width, fit: BoxFit.cover,) :
            new Image.asset('lib/assets/images/elementos/mangue_preto.jpg',
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: MediaQuery
                    .of(context)
                    .size
                    .width, fit: BoxFit.cover);
      }else {

   return
       width_white != 3 ?
         new Image.asset('lib/assets/images/elementos/mapa_completo.png',
         width: MediaQuery
             .of(context)
             .size
             .width, fit: BoxFit.cover,) :
       new Image.asset('lib/assets/images/tela_14.png',
       height: MediaQuery
           .of(context)
           .size
           .height,
       width: MediaQuery
           .of(context)
           .size
           .width, fit: BoxFit.cover);
   }}


  Widget lixos_map_vermelho(){
    return
    Container(
       alignment: Alignment.topCenter,
        child:
      Stack(
        alignment: Alignment.topCenter,
        children: [

          Positioned(
              left: 5,
              top: MediaQuery
                  .of(context)
                  .size
                  .height*.3,
              child:
              Container(child:
              Image.asset('lib/assets/images/elementos/lixo_sombrinha.png',
                  width: MediaQuery
                      .of(context)
                      .size
                      .width*.09, fit: BoxFit.cover))
          ),



        Positioned(
          top: MediaQuery
              .of(context)
              .size
              .height*.2,
          left: MediaQuery
              .of(context)
              .size.width*.125,
          child:
          Container(child:
          Image.asset('lib/assets/images/elementos/lixo_cadeira.png',
              width: MediaQuery
                  .of(context)
                  .size
                  .width*.05, fit: BoxFit.cover))
          ),
        Positioned(
          top: MediaQuery
              .of(context)
              .size
              .height*.28,
          left: MediaQuery
              .of(context)
              .size.width*.22,
          child:
          Container(child:
          Image.asset('lib/assets/images/elementos/lixo_garrafa.png',
              width: MediaQuery
                  .of(context)
                  .size
                  .width*.0425, fit: BoxFit.cover))
          ,),
        Positioned(
          top: MediaQuery
              .of(context)
              .size
              .height*.47,
          left: MediaQuery
              .of(context)
              .size.width*.15,
          child:
          Container(child:
          Image.asset('lib/assets/images/elementos/lixo_pneu.png',
              width: MediaQuery
                  .of(context)
                  .size
                  .width*.081, fit: BoxFit.cover))
          ,),
        Positioned(
          top: MediaQuery
              .of(context)
              .size
              .height*.432,
          left: MediaQuery
              .of(context)
              .size.width*.27,
          child:
          Container(child:
          Image.asset('lib/assets/images/elementos/lixo_caixa.png',
              width: MediaQuery
                  .of(context)
                  .size
                  .width*.09, fit: BoxFit.cover))
          ,),

      ],));
  }


  Widget lixos_map_preto_desativado(){
    return Container(
      alignment: Alignment.center,
      child: Stack(children: [

        Positioned(
            left: MediaQuery
                .of(context)
                .size
                .width*.45,
            bottom: MediaQuery
                .of(context)
                .size
                .height*.15,
            child:
            Container(child:
            Image.asset('lib/assets/images/elementos/lixo_somb_bloqueado.png',
                width: MediaQuery
                    .of(context)
                    .size
                    .width*.09, fit: BoxFit.cover))
        ),

        Positioned(
            bottom: MediaQuery
                .of(context)
                .size
                .height*.225,
            left: MediaQuery
                .of(context)
                .size.width*.58,
            child:
            Container(child:
            Image.asset('lib/assets/images/elementos/lixo_cadeira_bloqueada.png',
                width: MediaQuery
                    .of(context)
                    .size
                    .width*.06, fit: BoxFit.cover))
        ),

        Positioned(
          bottom: MediaQuery
              .of(context)
              .size
              .height*.08,
          left: MediaQuery
              .of(context)
              .size.width*.58,
          child:
          Container(child:
          Image.asset('lib/assets/images/elementos/lixo_garrafa_bloqueada.png',
              width: MediaQuery
                  .of(context)
                  .size
                  .width*.0425, fit: BoxFit.cover))
          ,),

        Positioned(
          bottom: MediaQuery
              .of(context)
              .size
              .height*.07,
          left: MediaQuery
              .of(context)
              .size.width*.37,
          child:
          Container(child:
          Image.asset('lib/assets/images/elementos/lixo_pneu_bloqueada.png',
              width: MediaQuery
                  .of(context)
                  .size
                  .width*.081, fit: BoxFit.cover))
          ,),

        Positioned(
          bottom: MediaQuery
              .of(context)
              .size
              .height*.35,
          left: MediaQuery
              .of(context)
              .size.width*.34,
          child:
          Container(child:
          Image.asset('lib/assets/images/elementos/lixo_caixa_bloqueada.png',
              width: MediaQuery
                  .of(context)
                  .size
                  .width*.1, fit: BoxFit.cover))
          ,),

      ],),
    );

  }

  Widget lixos_map_preto_ativado(){
    return Container(
      alignment: Alignment.center,
      child: Stack(children: [

        Positioned(
            left: MediaQuery
                .of(context)
                .size
                .width*.45,
            bottom: MediaQuery
                .of(context)
                .size
                .height*.15,
            child:
            Container(child:
            Image.asset('lib/assets/images/elementos/lixo_sombrinha.png',
                width: MediaQuery
                    .of(context)
                    .size
                    .width*.09, fit: BoxFit.cover))
        ),

        Positioned(
            bottom: MediaQuery
                .of(context)
                .size
                .height*.225,
            left: MediaQuery
                .of(context)
                .size.width*.58,
            child:
            Container(child:
            Image.asset('lib/assets/images/elementos/lixo_cadeira.png',
                width: MediaQuery
                    .of(context)
                    .size
                    .width*.06, fit: BoxFit.cover))
        ),

        Positioned(
          bottom: MediaQuery
              .of(context)
              .size
              .height*.08,
          left: MediaQuery
              .of(context)
              .size.width*.58,
          child:
          Container(child:
          Image.asset('lib/assets/images/elementos/lixo_garrafa.png',
              width: MediaQuery
                  .of(context)
                  .size
                  .width*.0425, fit: BoxFit.cover))
          ,),

        Positioned(
          bottom: MediaQuery
              .of(context)
              .size
              .height*.07,
          left: MediaQuery
              .of(context)
              .size.width*.37,
          child:
          Container(child:
          Image.asset('lib/assets/images/elementos/lixo_pneu.png',
              width: MediaQuery
                  .of(context)
                  .size
                  .width*.081, fit: BoxFit.cover))
          ,),

        Positioned(
          bottom: MediaQuery
              .of(context)
              .size
              .height*.35,
          left: MediaQuery
              .of(context)
              .size.width*.34,
          child:
          Container(child:
          Image.asset('lib/assets/images/elementos/lixo_caixa.png',
              width: MediaQuery
                  .of(context)
                  .size
                  .width*.1, fit: BoxFit.cover))
          ,),

      ],),
    );

  }


  Widget lixos_map_branco_desativado(){
    return
      Container(
          alignment: Alignment.topCenter,
          child:
          Stack(
            alignment: Alignment.topCenter,
            children: [

              Positioned(
                  right: 5,
                  top: MediaQuery
                      .of(context)
                      .size
                      .height*.3,
                  child:
                  Container(child:
                  Image.asset('lib/assets/images/elementos/lixo_somb_bloqueado.png',
                      width: MediaQuery
                          .of(context)
                          .size
                          .width*.09, fit: BoxFit.cover))
              ),
              Positioned(
                  top: MediaQuery
                      .of(context)
                      .size
                      .height*.2,
                  right: MediaQuery
                      .of(context)
                      .size.width*.125,
                  child:
                  Container(child:
                  Image.asset('lib/assets/images/elementos/lixo_cadeira_bloqueada.png',
                      width: MediaQuery
                          .of(context)
                          .size
                          .width*.05, fit: BoxFit.cover))
              ),
              Positioned(
                top: MediaQuery
                    .of(context)
                    .size
                    .height*.325,
                right: MediaQuery
                    .of(context)
                    .size.width*.18,
                child:
                Container(child:
                Image.asset('lib/assets/images/elementos/lixo_garrafa_bloqueada.png',
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*.0425, fit: BoxFit.cover))
                ,),
              Positioned(
                top: MediaQuery
                    .of(context)
                    .size
                    .height*.47,
                right: MediaQuery
                    .of(context)
                    .size.width*.25,
                child:
                Container(child:
                Image.asset('lib/assets/images/elementos/lixo_pneu_bloqueada.png',
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*.09, fit: BoxFit.cover))
                ,),
              Positioned(
                top: MediaQuery
                    .of(context)
                    .size
                    .height*.32,
                right: MediaQuery
                    .of(context)
                    .size.width*.27,
                child:
                Container(child:
                Image.asset('lib/assets/images/elementos/lixo_caixa_bloqueada.png',
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*.09, fit: BoxFit.cover))
                ,),

            ],));
  }


}

