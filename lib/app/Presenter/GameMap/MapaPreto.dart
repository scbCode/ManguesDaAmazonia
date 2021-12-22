
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:animated_rotation/animated_rotation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mangues_da_amazonia/app/Engine/Game.dart';
import 'package:mangues_da_amazonia/app/LocalDB/Repository.dart';
import 'package:mangues_da_amazonia/app/Presenter/GameMap/GameMap.dart';
import 'package:mangues_da_amazonia/app/Presenter/Widgets/Pergunta.dart';
import 'package:mangues_da_amazonia/app/Presenter/Widgets/final_preto.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';

import 'package:url_launcher/url_launcher.dart';


class MapaPreto extends StatefulWidget {
  Function finalizado;
  Repository repository = Repository();
  bool som=false;
  MapaPreto(this.finalizado,this.repository,this.som);

  @override
  _MapaPreto createState() => _MapaPreto(this.finalizado,this.repository,this.som);
}

class _MapaPreto extends State<MapaPreto> with SingleTickerProviderStateMixin {

  Function finalizado;
  Repository repository = Repository();
  bool som=false;

  _MapaPreto(this.finalizado,this.repository,this.som);

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
  late Timer _timer_pop;
  late Timer _timer_carang;
  int _start_carang = 24;
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
  String textCarang = "\nEstou com um\nbaita bloqueio criativo!\nNão consigo desenhar nada.";
  int totalPerguntas_respondidas = 0;
  dynamic form;
  late Image img_bg;
  List<int> resposta_certa=[2,1,1,3,0];
  late List<List<String>> form_red = [];
  double w_alt = 0.0;
  Image image_a_normal = Image.asset("lib/assets/images/elementos/a_alternativa_normal.png");
  Image image_a_certa = Image.asset("lib/assets/images/elementos/a_alternativa_certa.png");
  late Image fundo_mangue_preto;
  late Image mao_pelada;
  bool load=true;
  late AssetImage image_caixa_dialogo;
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer audioPlayermusic = AudioPlayer();

  late  Image garca_triste;

  @override
  void initState() {
    super.initState();

    // TODO: implement initState
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
    _controller.repeat(reverse: true);
    form_red.addAll(game.respostas[1]);
    mapaSelect_red = resposta_certa[0];
    playMusic();
  }
  @override
    void dispose()  {

      super.dispose(); //change here
    _timer_carang.cancel();
    _timer_pop.cancel();
    audioPlayermusic.dispose();
    audioPlayer.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    w_alt = MediaQuery.of(context).size.width*.55;
    image_caixa_dialogo =  AssetImage("lib/assets/images/elementos/caixa_dialogo.png",);

    fundo_mangue_preto=Image.asset('lib/assets/images/elementos/fundo_mangue_preto.jpeg',
        height: MediaQuery.of(context).size.height,
        width: MediaQuery
            .of(context)
            .size
            .width, fit: BoxFit.cover);

    mao_pelada = Image.asset('lib/assets/images/elementos/mao_pelada.png',
        width: MediaQuery
            .of(context)
            .size
            .width*.30, fit: BoxFit.cover);
    garca_triste = Image.asset('lib/assets/images/elementos/garca_triste.png' ,
        width: MediaQuery
            .of(context)
            .size
            .width*.3, fit: BoxFit.cover);
    precacheImage(garca_triste.image,context);
    precacheImage(fundo_mangue_preto.image,context).then((value) =>
      precacheImage(mao_pelada.image,context).then((value) =>
        precacheImage(image_caixa_dialogo,context).then((value) => setState((){
          load=false;
          startTimerAnim();
        }))
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
          onWillPop: () {
            audioPlayermusic.stop();
            return new Future.value(true);
          },
          child:
      Material(
          type: MaterialType.transparency,
          child:
          Stack(
          alignment: Alignment.center,
          children:[

            Container(
                height: MediaQuery.of(context).size.height,
                width:MediaQuery.of(context).size.width,
                child:fundo_mangue_preto),

            Container(
                height: MediaQuery.of(context).size.height,
                width:MediaQuery.of(context).size.width,
                child:
                Visibility(
                    visible: form_red_v,
                    child:Form_red())),

            Visibility(visible: visible_itensmap && !anim_carangueijo,child:
            mapPerguntas()),

            Visibility(visible: anim_carangueijo,child:
            Positioned(
                bottom: MediaQuery.of(context).size.height*.3,
                right: MediaQuery.of(context).size.width*.4325,
                child:
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                image: image_caixa_dialogo,
                fit: BoxFit.scaleDown,
                ),
                ),
              child:
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(20,30,30,30),
                padding: EdgeInsets.all(15),
                child: ConstrainedBox(
                      constraints:BoxConstraints(
                        minWidth:  MediaQuery.of(context).size.width*.1,
                        maxWidth:  MediaQuery.of(context).size.width*.35,
                        maxHeight: MediaQuery.of(context).size.height*.3,
                      ),
                      child:
              Text(textCarang, textAlign: TextAlign.start,style:
              TextStyle(fontFamily: "MochiyPopPOne",color:  Colors.black,fontSize: MediaQuery.of(context).size.width*.017)),))))),

            Positioned(
                top: MediaQuery.of(context).size.height*.45,
                right: MediaQuery.of(context).size.width*.23,
                child:
                Visibility(visible: anim_carangueijo,child:
                Container(child:mao_pelada))),


            Positioned(
                bottom: 30,
                right: 30,
                child:
                GestureDetector(
                    onTap: (){
                      setState(() {
                        anim_carangueijo=false;
                        _timer_carang.cancel();
                      });
                    },child:Visibility(visible: anim_carangueijo,child:
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(color: Color(0xFF0E434B),
                        borderRadius: BorderRadius.circular(20)),
                    child:
                    Text("Pular",style: TextStyle(color:Colors.white,fontSize: 16,fontFamily: "Ubuntu"),))))),


            Visibility(visible: acerto,child:
            popAcerto()),

            Visibility(visible: erro,child:
            popErro()),

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

            Visibility(visible: finalizado_,child:
            popFinalMap()),

            Visibility(visible: form_red_v && !finalizado_,child:
            Garca()),

            Visibility(visible: load,child:
            Container(alignment: Alignment.center,color: Colors.white,
              child:
              Column(crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,children:[
                    CircularProgressIndicator(color: Color(0xFF0E434B),)
                  ]),)),

            Visibility(visible: !anim_carangueijo && !finalizado_,child:
            Positioned(
                top:MediaQuery
                    .of(context)
                    .size
                    .height*.25,
                right: 0,
                child:Vidas()
            )),

            Visibility(visible:  vidas==0 && !form_red_v && !finalizado_,child:
            GameOver()),

            Positioned(
                top:4,
                right: 10,
                child:
                Container(child:
                Image.asset('lib/assets/images/elementos/logo_horizontal_preferencial.png',
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*.15, fit: BoxFit.cover))),

          ])));

  }

  Widget mapPerguntas(){
    return
      Stack(
          children:[

            Positioned(
                bottom: MediaQuery.of(context).size.height*.1,
                left: MediaQuery.of(context).size.width*.05,
                child:
                BotaoPergunta(url: 'lib/assets/images/elementos/escudo.png',
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
                BotaoPergunta(url:'lib/assets/images/elementos/guardachuva.png',
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
                top: MediaQuery.of(context).size.height*.35,
                right: MediaQuery.of(context).size.width*.35,
                child:Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(2),
                  child:
                BotaoPergunta(url:'lib/assets/images/elementos/jeans.png',
                    ativo:btn_3,click: (){
                      setState(() {
                        mapaSelect_red=2;
                        form_red_v=true;
                        resp_red=resposta_certa[mapaSelect_red];

                        visible_itensmap=false;
                        startTimer();

                      });
                    }))),


            Positioned(
                bottom: MediaQuery.of(context).size.height*.05,
                right: MediaQuery.of(context).size.width*.15,
                child:
                BotaoPergunta(url:'lib/assets/images/elementos/manopla.png',
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
                child:Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationZ(2),
              child:
                BotaoPergunta(url:'lib/assets/images/elementos/martelo.png',
                    ativo:btn_5,click: (){
                      setState(() {
                        mapaSelect_red=4;
                        resp_red=resposta_certa[mapaSelect_red];

                        form_red_v=true;
                        visible_itensmap=false;

                        startTimer();

                      });
                    }))),

          ]);
  }

  Widget Form_red(){
    return
      Container(
          height: MediaQuery.of(context).size.height,
          width:MediaQuery.of(context).size.width,
          child:
          Stack(children:[

            Image.asset('lib/assets/images/elementos/fundo_mangue_preto.jpeg',
                width:MediaQuery.of(context).size.width,
                height:MediaQuery.of(context).size.height,
                fit: BoxFit.cover),
          Positioned(
              top:0,
              left:MediaQuery.of(context).size.width*.25,
              child:
          Stack(
              fit: StackFit.passthrough,
              alignment: Alignment.center,
              children:[

                Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("lib/assets/images/elementos/caixa_pergunta.png"),
                  fit: BoxFit.cover,
                    ),
                ),
              child:Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(20),
                child:ConstrainedBox(
                  constraints:BoxConstraints(
                    minWidth:  MediaQuery.of(context).size.width*.52,
                    maxWidth:  MediaQuery.of(context).size.width*.525,
                    maxHeight: MediaQuery.of(context).size.height*.2,
                  ),
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child:
                Text(game.perguntas[1][mapaSelect_red],textAlign:
                TextAlign.center,style: TextStyle(fontFamily: "MochiyPopPOne",color: Colors.black),),),)))
                // Image.asset('lib/assets/images/elementos/caixa_pergunta.png',
                //     width:MediaQuery.of(context).size.width*.6,
                //     fit: BoxFit.cover),


              ])),


            Positioned(
                bottom:10,
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
                                    playAcertoSound();

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
                                    setState(() {
                                        vidas--;
                                      });
                                    startTimerPop();
                                    erro=true;
                                    if (vidas==0){
                                      audioPlayermusic.stop();
                                       playGameOver() ;
                                    }
                                    playErroSound();
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
                                                fontFamily: 'Ubuntu',fontWeight: FontWeight.bold))),
                                      ]))),

                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  resp_jogada=1;
                                  if (resp_jogada == resp_red){
                                    startTimerPop();
                                    acerto=true;
                                    playAcertoSound();

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
                                    setState(() {
                                        vidas--;
                                      });
                                    startTimerPop();
                                    erro=true;
                                    if (vidas==0){
                                      audioPlayermusic.stop();
                                       playGameOver() ;
                                    }
                                    playErroSound();
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
                                        MediaQuery.of(context).size.width*.023,color: Colors.white,fontFamily: 'Ubuntu',fontWeight: FontWeight.bold))),
                                      ]))),

                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  resp_jogada=2;
                                  if (resp_jogada == resp_red){
                                    startTimerPop();
                                    acerto=true;
                                    playAcertoSound();

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
                                    setState(() {
                                        vidas--;
                                      });
                                    startTimerPop();
                                    erro=true;
                                    if (vidas==0){
                                      audioPlayermusic.stop();
                                       playGameOver() ;
                                    }
                                    playErroSound();
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
                                            Image.asset("lib/assets/images/elementos/c_alternativa_normal.png") :
                                            resp_jogada == 2 && acerto ?
                                            Image.asset("lib/assets/images/elementos/c_alternativa_certa.png")
                                                :
                                            erro && resp_jogada == 2?
                                            Image.asset("lib/assets/images/elementos/c_alternativa_errada.png"):
                                            Image.asset("lib/assets/images/elementos/c_alternativa_normal.png")
                                        ),

                                        Positioned(left:MediaQuery.of(context).size.width*.09,top:20,child:
                                        Text( form_red[mapaSelect_red][2],style: TextStyle(fontSize:  MediaQuery.of(context).size.width*.023,color: Colors.white,fontFamily: 'Ubuntu',fontWeight: FontWeight.bold))),
                                      ]))),

                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  resp_jogada=3;
                                  if (resp_jogada == resp_red){
                                    startTimerPop();
                                    acerto=true;
                                    playAcertoSound();

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
                                    setState(() {
                                        vidas--;
                                      });
                                    startTimerPop();
                                    erro=true;
                                    if (vidas==0){
                                      audioPlayermusic.stop();
                                       playGameOver() ;
                                    }
                                    playErroSound();
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
                                            Image.asset("lib/assets/images/elementos/d_alternativa_normal.png") :
                                            resp_jogada == 3 && acerto ?
                                            Image.asset("lib/assets/images/elementos/d_alternativa_certa.png")
                                                :
                                            erro && resp_jogada == 3?
                                            Image.asset("lib/assets/images/elementos/d_alternativa_errada.png"):
                                            Image.asset("lib/assets/images/elementos/d_alternativa_normal.png")
                                        ),

                                        Positioned(left:MediaQuery.of(context).size.width*.09,top:20,child:
                                        Text( form_red[mapaSelect_red][3],style: TextStyle(fontSize:  MediaQuery.of(context).size.width*.023,color: Colors.white,fontFamily: 'Ubuntu',fontWeight: FontWeight.bold))),
                                      ]))),

                          // GestureDetector(
                          //     onTap: (){setState(() {resp_jogada=4;
                          //         if (resp_jogada == resp_red){
                          //           acerto=true;
                          //           startTimerPop();
                          // //           _timer.cancel();
                          //         }else{
                          //             setState(() {

                          //             erro=true;
                          //             startTimerPop();
                          // //             _timer.cancel();
                          //         }
                          //       });
                          //     },
                          //     child:
                          //     Container(
                          //
                          //       margin: EdgeInsets.all(4),
                          //       width: MediaQuery.of(context).size.width*.7,
                          //       decoration: BoxDecoration(color:resp_jogada==0 ?
                          //       Colors.white : Colors.amberAccent,
                          //           boxShadow: [BoxShadow(color:Colors.black54)],
                          //           border:  Border.all(color: Colors.brown,width: 4),
                          //           borderRadius: BorderRadius.circular(10)),
                          //       child: Text( form_red[mapaSelect_red][4],style: TextStyle(color:Colors.brown,fontSize: 16,fontFamily: 'Ubuntu',fontWeight: FontWeight.bold),),)),


                        ])))
            ),



          ]))
    ;
  }

  Widget Garca(){
    return  Positioned(
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
        )));
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
            _timer_carang.cancel();
            anim_carangueijo=false;
          });
        } else {
          setState(() {

            _start_carang--;


            if (_start_carang == 17)
              textCarang = '\n Todo esse lixo afastou\n meus amigos e minha família\n daqui. Agora quem vai elogiar\n o meu trabalho?!';
            if (_start_carang == 10)
              textCarang = '\n Por favor, limpe esta\n área para que eu possa receber\n alguns aplausos pelos meus\n desenhos novamente.';
            if (_start_carang == 4)
              textCarang = 'Conto com você!';

          });
        }
      },
    );
  }

  void startTimerPop() {

    int _start_time  = 3;
    const oneSec = const Duration(seconds: 1);
    _timer_pop = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start_time == 0) {
          setState((){
            if (acerto)
              setPerguntaRespondida();

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
          height: MediaQuery
              .of(context)
              .size
              .height,
          decoration: BoxDecoration(color: Colors.white,
              boxShadow: [BoxShadow(color:Colors.black26,blurRadius: 3,spreadRadius: 3)]),
          child:
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                    margin: EdgeInsets.all(15),
                    child:
                    Text("Suas vidas acabaram",style: TextStyle(color:Colors.black,fontSize: 24,
                        fontFamily: 'Ubuntu',fontWeight: FontWeight.bold),)),

                garca_triste,

                GestureDetector(
                    onTap: (){Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GameMap("1",som,false,repository)),
                    ); },
                    child:
                    Image.asset("lib/assets/images/elementos/seta_2.png",width: 100,))

              ])
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
    return
    FinalPreto((){
      repository.updateJogador("2");
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameMap("2",som,true,repository)),
    );});
  }

  setPerguntaRespondida(){
    totalPerguntas_respondidas++;
    if (totalPerguntas_respondidas==5){
      setState(() {
        if (vidas>0){
          audioPlayermusic.stop();
          finalizado_=true;
        }
      });
    }
  }

  playMusic() async {
    if (som){
      final file = new File('${(await getTemporaryDirectory()).path}/musicafase2.mp3');
      await file.writeAsBytes((await loadAsset('lib/assets/sons/fase2.mp3')).buffer.asUint8List());
      final result = await audioPlayermusic.play(file.path, isLocal: true,volume: 0.1);
    }
  }
  playGameOver() async {
    // print(result);
    if (som){
      final file = new File('${(await getTemporaryDirectory()).path}/gameover.mp3');
      await file.writeAsBytes((await loadAsset('lib/assets/sons/gameover.mp3')).buffer.asUint8List());
      final result = await audioPlayer.play(file.path, isLocal: true,volume: 0.1);
    }
  }
  playErroSound() async {
    if (som){
      final file = new File('${(await getTemporaryDirectory()).path}/erro.mp3');
      await file.writeAsBytes((await loadAsset('lib/assets/sons/som_error.mp3')).buffer.asUint8List());
      final result = await audioPlayer.play(file.path, isLocal: true,volume: 0.1);
    }
  }

  playAcertoSound() async {
    if (som) {
      final file = new File(
          '${(await getTemporaryDirectory()).path}/acerto.mp3');
      await file.writeAsBytes(
          (await loadAsset('lib/assets/sons/som_acerto.mp3')).buffer
              .asUint8List());
      final result = await audioPlayer.play(
          file.path, isLocal: true, volume: 0.4);
    }
  }

  Future<ByteData> loadAsset(String path) async {
    return await rootBundle.load(path);
  }

  Widget Vidas(){
    return
      Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
          MainAxisAlignment.end,
          children: [
            Visibility(visible: vidas >= 1,child:
            Container(
              decoration: BoxDecoration(color:
              Colors.white,
                  borderRadius: BorderRadius.circular(50)),
              margin:
              EdgeInsets.all(10), padding:
            EdgeInsets.all(5),
              child: Image.asset("lib/assets/images/elementos/ic_mangues.png",width: 40,),)),
            Visibility(visible: vidas >= 2,child:
            Container(
              decoration: BoxDecoration(color:
              Colors.white,
                  borderRadius: BorderRadius.circular(50)),
              margin:
              EdgeInsets.all(10), padding:
            EdgeInsets.all(5),
              child: Image.asset("lib/assets/images/elementos/ic_mangues.png",width: 40),)),
            Visibility(visible: vidas == 3,child:
            Container( decoration: BoxDecoration(color:
            Colors.white,
                borderRadius: BorderRadius.circular(50)),
              margin:
              EdgeInsets.all(10), padding:
              EdgeInsets.all(5),
              child: Image.asset("lib/assets/images/elementos/ic_mangues.png",width: 40),)),
          ]);
  }
}