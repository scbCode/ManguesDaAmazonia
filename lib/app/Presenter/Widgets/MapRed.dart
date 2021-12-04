
import 'dart:async';
import 'dart:ui';

import 'package:animated_rotation/animated_rotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mangues_da_amazonia/app/LocalDB/Repository.dart';
import 'package:mangues_da_amazonia/app/Presenter/GameMap/GameMap.dart';
import 'package:mobx/mobx.dart';

import 'Pergunta.dart';
import 'package:url_launcher/url_launcher.dart';

class MapRed extends StatefulWidget {
  Function finalizado;
  MapRed(this.finalizado);

  @override
  _MapRed createState() => _MapRed(this.finalizado);
}

class _MapRed extends State<MapRed> with SingleTickerProviderStateMixin {

  Function finalizado;

  _MapRed(this.finalizado);

  late AnimationController _controller;
  Tween<double> _tween = Tween(begin: 0.9, end: 1.5);
  bool form_red_v=false;
  int mapaSelect_red=0;
  bool acerto = false;
  bool anim_carangueijo = true;
  bool erro = false;
  bool gameOver = false;
  bool finalizado_ = false;
  bool visible_itensmap = true;
  bool tempo_finalizado = false;
  late Timer _timer;
  int _start = 30;

  late Timer _timer_carang;
  int _start_carang = 20;
  int totalTime = 30;
  int resp_red = 1;
  int resp_jogada = -1;

  bool btn_1 = true;
  bool btn_2 = true;
  bool btn_3 = true;
  bool btn_4 = true;
  bool btn_5 = true;
  int vidas = 3;
  String textCarang = "A nossa casa tá uma zona! Mas tu podes "
      "ajudar a gente a colocar ordem no lugar.";

  int totalPerguntas_respondidas = 0;

  Repository repository = Repository();

  dynamic form;

  late Image img_bg;

  final img_bg_form = Image.asset(
      "lib/assets/images/elementos/fundo_mangue_vermelho.jpg",
      fit: BoxFit.cover);

  late List<List<String>> form_red = [
      ["A) AAAAAAAA AAAAA","B) B","C) C","D) D","E) E"],
      ["A) 2","B) 3","C) 4","5) D","E) 6"],
      ["A) 2A","B) 3A","C) 4A","5) DA","E) 6A"],
      ["A) 1A","B) 2A","C) 3A","5) 4A","E) 5A"],
      ["A) 1A","B) 2A","C) 3A","5) 4A","E) 5A"],
  ];

  @override
  void initState() {
    super.initState();

    // TODO: implement initState
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
    _controller.repeat(reverse: true);
    startTimerAnim();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(img_bg_form.image, context);
  }


  @override
  Widget build(BuildContext context) {
    return
      Stack(
          alignment: Alignment.center,
          children:[

       Container(
            height: MediaQuery.of(context).size.height,
            width:MediaQuery.of(context).size.width,
            child:
          Visibility(
                visible: form_red_v,
                child:Form_red())),

            Visibility(visible: visible_itensmap,child:
            mapPerguntas()),

            Positioned(
                bottom: MediaQuery.of(context).size.height*.25,
                right: MediaQuery.of(context).size.width*.45,
                child:
                Visibility(visible: anim_carangueijo,child:
                Container(child:
                Image.asset('lib/assets/images/elementos/balao_empty.png',
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*.34, fit: BoxFit.cover)))),
                Positioned(
                    top: MediaQuery.of(context).size.height*.4,
                    left: MediaQuery.of(context).size.width*.225,
                    child:
                    Visibility(visible: anim_carangueijo,child:
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery
                    .of(context)
                    .size
                    .width*.3,
                  child:Text(textCarang,style:
                  TextStyle(color:  Colors.black,fontSize: 16),))
            )),

            Positioned(
                bottom: MediaQuery.of(context).size.height*.08,
                right: MediaQuery.of(context).size.width*.25,
              child:
              Visibility(visible: anim_carangueijo,child:
               Container(child:
                Image.asset('lib/assets/images/elementos/carangueijo.png',
                    width: MediaQuery
                        .of(context)
                    .size
                    .width*.20, fit: BoxFit.cover)))),


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

            Visibility(visible: gameOver,child:
            GameOver()),

            Visibility(visible: finalizado_,child:
            popFinalMap()),

          ]);

  }

  Widget mapPerguntas(){
    return
       Stack(
              children:[

                Positioned(
                    bottom: MediaQuery.of(context).size.height*.1,
                    left: MediaQuery.of(context).size.width*.05,
                    child:
                BotaoPergunta(url: 'lib/assets/images/elementos/lixo_sombrinha.png',
                    ativo: btn_1,click: (){
                    setState(() {
                      mapaSelect_red=0;
                      resp_red=0;
                      form_red_v=true;
                      visible_itensmap=false;
                      btn_1=false;
                      startTimer();
                    });
                })),

                Positioned(
                    top: MediaQuery.of(context).size.height*.1,
                    left: MediaQuery.of(context).size.width*.25,
                child:
                BotaoPergunta(url:'lib/assets/images/elementos/lixo_cadeira.png',
                    ativo:btn_2,click: (){
                  setState(() {
                    mapaSelect_red=1;
                    form_red_v=true;
                    resp_red=0;
                    visible_itensmap=false;
                    btn_2=false;
                    startTimer();
                  });
                })),

            Positioned(
                top: MediaQuery.of(context).size.height*.1,
                right: MediaQuery.of(context).size.width*.35,
            child:
          BotaoPergunta(url:'lib/assets/images/elementos/lixo_garrafa.png',
              ativo:btn_3,click: (){
            setState(() {
              mapaSelect_red=2;
              form_red_v=true;
              visible_itensmap=false;
              startTimer();
              btn_3=false;
              resp_red=0;
            });
          })),


         Positioned(
               bottom: MediaQuery.of(context).size.height*.05,
               right: MediaQuery.of(context).size.width*.15,
               child:
            BotaoPergunta(url:'lib/assets/images/elementos/lixo_pneu.png',
                ativo:btn_4,click: (){
                  setState(() {
                    mapaSelect_red=3;
                    resp_red=0;
                    form_red_v=true;
                    visible_itensmap=false;
                    btn_4=false;
                    startTimer();
                  });
                })),

             Positioned(
                    top: MediaQuery.of(context).size.height*.23,
                    right: MediaQuery.of(context).size.width*.14,
                child:
                BotaoPergunta(url:'lib/assets/images/elementos/lixo_caixa.png',
                    ativo:btn_5,click: (){
                  setState(() {
                    mapaSelect_red=4;
                    resp_red=0;
                    form_red_v=true;
                    visible_itensmap=false;
                    btn_5=false;

                    startTimer();

                  });
                })),

              ]);
  }

  Widget Form_red(){
    return
      Container(
          height: MediaQuery.of(context).size.height,
          width:MediaQuery.of(context).size.width,
          child: 
      Stack(children:[

        Image.asset('lib/assets/images/elementos/fundo_mangue_vermelho.jpg',
            width:MediaQuery.of(context).size.width,
            height:MediaQuery.of(context).size.height,
            fit: BoxFit.cover),

        Positioned(
            bottom: 3,
            right: MediaQuery.of(context).size.width*.02,
            child:
            Visibility(child:
            Container(child:
            Image.asset('lib/assets/images/elementos/garca_questoes.png',
                width: MediaQuery
                    .of(context)
                    .size
                    .width*.25, fit: BoxFit.cover)))),

        Positioned(
            bottom:30,
            left: 50,
            child:
        Container(
            margin: EdgeInsets.all(10),
            height:MediaQuery.of(context).size.height*.6,
            decoration: BoxDecoration(color:Colors.white,
                  boxShadow: [BoxShadow(color:Colors.black54)],
                  borderRadius: BorderRadius.circular(20)),
              child:
            FittedBox(
                 child:
              Column(children: [
                // Container(
                //   margin:EdgeInsets.all(15),
                //   padding: EdgeInsets.all(15),child: Text("Titulo",style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),),),

                GestureDetector(
                    onTap: (){
                      setState(() {
                        resp_jogada=0;
                        if (resp_jogada == resp_red){
                          acerto=true;
                          _timer.cancel();
                        }else{

                             vidas--;


                            erro=true;

                          _timer.cancel();
                        }
                      });
                    },
                    child:
                    Container(
                      width: MediaQuery.of(context).size.width*.7,
                      margin:EdgeInsets.all(15),
                      decoration: BoxDecoration(color:resp_jogada==0 ?
                    Colors.white : Colors.amberAccent,
                        boxShadow: [BoxShadow(color:Colors.black54)],
                        border:  Border.all(color: Colors.brown,width: 4),
                        borderRadius: BorderRadius.circular(10)),
                      child: Text( form_red[mapaSelect_red][0],style: TextStyle(color:Colors.brown,fontSize: 16,fontFamily: 'MochiyPopPOne'),),)),

                GestureDetector(
                    onTap: (){
                      setState(() {
                        resp_jogada=1;
                        if (resp_jogada == resp_red){
                          acerto=true;
                          _timer.cancel();
                        }else{

                            vidas--;


                            erro=true;

                          _timer.cancel();
                        }
                      });
                    },
                    child:
                    Container(            width: MediaQuery.of(context).size.width*.7,
                      margin:EdgeInsets.all(15),
                      padding: EdgeInsets.all(15), decoration: BoxDecoration(color:resp_jogada==1 ?
                      Colors.black12 : Colors.white,
                          boxShadow: [BoxShadow(color:Colors.black54)],
                          borderRadius: BorderRadius.circular(20)),
                      child: Text( form_red[mapaSelect_red][1]
                        ,style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),),)),

                GestureDetector(
                    onTap: (){
                      setState(() {
                        resp_jogada=2;
                        if (resp_jogada == resp_red){
                          acerto=true;
                          _timer.cancel();
                        }else{


                            vidas--;


                            erro=true;

                          _timer.cancel();

                        }
                      });
                    },
                    child:
                    Container(
                      width: MediaQuery.of(context).size.width*.7,
                      margin:EdgeInsets.all(15),
                      padding: EdgeInsets.all(15), decoration: BoxDecoration(color:resp_jogada==2 ?
                    Colors.black12 : Colors.white,
                        boxShadow: [BoxShadow(color:Colors.black54)],
                        borderRadius: BorderRadius.circular(20)),
                      child: Text( form_red[mapaSelect_red][2],style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),),)),

                GestureDetector(
                    onTap: (){
                      setState(() {
                        resp_jogada=3;
                        if (resp_jogada == resp_red){
                          acerto=true;
                          _timer.cancel();
                        }else{

                            vidas--;

                            erro=true;

                          _timer.cancel();
                        }

                      });
                    },
                    child:
                    Container(            width: MediaQuery.of(context).size.width*.7,
                      margin:EdgeInsets.all(15),
                      padding: EdgeInsets.all(15), decoration: BoxDecoration(color:resp_jogada==3 ? Colors.black12 : Colors.white,
                          boxShadow: [BoxShadow(color:Colors.black54)],
                          borderRadius: BorderRadius.circular(20)),
                      child: Text( form_red[mapaSelect_red][3],style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),),)),

                GestureDetector(
                    onTap: (){
                      setState(() {
                        resp_jogada=4;
                        if (resp_jogada == resp_red){
                          acerto=true;
                          _timer.cancel();
                        }else{

                            vidas--;

                            erro=true;

                          _timer.cancel();
                        }

                      });
                    },
                    child:
                    Container(            width: MediaQuery.of(context).size.width*.7,
                      margin:EdgeInsets.all(15),
                      padding: EdgeInsets.all(15), decoration: BoxDecoration(color:resp_jogada==4 ?  Colors.black12 : Colors.white,
                          boxShadow: [BoxShadow(color:Colors.black54)],
                          borderRadius: BorderRadius.circular(20)),
                      child: Text( form_red[mapaSelect_red][4],style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),),)),

                Container(
                  width: MediaQuery.of(context).size.width*.7,
                  margin:EdgeInsets.all(15),
                  padding: EdgeInsets.all(15), decoration: BoxDecoration(color:Colors.white,
                    boxShadow: [BoxShadow(color:Colors.black54)],
                    borderRadius: BorderRadius.circular(20)),
                  child: Text("Tempo: "+_start.toString(),style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),),),

                Container(
                    width: MediaQuery.of(context).size.width*.7,
                    margin:EdgeInsets.all(15),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(color:Colors.white),
                    child:
                    Icon(Icons.timelapse,size: 32,color: _start > 20 ?
                    Colors.green : _start < 6 ? Colors.red : Colors.yellow))


              ]))
          ))


      ]))
    ;
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

  void startTimerAnim() {
    const oneSec = const Duration(seconds: 1);
    _timer_carang = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start_carang == 0) {
          setState(() {
            timer.cancel();
            anim_carangueijo=false;
          });
        } else {
          setState(() {

            _start_carang--;

            if (_start_carang == 15)
              textCarang = 'Basta tu tocar em um dos lixos que uma caixa de pergunta vai se abrir.';

            if (_start_carang == 7)
              textCarang = 'Basta escolher a pergunta certa e PUFF! Magicamente o lixo vai sumir.';

            if (_start_carang == 3)
              textCarang = 'Boa sorte!';

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
                    form_red_v=false;
                    acerto=false;
                    mapaSelect_red=0;
                    resp_jogada=-1;
                    _start=30;
                    visible_itensmap=true;
                    setPerguntaRespondida();
                  });
                }, child: Text("Continuar",style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),)))
          ],)
      );

  }

  Widget GameOver(){
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
                Text("Suas vidas acabaram",style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),)),

            Container(
                margin: EdgeInsets.all(15),
                child:
                OutlinedButton(onPressed: (){
                  setState((){
                    finalizado(false);

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
                    if (vidas==0)
                      gameOver=true;
                    else {
                      form_red_v = false;
                      acerto = false;
                      erro = false;
                      mapaSelect_red = 0;
                      resp_jogada = -1;
                      _start = 30;
                      visible_itensmap = true;
                      setPerguntaRespondida();
                    }
                  });
                }, child: Text("Continuar",style: TextStyle(color:Colors.black,fontSize: 16,fontFamily: 'MochiyPopPOne'),)))
          ],)
      );

  }

  Widget popFinalMap(){
    return
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.white,
              boxShadow: [BoxShadow(color:Colors.black26,blurRadius: 3,spreadRadius: 3)]),
          child:
          Stack(children: [

            img_bg_form,

            Positioned(top:MediaQuery.of(context).size.height*.01,right:5,child:
            Container(
                margin: EdgeInsets.all(15),
                child:
                OutlinedButton(onPressed: (){
                  setState((){
                    launch("https://youtu.be/qOODbkMOjKQ?t=1");
                  });
                }, child: Container(height:MediaQuery.of(context).size.height*.25 ,
                  width:MediaQuery.of(context).size.width*.2,color:Colors.white.withAlpha(200) ,)))),
            Positioned(
                bottom:0,
                right:MediaQuery.of(context).size.width*.35,child:
            Container(
                margin: EdgeInsets.all(15),
                child:
                OutlinedButton(onPressed: (){
                  setState((){
                    finalizado(true);
                  });
                }, child: Container(height:MediaQuery.of(context).size.height*.25 ,
                  width:MediaQuery.of(context).size.width*.2,color:Colors.white.withAlpha(200) ,))))
          ],)
      );

  }

  setPerguntaRespondida(){
    totalPerguntas_respondidas++;
    if (totalPerguntas_respondidas==5){
      setState(() {
        if (vidas>0){
          finalizado_=true;
        }
      });
    }
  }

  setPontos(){
    repository.setPontos(2);
  }

}