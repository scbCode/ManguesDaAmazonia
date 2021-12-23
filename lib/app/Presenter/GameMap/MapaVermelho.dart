
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:animated_rotation/animated_rotation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mangues_da_amazonia/app/Engine/Game.dart';
import 'package:mangues_da_amazonia/app/LocalDB/Repository.dart';
import 'package:mangues_da_amazonia/app/Presenter/GameMap/GameMap.dart';
import 'package:mangues_da_amazonia/app/Presenter/Widgets/Pergunta.dart';
import 'package:mangues_da_amazonia/app/Presenter/Widgets/SeisOlhos/SeisOlhos.dart';
import 'package:mangues_da_amazonia/app/Presenter/Widgets/final_vermelho.dart';
import 'package:path_provider/path_provider.dart';

class MapaVermelho extends StatefulWidget {
  Repository repository = Repository();
  bool som=false;

  MapaVermelho(this.repository,this.som);

  @override
  _MapaVermelho createState() => _MapaVermelho(repository,som);

}

class _MapaVermelho extends State<MapaVermelho> with  SingleTickerProviderStateMixin {
  bool som=false;
  _MapaVermelho(this.repository,this.som);
  Game game = Game();
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
  int btn_select = 0;
  String textCarang = "\nA nossa casa tá\numa zona! Nos ajude a\n"
      "limpar o mangue.\n";

  int totalPerguntas_respondidas = 0;

  List<int> resposta_certa=[3,2,0,1,3];

  Repository repository = Repository();

  dynamic form;

  late Image img_bg;

  late List<List<String>> form_red = [];

  double w_alt = 0.0;
  Image image_a_normal = Image.asset("lib/assets/images/elementos/a_alternativa_normal.png");
  Image image_a_certa = Image.asset("lib/assets/images/elementos/a_alternativa_certa.png");
  late AssetImage image_caixa_pergunta;
  late AssetImage image_caixa_dialogo;
  late  Image garca_feliz;
  late  Image garca_triste;
  late  Image garca_pergunta;
  late  Image fundo_mangue_vermelho;
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  static AudioPlayer audioPlayermusic = AudioPlayer();
  static AudioCache musicACache = AudioCache();

  bool load=true;

  @override
  void initState() {
    super.initState();

    form_red.addAll(game.respostas[0]);
    mapaSelect_red = resposta_certa[0];
    playMusic();
  }
  void _loadFileAC() async {

  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    w_alt = MediaQuery.of(context).size.width*.55;


    image_caixa_pergunta = AssetImage("lib/assets/images/elementos/caixa_pergunta.png");
    image_caixa_dialogo =  AssetImage("lib/assets/images/elementos/caixa_dialogo.png",);
    garca_feliz = Image.asset('lib/assets/images/elementos/garca_feliz.png' ,
        width: MediaQuery
            .of(context)
            .size
            .width*.3, fit: BoxFit.cover);
    garca_pergunta = Image.asset('lib/assets/images/elementos/garca_questoes.png' ,
        width: MediaQuery
            .of(context)
            .size
            .width*.3, fit: BoxFit.cover);
    garca_triste = Image.asset('lib/assets/images/elementos/garca_triste.png' ,
        width: MediaQuery
            .of(context)
            .size
            .width*.3, fit: BoxFit.cover);
    fundo_mangue_vermelho = Image.asset('lib/assets/images/elementos/fundo_mangue_vermelho.jpg',
        height: MediaQuery.of(context).size.height,
        width: MediaQuery
            .of(context)
            .size
            .width, fit: BoxFit.cover);

    precacheImage(image_a_normal.image,context);
    precacheImage(image_a_certa.image,context);
    precacheImage(garca_triste.image,context);
    precacheImage(garca_pergunta.image,context);
    precacheImage(garca_feliz.image,context);

    precacheImage(image_caixa_dialogo,context).then((value) =>
        precacheImage(image_caixa_pergunta,context).then((value) =>
        precacheImage(fundo_mangue_vermelho.image,context).then((value) => setState((){
          load=false;
          startTimerAnim();
        }))));

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

            Container (
                height: MediaQuery.of(context).size.height,
                width:MediaQuery.of(context).size.width,
                child:fundo_mangue_vermelho),

            Container(
                height: MediaQuery.of(context).size.height,
                width:MediaQuery.of(context).size.width,
                child:
                Visibility(
                    visible: form_red_v,
                    child:Form_red())),

            Positioned(
                top: 0,
                right: MediaQuery.of(context).size.width*.4,
                child:
                Visibility(visible: !form_red_v && !finalizado_ ,child:
                Container(child:
                Image.asset('lib/assets/images/elementos/placa_mangue_vermelho_map.png',
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*.25, fit: BoxFit.cover)))),

            Visibility(visible: visible_itensmap && !anim_carangueijo,child:
              mapPerguntas()),

            Positioned(
                bottom: MediaQuery.of(context).size.height*.3,
                right: MediaQuery.of(context).size.width*.4325,
                child:Visibility(visible: anim_carangueijo,child:
                Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:image_caixa_dialogo,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    child:
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(20,35,30,30),
                        padding: EdgeInsets.all(20),
                        child: ConstrainedBox(
                          constraints:BoxConstraints(
                            minWidth:  MediaQuery.of(context).size.width*.1,
                            maxWidth:  MediaQuery.of(context).size.width*.7,
                            maxHeight: MediaQuery.of(context).size.height*.3,
                          ),
                          child:
                          Text(textCarang, textAlign: TextAlign.start,style:
                          TextStyle(fontFamily: "Ubuntu", fontWeight: FontWeight.bold,color:  Colors.black,fontSize: MediaQuery.of(context).size.width*.017)),))))),

            Positioned(
                bottom: MediaQuery.of(context).size.height*.035,
                right: MediaQuery.of(context).size.width*.2,
                child:
                Visibility(visible: anim_carangueijo,child:
                Container(child:
                Image.asset('lib/assets/images/elementos/carangueijo.png',
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*.30, fit: BoxFit.cover)))),

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

            Visibility(visible: finalizado_,child:
            popFinalMap()),

            Visibility(visible: form_red_v && !finalizado_,child:
             Garca()),

            Visibility(visible: load,child:
            Positioned(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                top:0,
                left: 0,
                child:
                Container(alignment: Alignment.center,color: Colors.white,
                    child:
                    Column(crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,children:[
                          CircularProgressIndicator(color: Color(0xFF0E434B),)
                        ]))
            )),

            Visibility(visible: !anim_carangueijo && !finalizado_,child:
              Positioned(
                  top:MediaQuery
                      .of(context)
                      .size
                      .height*.25,
                  right: 0,
                  child:Vidas()
            )),

            Visibility(visible: vidas==0 && !form_red_v && !finalizado_,child:
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

  Widget mapPerguntas(){
    return
      Stack(
          children:[

            Positioned(
                bottom: MediaQuery.of(context).size.height*.1,
                left: MediaQuery.of(context).size.width*.05,
                child:
                BotaoPergunta(url: 'lib/assets/images/elementos/boia.png',
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
                top: MediaQuery.of(context).size.height*.2,
                left: MediaQuery.of(context).size.width*.15,
                child:
                BotaoPergunta(url:'lib/assets/images/elementos/bola.png',
                    ativo:btn_2,click: (){
                      setState(() {
                        mapaSelect_red=1;
                        resp_red=resposta_certa[mapaSelect_red];
                        form_red_v=true;
                        visible_itensmap=false;
                        startTimer();
                      });
                    })),

            Positioned(
                top: MediaQuery.of(context).size.height*.3,
                right: MediaQuery.of(context).size.width*.4,
                child:
                BotaoPergunta(url:'lib/assets/images/elementos/bota.png',
                    ativo:btn_3,click: (){
                      setState(() {
                        mapaSelect_red=2;
                        resp_red=resposta_certa[mapaSelect_red];
                        form_red_v=true;
                        visible_itensmap=false;
                        startTimer();
                      });
                    })),


            Positioned(
                bottom: MediaQuery.of(context).size.height*.05,
                right: MediaQuery.of(context).size.width*.15,
                child:
                BotaoPergunta(url:'lib/assets/images/elementos/capacete.png',
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
                BotaoPergunta(url:'lib/assets/images/elementos/carrinhobb.png',
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

            Positioned(
                top:0,
                left:MediaQuery.of(context).size.width*.25,
                child:

                Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: image_caixa_pergunta,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    child:ConstrainedBox(
                        constraints:BoxConstraints(
                          minWidth:  MediaQuery.of(context).size.width*.1,
                          maxWidth:  MediaQuery.of(context).size.width*.55,
                          maxHeight: MediaQuery.of(context).size.height*.35,
                        ),
                        child:
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(25,10,25,10),
                    child:
                    Text(game.perguntas[0][mapaSelect_red],textAlign:
                    TextAlign.center,style: TextStyle(fontFamily: "Ubuntu",fontWeight:
                        FontWeight.bold,color: Colors.black,fontSize:
                    MediaQuery.of(context).size.width*.018),),)))),


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
                                    // _timer.cancel();
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
                                            Text( form_red[mapaSelect_red][0],style:
                                            TextStyle(fontSize: MediaQuery.of(context).size.width*.03,color: Colors.white,
                                                fontFamily: 'Ubuntu',fontWeight: FontWeight.bold,
                                            ))),
                                      ]))),

                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  resp_jogada=1;
                                  if (resp_jogada == resp_red){
                                    startTimerPop();
                                    acerto=true;

                                    playAcertoSound();
                                    // _timer.cancel();
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
                                        MediaQuery.of(context).size.width*.03,color: Colors.white,fontFamily: 'Ubuntu',fontWeight: FontWeight.bold))),
                                      ]))),

                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  resp_jogada=2;
                                  print("");
                                  if (resp_jogada == resp_red){
                                    startTimerPop();

                                    acerto=true;

                                    playAcertoSound();
                                    // _timer.cancel();
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
                                        Text( form_red[mapaSelect_red][2],style: TextStyle(fontSize:  MediaQuery.of(context).size.width*.03,color: Colors.white,fontWeight:
                                        FontWeight.bold,fontFamily: 'Ubuntu',))),
                                      ]))),

                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  resp_jogada=3;
                                  if (resp_jogada == resp_red){
                                    startTimerPop();
                                    acerto=true;

                                    playAcertoSound();
                                    // _timer.cancel();
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
                                        Text( form_red[mapaSelect_red][3],style: TextStyle(fontSize:  MediaQuery.of(context).size.width*.03,fontWeight:
                                        FontWeight.bold,color: Colors.white,fontFamily: 'Ubuntu',))),
                                      ]))),

                        ])))),




          ]));
  }

  Widget Garca(){
    return Positioned(
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
        acerto ? garca_feliz :
               garca_pergunta
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
          _timer_carang.cancel();
          setState(() {
            anim_carangueijo=false;
          });
        } else {
          setState(() {

            _start_carang--;

            if (_start_carang == 13)
              textCarang = '\nBasta tocar em\num dos lixos que uma\ncaixa de pergunta vai\nse abrir.\n';

            if (_start_carang == 7)
              textCarang = '\nAcerte a pergunta e PUFF!\nO lixo do mangue sumirá.\n';

            if (_start_carang == 2)
              textCarang = '\nBoa sorte!  \n';

          });
        }
      },
    );
  }

  void startTimerPop() {
    int _start_time  = 3;
    const oneSec = const Duration(seconds: 1);
    _timer_pop = new Timer.periodic(
      oneSec, (Timer timer) {
        if (_start_time == 0) {
          setState((){

            if(acerto)
              setPerguntaRespondida();

            form_red_v=false;
            acerto=false;
            erro=false;
            mapaSelect_red=0;
            resp_jogada=-1;
            _start=30;
            visible_itensmap=true;
            _timer_pop.cancel();

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
            height: MediaQuery.of(context).size.height*.4,));

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
                    onTap: (){Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => GameMap("0",som,false,repository)),
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
      FinalVermelho((){
         repository.updateJogador("1");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GameMap("1",som,true,repository)),
        );
      });

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

  void startTimerLoad() {
    int _start_time  = 3;
    const oneSec = const Duration(seconds: 1);
    late Timer _timer_pop;
    _timer_pop = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start_time == 0) {
          setState((){
            _timer_pop.cancel();
          });
        } else {
          setState(() {
            _start_time--;
          });
        }
      });
  }

  playMusic() async {
    // print(result);
    if (som){
      final file = new File('${(await getTemporaryDirectory()).path}/musicafase.mp3');
      await file.writeAsBytes((await loadAsset('lib/assets/sons/fase1.mp3')).buffer.asUint8List());
       final result = await audioPlayermusic.play(file.path, isLocal: true,volume: 0.1);
    }
  }

  @override
  dispose()  {
    // audioPlayermusic.stop();
    // _timer_carang.cancel();
    _timer_pop.cancel();
    audioPlayermusic.dispose();
    audioPlayer.dispose();
    super.dispose(); //change here

  }

  playErroSound() async {
    // print(result);
    if (som){
    final file = new File('${(await getTemporaryDirectory()).path}/erro.mp3');
    await file.writeAsBytes((await loadAsset('lib/assets/sons/som_error.mp3')).buffer.asUint8List());
    final result = await audioPlayer
        .play(file.path, isLocal: true,volume: 0.1);
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

}