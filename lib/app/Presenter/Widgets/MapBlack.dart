
import 'dart:async';
import 'dart:ui';

import 'package:animated_rotation/animated_rotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mangues_da_amazonia/app/Engine/Game.dart';
import 'package:mangues_da_amazonia/app/LocalDB/Repository.dart';
import 'package:mangues_da_amazonia/app/Presenter/GameMap/GameMap.dart';
import 'package:mobx/mobx.dart';

import 'Pergunta.dart';
import 'package:url_launcher/url_launcher.dart';

import 'final_preto.dart';

class MapBlack extends StatefulWidget {
  Function finalizado;
  MapBlack(this.finalizado);

  @override
  _MapBlack createState() => _MapBlack(this.finalizado);
}

class _MapBlack extends State<MapBlack> with SingleTickerProviderStateMixin {

  Function finalizado;

  _MapBlack(this.finalizado);

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
  int _start_carang = 14;
  int totalTime = 30;
  int resp_red = 1;
  int resp_jogada = -1;
  Game game = Game();

  bool btn_1 = true;
  bool btn_2 = true;
  bool btn_3 = true;
  bool btn_4 = true;
  bool btn_5 = true;
  int vidas = 3;
  String textCarang = "Estou com um baita bloqueio criativo! Não consigo desenhar nada.";

  int totalPerguntas_respondidas = 0;

  Repository repository = Repository();

  dynamic form;

  late Image img_bg;

  final img_bg_form = Image.asset(
      "lib/assets/images/elementos/fundo_mangue_vermelho.jpg",
      fit: BoxFit.cover);

  List<int> resposta_certa=[2,1,1,3,0];

  late List<List<String>> form_red = [];

  double w_alt = 0.0;
  Image image_a_normal = Image.asset("lib/assets/images/elementos/a_alternativa_normal.png");
  Image image_a_certa = Image.asset("lib/assets/images/elementos/a_alternativa_certa.png");
  @override
  void initState() {
    super.initState();

    // TODO: implement initState
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
    _controller.repeat(reverse: true);
    startTimerAnim();
    form_red.addAll(game.respostas[1]);
    mapaSelect_red = resposta_certa[0];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(img_bg_form.image, context);
    w_alt = MediaQuery.of(context).size.width*.55;
    precacheImage(image_a_normal.image,context);
    precacheImage(image_a_certa.image,context);
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

            Visibility(visible: visible_itensmap && !anim_carangueijo,child:
            mapPerguntas()),

            Positioned(
                bottom: MediaQuery.of(context).size.height*.25,
                right: MediaQuery.of(context).size.width*.4325,
                child:
                Visibility(visible: anim_carangueijo,child:
                Container(child:
                Image.asset('lib/assets/images/elementos/caixa_dialogo.png',
                    height: MediaQuery.of(context).size.height*.4,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*.34, fit: BoxFit.contain)))),

            Positioned(
                right: MediaQuery.of(context).size.width*.425,
                bottom: MediaQuery.of(context).size.height*.26,
                child:
                Visibility(visible: anim_carangueijo,child:
                Container(
                    height: MediaQuery.of(context).size.height*.27,
                    width: MediaQuery.of(context).size.width*.3,
                    padding: EdgeInsets.fromLTRB(0, 0, 35, 0),
                    child:Text(textCarang, textAlign: TextAlign.start,style:
                    TextStyle(fontFamily: "MochiyPopPOne",color:  Colors.black,fontSize: MediaQuery.of(context).size.width*.016),))
                )),

            Positioned(
                top: MediaQuery.of(context).size.height*.45,
                right: MediaQuery.of(context).size.width*.23,
                child:
                Visibility(visible: anim_carangueijo,child:
                Container(child:
                Image.asset('lib/assets/images/elementos/mao_pelada.png',
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*.30, fit: BoxFit.cover)))),



            Visibility(visible: acerto,child:
            popAcerto()),

            Visibility(visible: erro,child:
            popErro()),

            Visibility(visible: vidas==0,child:
            GameOver()),

            Visibility(visible: finalizado_,child:
            popFinalMap()),

            Positioned(
                top: 0,
                right: MediaQuery.of(context).size.width*.4,
                child:
                Visibility(visible: !form_red_v && !finalizado_ ,child:
                Container(child:
                Image.asset('lib/assets/images/elementos/placa_mangue_preto_map.png',
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*.25, fit: BoxFit.cover)))),


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
                        resp_red=resposta_certa[mapaSelect_red];
                        form_red_v=true;
                        visible_itensmap=false;
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
                        resp_red=resposta_certa[mapaSelect_red];
                        visible_itensmap=false;
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
                        resp_red=resposta_certa[mapaSelect_red];

                        visible_itensmap=false;
                        startTimer();

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
                        resp_red=resposta_certa[mapaSelect_red];

                        form_red_v=true;
                        visible_itensmap=false;
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
                        resp_red=resposta_certa[mapaSelect_red];

                        form_red_v=true;
                        visible_itensmap=false;

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

            Image.asset('lib/assets/images/elementos/fundo_mangue_preto.jpg',
                width:MediaQuery.of(context).size.width,
                height:MediaQuery.of(context).size.height,
                fit: BoxFit.cover),

          Positioned(
            top: 15,
            right: MediaQuery.of(context).size.width*.2,
            child:  Image.asset('lib/assets/images/elementos/caixa_pergunta.png',
                width:MediaQuery.of(context).size.width*.5,
                fit: BoxFit.cover),),


          Positioned(
              top: MediaQuery.of(context).size.height*.03,
              right: MediaQuery.of(context).size.width*.2,
              child:
              Container(
                padding: EdgeInsets.all(20),
                width:MediaQuery.of(context).size.width*.5,
                child:
                Text(game.perguntas[1][mapaSelect_red],textAlign:
                TextAlign.center,style: TextStyle(fontFamily: "MochiyPopPOne",color: Colors.black,fontSize:
                MediaQuery.of(context).size.height*.025),),)),



            Positioned(
                bottom:30,
                left: 50,
                child:
                Container(
                    margin: EdgeInsets.all(10),
                    width:MediaQuery.of(context).size.width*.4,
                    height:MediaQuery.of(context).size.height*.6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20)),
                    child:
                    FittedBox(
                        fit: BoxFit.fitHeight,
                        child:
                    Column(children: [

                      GestureDetector(
                          onTap: (){
                            setState(() {
                              resp_jogada=0;
                              if (resp_jogada == resp_red){
                                startTimerPop();
                                acerto=true;
                                setPerguntaRespondida();
                                // // _timer.cancel();
                                if(mapaSelect_red==0)
                                  btn_1=false;
                                if(mapaSelect_red==1)
                                  btn_2=false;
                                if(mapaSelect_red==2)
                                  btn_3=false;
                                if(mapaSelect_red==3)
                                  btn_4=false;
                                if(mapaSelect_red==4)
                                  btn_5=false;
                              }else{
                                vidas--;
                                startTimerPop();
                                erro=true;
                                // _timer.cancel();
                              }
                            });
                          },
                          child:
                          FittedBox(
                              fit: BoxFit.fitHeight,
                              child:
                              Stack(
                                  children: <Widget>[

                                    Container(
                                        margin: EdgeInsets.all(4),
                                        width: w_alt,
                                        child : resp_jogada == -1 ?
                                        image_a_normal :
                                        resp_jogada == 0 && acerto ?
                                        image_a_certa
                                            :
                                        erro && resp_jogada == 0?
                                        Image.asset("lib/assets/images/elementos/a_alternativa_errada.png"):
                                        image_a_normal
                                    ),

                                    Positioned(left:MediaQuery.of(context).size.width*.09,
                                        top:17,child:
                                        Text( form_red[mapaSelect_red][0],style: TextStyle(fontSize: MediaQuery.of(context).size.width*.023,color: Colors.white,
                                            fontFamily: 'MochiyPopPOne'))),
                                  ]))),

                      GestureDetector(
                          onTap: (){
                            setState(() {
                              resp_jogada=1;
                              if (resp_jogada == resp_red){
                                startTimerPop();
                                acerto=true;
                                setPerguntaRespondida();
                                // // _timer.cancel();
                                if(mapaSelect_red==0)
                                  btn_1=false;
                                if(mapaSelect_red==1)
                                  btn_2=false;
                                if(mapaSelect_red==2)
                                  btn_3=false;
                                if(mapaSelect_red==3)
                                  btn_4=false;
                                if(mapaSelect_red==4)
                                  btn_5=false;
                              }else{
                                vidas--;
                                startTimerPop();
                                erro=true;
                                // _timer.cancel();
                              }
                            });
                          },
                          child:
                          FittedBox(
                              fit: BoxFit.fitHeight,
                              child:
                              Stack(
                                  children: <Widget>[

                                    Container(
                                        margin: EdgeInsets.all(4),
                                        padding: EdgeInsets.all(8),
                                        width: w_alt,
                                        child : resp_jogada == -1 ?
                                        Image.asset("lib/assets/images/elementos/b_alternativa_normal.png") :
                                        resp_jogada == 1 && acerto ?
                                        Image.asset("lib/assets/images/elementos/b_alternativa_certa.png")
                                            :
                                        erro && resp_jogada == 1?
                                        Image.asset("lib/assets/images/elementos/b_alternativa_errada.png"):
                                        Image.asset("lib/assets/images/elementos/b_alternativa_normal.png")
                                    ),

                                    Positioned(left:MediaQuery.of(context).size.width*.09,top:20,child:
                                    Text( form_red[mapaSelect_red][1],style: TextStyle(fontSize:
                                    MediaQuery.of(context).size.width*.023,color: Colors.white,fontFamily: 'MochiyPopPOne'))),
                                  ]))),

                      GestureDetector(
                          onTap: (){
                            setState(() {
                              resp_jogada=2;
                              if (resp_jogada == resp_red){
                                startTimerPop();
                                acerto=true;
                                setPerguntaRespondida();
                                // // _timer.cancel();
                                if(mapaSelect_red==0)
                                  btn_1=false;
                                if(mapaSelect_red==1)
                                  btn_2=false;
                                if(mapaSelect_red==2)
                                  btn_3=false;
                                if(mapaSelect_red==3)
                                  btn_4=false;
                                if(mapaSelect_red==4)
                                  btn_5=false;
                              }else{
                                vidas--;
                                startTimerPop();
                                erro=true;
                                // _timer.cancel();
                              }
                            });
                          },
                          child:
                          FittedBox(
                              fit: BoxFit.fitHeight,
                              child:
                              Stack(
                                  children: <Widget>[

                                    Container(
                                        margin: EdgeInsets.all(4),
                                        padding: EdgeInsets.all(8),
                                        width: w_alt,
                                        child : resp_jogada == -1 ?
                                        Image.asset("lib/assets/images/elementos/c_alternativa_normal.png") :
                                        resp_jogada == 2 && acerto ?
                                        Image.asset("lib/assets/images/elementos/c_alternativa_certa.png")
                                            :
                                        erro && resp_jogada == 2?
                                        Image.asset("lib/assets/images/elementos/c_alternativa_errada.png"):
                                        Image.asset("lib/assets/images/elementos/c_alternativa_normal.png")
                                    ),

                                    Positioned(left:MediaQuery.of(context).size.width*.09,top:20,child:
                                    Text( form_red[mapaSelect_red][2],style: TextStyle(fontSize:  MediaQuery.of(context).size.width*.023,color: Colors.white,fontFamily: 'MochiyPopPOne'))),
                                  ]))),

                      GestureDetector(
                          onTap: (){
                            setState(() {
                              resp_jogada=3;
                              if (resp_jogada == resp_red){
                                startTimerPop();
                                acerto=true;
                                setPerguntaRespondida();
                                // // _timer.cancel();
                                if(mapaSelect_red==0)
                                  btn_1=false;
                                if(mapaSelect_red==1)
                                  btn_2=false;
                                if(mapaSelect_red==2)
                                  btn_3=false;
                                if(mapaSelect_red==3)
                                  btn_4=false;
                                if(mapaSelect_red==4)
                                  btn_5=false;
                              }else{
                                vidas--;
                                startTimerPop();
                                erro=true;
                                // _timer.cancel();
                              }
                            });
                          },
                          child:
                          FittedBox(
                              fit: BoxFit.fitHeight,
                              child:
                              Stack(
                                  children: <Widget>[

                                    Container(
                                        margin: EdgeInsets.all(4),
                                        padding: EdgeInsets.all(8),
                                        width: w_alt,
                                        child : resp_jogada == -1 ?
                                        Image.asset("lib/assets/images/elementos/d_alternativa_normal.png") :
                                        resp_jogada == 3 && acerto ?
                                        Image.asset("lib/assets/images/elementos/d_alternativa_certa.png")
                                            :
                                        erro && resp_jogada == 3?
                                        Image.asset("lib/assets/images/elementos/d_alternativa_errada.png"):
                                        Image.asset("lib/assets/images/elementos/d_alternativa_normal.png")
                                    ),

                                    Positioned(left:MediaQuery.of(context).size.width*.09,top:20,child:
                                    Text( form_red[mapaSelect_red][3],style: TextStyle(fontSize:  MediaQuery.of(context).size.width*.023,color: Colors.white,fontFamily: 'MochiyPopPOne'))),
                                  ]))),

                      // GestureDetector(
                      //     onTap: (){setState(() {resp_jogada=4;
                      //         if (resp_jogada == resp_red){
                      //           acerto=true;
                      //           startTimerPop();
                      // //           _timer.cancel();
                      //         }else{
                      //             vidas--;
                      //             erro=true;
                      //             startTimerPop();
                      // //             _timer.cancel();
                      //         }
                      //       });
                      //     },
                      //     child:
                      //     Container(
                      //       padding: EdgeInsets.all(8),
                      //       margin: EdgeInsets.all(4),
                      //       width: MediaQuery.of(context).size.width*.7,
                      //       decoration: BoxDecoration(color:resp_jogada==0 ?
                      //       Colors.white : Colors.amberAccent,
                      //           boxShadow: [BoxShadow(color:Colors.black54)],
                      //           border:  Border.all(color: Colors.brown,width: 4),
                      //           borderRadius: BorderRadius.circular(10)),
                      //       child: Text( form_red[mapaSelect_red][4],style: TextStyle(color:Colors.brown,fontSize: 16,fontFamily: 'MochiyPopPOne'),),)),


                    ])))
            ),

            Positioned(
                bottom: 3,
                right: MediaQuery.of(context).size.width*.02,
                child:
                Visibility(child:
                Container(child:
                erro ? Image.asset('lib/assets/images/elementos/garca_triste.png' ,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*.3, fit: BoxFit.cover) :
                acerto ? Image.asset('lib/assets/images/elementos/garca_feliz.png' ,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*.3, fit: BoxFit.cover) :
                Image.asset('lib/assets/images/elementos/garca_questoes.png' ,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*.3, fit: BoxFit.cover)
                ))),

          ]))
    ;
  }

  void startTimer() {
    // const oneSec = const Duration(seconds: 1);
    // _timer = new Timer.periodic(
    //   oneSec,
    //       (Timer timer) {
    //     if (_start == 0) {
    //       setState(() {
    //         timer.cancel();
    //         tempo_finalizado=true;
    //       });
    //     } else {
    //       setState(() {
    //         _start--;
    //       });
    //     }
    //   },
    // );
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


            if (_start_carang == 11)
              textCarang = 'Todo esse lixo afastou meus amigos e minha família daqui. Agora quem vai elogiar o meu trabalho?!';
            if (_start_carang == 7)
              textCarang = 'Por favor, limpe esta área para que eu possa receber alguns aplausos pelos meus desenhos novamente.';
            if (_start_carang == 3)
              textCarang = 'Conto com você!';

          });
        }
      },
    );
  }

  void startTimerPop() {

    int _start_time  = 3;
    const oneSec = const Duration(seconds: 1);
    late Timer _timer_pop;
    _timer_pop = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start_time == 0) {
          setState((){
            form_red_v=false;
            acerto=false;
            erro=false;
            mapaSelect_red=0;
            resp_jogada=-1;
            _start=30;
            visible_itensmap=true;
            _timer_pop.cancel();
            acerto=false;
          });

        } else {
          setState(() {
            _start_time--;
          });
        }
      },
    );
  }

  Widget popAcerto(){
    return
      Container(
          color: Colors.white.withAlpha(150),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset("lib/assets/images/elementos/pop_acerto.png",
            width: MediaQuery.of(context).size.width*.4,
            height: MediaQuery.of(context).size.height*.4));

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
          color: Colors.white.withAlpha(150),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Image.asset("lib/assets/images/elementos/voce_errou.png",
            width: MediaQuery.of(context).size.width*.4,
            height: MediaQuery.of(context).size.height*.4,

          ));
  }

  Widget popFinalMap(){
    return FinalPreto((){finalizado(true);});
      // Container(
      //     width: MediaQuery.of(context).size.width,
      //     height: MediaQuery.of(context).size.height,
      //     decoration: BoxDecoration(color: Colors.white,
      //         boxShadow: [BoxShadow(color:Colors.black26,blurRadius: 3,spreadRadius: 3)]),
      //     child:
      //     Stack(children: [
      //
      //       // img_bg_form,
      //       Image.asset(
      //         "lib/assets/images/elementos/cenario_tralhoto.jpg",
      //         fit: BoxFit.cover,  height:MediaQuery.of(context).size.height,
      //         width:MediaQuery.of(context).size.width,),
      //       Positioned(top:MediaQuery.of(context).size.height*.01,right:0,child:
      //       Container(
      //           margin: EdgeInsets.all(15),
      //           child:
      //           GestureDetector(onTap:(){
      //             launch("https://youtu.be/qOODbkMOjKQ?t=1");
      //           },child:
      //           Image.asset(
      //             "lib/assets/images/elementos/link_360.png",
      //             height:MediaQuery.of(context).size.height*.35,
      //             width:MediaQuery.of(context).size.width*.35,), ))),
      //
      //       Positioned(
      //           bottom:10,
      //           left:-20,child:
      //       Container(
      //         child:
      //         Image.asset(
      //           "lib/assets/images/elementos/garca_e_carangueijo.png",
      //           height:MediaQuery.of(context).size.height*.6,),)),
      //       Positioned(
      //           top:MediaQuery.of(context).size.height*.55,
      //           left:0,child:
      //       Container(
      //         margin: EdgeInsets.all(15),
      //         child:
      //         Transform(
      //           alignment: Alignment.center,
      //           transform: Matrix4.rotationY(3),
      //           child:
      //         Image.asset(
      //           "lib/assets/images/elementos/guaxinim_feliz.png",
      //           height:MediaQuery.of(context).size.height*.5,),))),
      //
      //       Positioned(
      //           top:20,
      //           right:MediaQuery.of(context).size.width*.35,child:
      //       Container(
      //         margin: EdgeInsets.all(15),
      //         child:
      //         Image.asset(
      //           "lib/assets/images/elementos/caixa_dialogo.png",
      //           height:MediaQuery.of(context).size.height*.4,),)),
      //
      //       Positioned(
      //           bottom:0,
      //           right:MediaQuery.of(context).size.width*.125,child:
      //       Container(
      //         margin: EdgeInsets.all(15),
      //         child:
      //         Image.asset(
      //           "lib/assets/images/elementos/tralhoto.png",
      //           height:MediaQuery.of(context).size.height*.7,),)),
      //
      //       Positioned(
      //           bottom:0,
      //           right:MediaQuery.of(context).size.width*.35,child:
      //         GestureDetector(onTap:(){
      //           setState((){finalizado(true);});
      //         },child:
      //         Container(
      //           margin: EdgeInsets.all(15),
      //           child:
      //           Image.asset("lib/assets/images/elementos/seta_2.png",
      //           height:MediaQuery.of(context).size.height*.25,
      //           width:MediaQuery.of(context).size.width*.25,),))),
      //
      //     ],)
      // );

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