
import 'dart:async';
import 'dart:ui';

import 'package:animated_rotation/animated_rotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mangues_da_amazonia/app/LocalDB/Repository.dart';
import 'package:mangues_da_amazonia/app/Presenter/GameMap/GameMap.dart';
import 'package:mobx/mobx.dart';

import 'Pergunta.dart';


class MapWhite extends StatefulWidget {
  Function finalizado;
  MapWhite(this.finalizado);

  @override
  _MapWhite createState() => _MapWhite(this.finalizado);
}

class _MapWhite extends State<MapWhite> with SingleTickerProviderStateMixin {

  Function finalizado;
  _MapWhite(this.finalizado);


  late AnimationController _controller;
  Tween<double> _tween = Tween(begin: 0.9, end: 1.5);
  bool form_white_v=false;
  int mapaSelect_white=0;
  bool acerto = false;
  bool erro = false;
  bool finalizado_ = false;
  bool visible_itensmap = true;
  bool tempo_finalizado = false;
  late Timer _timer;
  int _start = 30;
  int totalTime = 30;
  int resp_white = 1;
  int resp_jogada = -1;

  bool btn_1 = true;
  bool btn_2 = true;
  bool btn_3 = true;
  bool btn_4 = true;
  bool btn_5 = true;

  int totalPerguntas_respondidas = 0;

  Repository repository = Repository();

  dynamic form;

  late List<List<String>> form_white = [
      ["A) AAAAAAAA AAAAA","B) B","C) C","D) D","E) E"],
      ["A) 2","B) 3","C) 4","5) D","E) 6"],
      ["A) 2A","B) 3A","C) 4A","5) DA","E) 6A"],
      ["A) 1A","B) 2A","C) 3A","5) 4A","E) 5A"],
      ["A) 1A","B) 2A","C) 3A","5) 4A","E) 5A"],
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
    _controller.repeat(reverse: true);

  }

  @override
  Widget build(BuildContext context) {
    return
      Stack(
          alignment: Alignment.center,
          children:[

            Positioned(top: 0,child:
            Text( totalPerguntas_respondidas.toString()+" de 5"
              ,style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),)),

            Visibility(
                visible: form_white_v,
                child:Form_white()),

            Visibility(visible: visible_itensmap,child:
            mapPerguntas()),

            ClipRect(
                child: new BackdropFilter(
                    filter: new ImageFilter
                        .blur(sigmaX:(acerto || erro) ? 4.0 : 0.1, sigmaY: (acerto || erro ) ? 4.0 : 0.0),
                    child:Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ))),

            Visibility(visible: acerto,child:
            popAcerto()),

            Visibility(visible: erro,child:
            popErro()),

            Visibility(visible: finalizado_,child:
            popFinalMap()),

          ]);

  }

  Widget mapPerguntas(){
    return
      Stack(
          children:[

            Positioned(
                top: MediaQuery.of(context).size.height*.15,
                left: MediaQuery.of(context).size.width*.3,
                child:
                BotaoPergunta(url: 'lib/assets/images/elementos/lixo_sombrinha.png',
                    ativo: btn_1,click: (){
                      setState(() {

                        visible_itensmap=false;
                        btn_1=false;
                        startTimer();
                      });
                    })),

            Positioned(
                top: MediaQuery.of(context).size.height*.4,
                left: MediaQuery.of(context).size.width*.15,
                child:
                BotaoPergunta(url:'lib/assets/images/elementos/lixo_cadeira.png',
                    ativo:btn_2,click: (){
                      setState(() {

                        visible_itensmap=false;
                        btn_2=false;
                        startTimer();
                      });
                    })),

            Positioned(
                bottom: MediaQuery.of(context).size.height*.0,
                right: MediaQuery.of(context).size.width*.15,
                child:
                BotaoPergunta(url:'lib/assets/images/elementos/lixo_garrafa.png',
                    ativo:btn_3,click: (){
                      setState(() {

                        visible_itensmap=false;
                        startTimer();
                        btn_3=false;
                      });
                    })),


            Positioned(
                top: MediaQuery.of(context).size.height*.2,
                right: MediaQuery.of(context).size.width*.15,
                child:
                BotaoPergunta(url:'lib/assets/images/elementos/lixo_pneu.png',
                    ativo:btn_4,click: (){
                      setState(() {

                        visible_itensmap=false;
                        btn_4=false;

                        startTimer();
                      });
                    })),

            Positioned(
                top: MediaQuery.of(context).size.height*.225,
                right: MediaQuery.of(context).size.width*.34,
                child:
                BotaoPergunta(url:'lib/assets/images/elementos/lixo_caixa.png',
                    ativo:btn_5,click: (){
                      setState(() {

                        visible_itensmap=false;
                        btn_5=false;

                        startTimer();

                      });
                    })),

          ]);

  }

  Widget Form_white(){
    return
      ConstrainedBox(
          constraints:BoxConstraints(
            minWidth:    MediaQuery.of(context).size.width*.2,
            maxWidth:
            MediaQuery.of(context).size.width*.3,),
          child:
          Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(color:Colors.white,
                  boxShadow: [BoxShadow(color:Colors.black54)],
                  borderRadius: BorderRadius.circular(20)),
              child:
              FittedBox(
                  fit: BoxFit.fitHeight,
                  child:
              Column(children: [
                Container(
                  margin:EdgeInsets.all(15),
                  padding: EdgeInsets.all(15),child: Text("Titulo",style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),),),

                GestureDetector(
                    onTap: (){
                      setState(() {
                        resp_jogada=0;
                        if (resp_jogada == resp_white){
                          acerto=true;
                          _timer.cancel();
                        }else{
                        _timer.cancel();
                        erro=true;}
                      });
                    },
                    child:
                    Container(
                      width: MediaQuery.of(context).size.width*.25,
                      margin:EdgeInsets.all(15),
                      padding: EdgeInsets.all(15), decoration: BoxDecoration(color:resp_jogada==0 ?
                    Colors.black12 : Colors.white,
                        boxShadow: [BoxShadow(color:Colors.black54)],
                        borderRadius: BorderRadius.circular(20)),
                      child: Text( form_white[mapaSelect_white][0],style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),),)),

                GestureDetector(
                    onTap: (){
                      setState(() {
                        resp_jogada=1;
                        if (resp_jogada == resp_white){
                          acerto=true;
                          _timer.cancel();
                        }else{
                          _timer.cancel();
                          erro=true;}
                      });
                    },
                    child:
                    Container(            width: MediaQuery.of(context).size.width*.25,
                      margin:EdgeInsets.all(15),
                      padding: EdgeInsets.all(15), decoration: BoxDecoration(color:resp_jogada==1 ?
                      Colors.black12 : Colors.white,
                          boxShadow: [BoxShadow(color:Colors.black54)],
                          borderRadius: BorderRadius.circular(20)),
                      child: Text( form_white[mapaSelect_white][1]
                        ,style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),),)),

                GestureDetector(
                    onTap: (){
                      setState(() {
                        resp_jogada=2;
                        if (resp_jogada == resp_white){
                          acerto=true;
                          _timer.cancel();
                        }else{
                          _timer.cancel();
                          erro=true;}
                      });
                    },
                    child:
                    Container(
                      width: MediaQuery.of(context).size.width*.25,
                      margin:EdgeInsets.all(15),
                      padding: EdgeInsets.all(15), decoration: BoxDecoration(color:resp_jogada==2 ?
                    Colors.black12 : Colors.white,
                        boxShadow: [BoxShadow(color:Colors.black54)],
                        borderRadius: BorderRadius.circular(20)),
                      child: Text( form_white[mapaSelect_white][2],style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),),)),

                GestureDetector(
                    onTap: (){
                      setState(() {
                        resp_jogada=3;
                        if (resp_jogada == resp_white){
                          acerto=true;
                          _timer.cancel();
                        }else{
                          _timer.cancel();
                          erro=true;}

                      });
                    },
                    child:
                    Container(            width: MediaQuery.of(context).size.width*.25,
                      margin:EdgeInsets.all(15),
                      padding: EdgeInsets.all(15), decoration: BoxDecoration(color:resp_jogada==3 ? Colors.black12 : Colors.white,
                          boxShadow: [BoxShadow(color:Colors.black54)],
                          borderRadius: BorderRadius.circular(20)),
                      child: Text( form_white[mapaSelect_white][3],style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),),)),

                GestureDetector(
                    onTap: (){
                      setState(() {
                        resp_jogada=4;
                        if (resp_jogada == resp_white){
                          acerto=true;
                          _timer.cancel();
                        }else{
                          _timer.cancel();
                          erro=true;}

                      });
                    },
                    child:
                    Container(            width: MediaQuery.of(context).size.width*.25,
                      margin:EdgeInsets.all(15),
                      padding: EdgeInsets.all(15), decoration: BoxDecoration(color:resp_jogada==4 ?  Colors.black12 : Colors.white,
                          boxShadow: [BoxShadow(color:Colors.black54)],
                          borderRadius: BorderRadius.circular(20)),
                      child: Text( form_white[mapaSelect_white][4],style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),),)),


                Container(
                  width: MediaQuery.of(context).size.width*.25,
                  margin:EdgeInsets.all(15),
                  padding: EdgeInsets.all(15), decoration: BoxDecoration(color:Colors.white,
                    boxShadow: [BoxShadow(color:Colors.black54)],
                    borderRadius: BorderRadius.circular(20)),
                  child: Text("Tempo: "+_start.toString(),style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),),),

                Container(
                    width: MediaQuery.of(context).size.width*.25,
                    margin:EdgeInsets.all(15),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(color:Colors.white),
                    child:
                    Icon(Icons.timelapse,size: 32,color: _start > 20 ?
                    Colors.green : _start < 6 ? Colors.red : Colors.yellow))


              ]))
          ));
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            tempo_finalizado=true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Widget popAcerto(){
    return
      Container(
          width: 260,
          height: 230,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.white,
              boxShadow: [BoxShadow(color:Colors.black26,blurRadius: 3,spreadRadius: 3)]),
          child:
          Column(children: [
            Container(
                margin: EdgeInsets.all(15),
                child:
                Text("ACERTO",style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),)),
            Container(
                margin: EdgeInsets.all(15),
                child:
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star,color: _start >= 1 ? Colors.yellow : Colors.grey),
                      Icon(Icons.star,color: _start >= 15 ? Colors.yellow : Colors.grey),
                      Icon(Icons.star,color: _start >= 25 ? Colors.yellow : Colors.grey),
                    ])),
            Container(
                margin: EdgeInsets.all(5),
                child:
                Text("Tempo: "+(totalTime-_start).toString()+"s",style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),)),

            Container(
                margin: EdgeInsets.all(15),
                child:
                OutlinedButton(onPressed: (){
                  setState((){
                    form_white_v=false;
                    acerto=false;
                    mapaSelect_white=0;
                    resp_jogada=-1;
                    _start=30;
                    visible_itensmap=true;
                    setPerguntaRespondida();
                  });
                }, child: Text("Continuar",style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),)))
          ],)
      );

  }

  Widget popErro(){
    return
      Container(
          width: 260,
          height: 230,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.white,
              boxShadow: [BoxShadow(color:Colors.black26,blurRadius: 3,spreadRadius: 3)]),
          child:
          Column(children: [
            Container(
                margin: EdgeInsets.all(15),
                child:
                Text("ERROU",style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),)),

            Container(
                margin: EdgeInsets.all(15),
                child:
                OutlinedButton(onPressed: (){
                  setState((){
                    form_white_v=false;
                    acerto=false;
                    erro=false;
                    mapaSelect_white=0;
                    resp_jogada=-1;
                    _start=30;
                    visible_itensmap=true;
                    setPerguntaRespondida();
                  });
                }, child: Text("Continuar",style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),)))
          ],)
      );

  }

  Widget popFinalMap(){
    return
      Container(
          width: 260,
          height: 230,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.white,
              boxShadow: [BoxShadow(color:Colors.black26,blurRadius: 3,spreadRadius: 3)]),
          child:
          Column(children: [
            Container(
                margin: EdgeInsets.all(15),
                child:
                Text("MAPA VERMELHO FINALIZADO",style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),)),

            Container(
                margin: EdgeInsets.all(15),
                child:
                OutlinedButton(onPressed: (){
                  setState((){
                    finalizado();
                  });
                }, child: Text("Continuar",style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),)))
          ],)
      );

  }

  setPerguntaRespondida(){
    totalPerguntas_respondidas++;
    if (totalPerguntas_respondidas==5){
      setState(() {
        finalizado_=true;
      });
    }
  }

  setPontos(){
    repository.setPontos(2);
  }

}