
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
        alignment: Alignment.center,
        child:
         intro(),
      );
  }

  Widget intro(){
    return
    Stack(
        alignment: Alignment.center,
        children: [

          Container(
            child: width_red !=3 ?
               new Image.asset('lib/assets/images/tela_06.png',
                 width:MediaQuery.of(context).size.width,fit: BoxFit.cover,) :
               new Image.asset('lib/assets/images/tela_05.png',
                 height:MediaQuery.of(context).size.height,
                 width:MediaQuery.of(context).size.width,fit: BoxFit.cover) ,
          ),

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
                         width: width_red==3  ? (MediaQuery.of(context).size.width)  : MediaQuery.of(context).size.width*.27,
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
                             width_red=1;
                             width_black=1.0;
                             width_white=1.0;
                             map_red_finalizado=true;
                           });
                         }),visible: width_red==3)
                       ,))),

                 GestureDetector(
                      onTap:(){setState(() {
                        width_red=0;
                        width_black=3;
                        width_white=0;

                      });},
                      child:
                      AnimatedSize(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 500),
                          child:
                         Container(
                             width: (MediaQuery.of(context).size.width*.27)*width_black,
                             alignment: Alignment.center,
                           decoration: BoxDecoration(color:Colors.transparent),
                           padding: EdgeInsets.all(12),
                            child: Visibility(child: MapBlack((){
                              setState(() {
                                width_red = 1.0;
                                width_black = 1.0;
                                width_white = 1.0;
                                map_black_finalizado = true;
                              });
                            }),visible:
                            width_black==3),
                         ))),

                 GestureDetector(
                      onTap:(){setState(() {
                        width_red=0;
                        width_black=0;
                        width_white=3;

                      });},
                      child:
                      AnimatedSize(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 500),
                          child:
                       Container(
                           width: (MediaQuery.of(context).size.width*.27)*width_white,
                           alignment: Alignment.center,
                          decoration: BoxDecoration(color:Colors.transparent),
                          padding: EdgeInsets.all(12),child:
                       Visibility(child: MapWhite((){
                       setState(() {
                         width_red = 1.0;
                         width_black = 1.0;
                         width_white = 1.0;
                         map_white_finalizado = true;
                       });
                       }),visible:
                       width_white==3),))),

               ],)
            )
          ]),

    ]);

  }


}