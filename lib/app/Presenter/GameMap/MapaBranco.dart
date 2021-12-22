
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
import 'package:mangues_da_amazonia/app/Presenter/Widgets/final_branco.dart';
import 'package:mangues_da_amazonia/app/Presenter/Widgets/final_preto.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class MapaBranco extends StatefulWidget {
  Function finalizado;
  Repository repository = Repository();
  MapaBranco(this.finalizado,this.repository);

  @override
  _MapaBranco createState() => _MapaBranco(this.finalizado,this.repository);
}

class _MapaBranco extends State<MapaBranco> with SingleTickerProviderStateMixin {

  Function finalizado;
  Repository repository = Repository();

  _MapaBranco(this.finalizado,this.repository);

  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
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
  int _start_carang = 23;
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
  String textCarang = "\nGostaria de poder te receber\nmelhor, garça. Mas minhas raízes estão fracas demais desde que esse lixo todo tomou conta daqui.\n";

  int totalPerguntas_respondidas = 0;


  dynamic form;

  late Image img_bg;



  List<int> resposta_certa=[1,1,3,1,0];

  late List<List<String>> form_red = [];

  double w_alt = 0.0;
  Image image_a_normal = Image.asset("lib/assets/images/elementos/a_alternativa_normal.png");
  Image image_a_certa = Image.asset("lib/assets/images/elementos/a_alternativa_certa.png");

  late AssetImage image_caixa_pergunta;
  late AssetImage image_caixa_dialogo;
  late  Image garca_feliz;
  late  Image garca_triste;
  late  Image garca_pergunta;
  late  Image fundo_mangue_branco;
  late  Image arvore_falando;
  bool load=false;

  @override
  void initState() {
    super.initState();

    // TODO: implement initState
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
    _controller.repeat(reverse: true);
    form_red.addAll(game.respostas[2]);
    mapaSelect_red = resposta_certa[0];

  }

  @override
  void dispose(){
    super.dispose();
    _timer.cancel();
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
    fundo_mangue_branco = Image.asset('lib/assets/images/elementos/fundo_mangue_branco.jpg',
        width:MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
        fit: BoxFit.cover);
    arvore_falando = Image.asset('lib/assets/images/elementos/arvore_falando.png',
            width: MediaQuery
                .of(context)
                .size
                .width*.250, fit: BoxFit.cover);

    precacheImage(image_a_normal.image,context);
    precacheImage(image_a_certa.image,context);
    precacheImage(garca_triste.image,context);
    precacheImage(garca_pergunta.image,context);
    precacheImage(garca_feliz.image,context);
    precacheImage(image_caixa_dialogo,context).then((value) =>
        precacheImage(fundo_mangue_branco.image,context).then((value) =>
        setState(() {
          startTimerAnim();
          load=true;
        })));
    precacheImage(image_caixa_pergunta,context);

  }

  @override
  Widget build(BuildContext context) {
    return
      Material(
        type: MaterialType.transparency,
        child:
        !load ? Container(alignment: Alignment.center,color: Colors.white,
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,children:[
                CircularProgressIndicator(color: Color(0xFF0E434B),)
              ]),) :
        Stack(
          alignment: Alignment.center,
          children:[
            fundo_mangue_branco,
            Positioned(
                top: 0,
                child:Container(
                height: MediaQuery.of(context).size.height,
                width:MediaQuery.of(context).size.width,
                child:
                Visibility(
                    visible: form_red_v,
                    child:Form_red()))),

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
                        margin: EdgeInsets.fromLTRB(25,35,30,30),
                        padding: EdgeInsets.all(15),
                        child: ConstrainedBox(
                          constraints:BoxConstraints(
                            minWidth:  MediaQuery.of(context).size.width*.2,
                            maxWidth:  MediaQuery.of(context).size.width*.36,
                            maxHeight: MediaQuery.of(context).size.height*.5,
                          ),
                          child:
                          Text(textCarang, textAlign: TextAlign.start,style:
                          TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Ubuntu',color:  Colors.black
                              ,fontSize: MediaQuery.of(context).size.width*.017)),))))),

            Positioned(
                top: MediaQuery.of(context).size.height*.45,
                right: MediaQuery.of(context).size.width*.23,
                child:
                Visibility(visible: anim_carangueijo,child:
                Container(child:arvore_falando))),

            Visibility(visible: acerto,child:
            popAcerto()),

            Visibility(visible: erro,child:
            popErro()),

            Visibility(visible: vidas==0,child:
            GameOver()),

            Positioned(
                top: 0,
                right: MediaQuery.of(context).size.width*.4,
                child:
                Visibility(visible: !form_red_v && !finalizado_ ,child:
                Container(child:
                Image.asset('lib/assets/images/elementos/placa_mangue_branco_map.png',
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*.25, fit: BoxFit.cover)))),

            Visibility(visible: finalizado_,child:
             popFinalMap()),

            Visibility(visible: form_red_v && !finalizado_,child:
             Garca()),

            Positioned(
                top:4,
                right: 10,
                child:
                Container(child:
                Image.asset('lib/assets/images/elementos/logo_horizontal_preferencial.png',
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*.15, fit: BoxFit.cover)))

          ]));

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
                        visible_itensmap=false;
                        startTimer();
                        resp_red=resposta_certa[mapaSelect_red];

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

            Image.asset('lib/assets/images/elementos/fundo_mangue_branco.jpg',
                width:MediaQuery.of(context).size.width,
                height:MediaQuery.of(context).size.height,
                fit: BoxFit.cover),
            Positioned(
            top:-30,
            left:MediaQuery.of(context).size.width*.25,
            child:
            Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:image_caixa_pergunta,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                child:ConstrainedBox(
                  constraints:BoxConstraints(
                    minWidth:  MediaQuery.of(context).size.width*.1,
                    maxWidth:  MediaQuery.of(context).size.width*.5,
                    maxHeight: MediaQuery.of(context).size.height*.55,
                  ),
                  child:
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(25,25,25,25),
                    child:
                        Text(game.perguntas[2][mapaSelect_red],textAlign:
                        TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Ubuntu',color: Colors.black,fontSize:
                        MediaQuery.of(context).size.width*.016),),),)),
),
            Positioned(
                bottom:0,
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
                                    vidas--;
                                    startTimerPop();
                                    erro=true;playErroSound();
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
                                            top:MediaQuery.of(context).size.height*.07,child:
                                            Text( form_red[mapaSelect_red][0],style: TextStyle(fontSize: MediaQuery.of(context).size.width*.027,color: Colors.white,
                                                fontWeight: FontWeight.bold,fontFamily: 'Ubuntu'))),
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
                                    vidas--;
                                    startTimerPop();
                                    erro=true;playErroSound();
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

                                        Positioned(left:MediaQuery.of(context).size.width*.09,top:MediaQuery.of(context).size.height*.07,child:
                                        Text( form_red[mapaSelect_red][1],style: TextStyle(fontSize:
                                        MediaQuery.of(context).size.width*.027,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Ubuntu'))),
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
                                    vidas--;
                                    startTimerPop();
                                    erro=true;playErroSound();
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

                                        Positioned(left:MediaQuery.of(context).size.width*.09,top:MediaQuery.of(context).size.height*.07,child:
                                        Text( form_red[mapaSelect_red][2],style: TextStyle(fontSize:  MediaQuery.of(context).size.width*.027,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Ubuntu'))),
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
                                    vidas--;
                                    startTimerPop();
                                    erro=true;playErroSound();
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

                                        Positioned(left:MediaQuery.of(context).size.width*.09,top:MediaQuery.of(context).size.height*.07,child:
                                        Text( form_red[mapaSelect_red][3],style: TextStyle(fontSize:  MediaQuery.of(context).size.width*.027,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Ubuntu'))),
                                      ]))),


                        ])))
            ),

            Positioned(
                bottom: 3,
                right: MediaQuery.of(context).size.width*.02,
                child:
                Visibility(child:
                Container(child:
                erro ? garca_triste :
                acerto ? garca_feliz:
                garca_pergunta
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

            if (_start_carang == 14)
              textCarang = 'Pedi pros animais do\nmangue saírem e pedirem\najuda para alguém.';

            if (_start_carang == 6)
              textCarang = 'Mas aí trouxeram você.\nFazer o que, né?\nBoa sorte!';


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
                Text("Suas vidas acabaram",style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Ubuntu'),)),

            Container(
                margin: EdgeInsets.all(15),
                child:
                OutlinedButton(onPressed: (){
                  setState((){
                    finalizado(false);

                  });
                }, child: Text("Continuar",style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Ubuntu'),)))
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
    return
      FinalBranco((){
        repository.updateJogador("3");
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GameMap("3",true,repository)),
      );});
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

  playErroSound() async {
    final file = new File('${(await getTemporaryDirectory()).path}/erro.mp3');
    await file.writeAsBytes((await loadAsset('lib/assets/sons/som_error.mp3')).buffer.asUint8List());
    final result = await audioPlayer.play(file.path, isLocal: true,volume: 0.1);
  }

  playAcertoSound() async {
    final file = new File('${(await getTemporaryDirectory()).path}/acerto.mp3');
    await file.writeAsBytes((await loadAsset('lib/assets/sons/som_acerto.mp3')).buffer.asUint8List());
    final result = await audioPlayer.play(file.path, isLocal: true,volume: 0.4);
  }

  Future<ByteData> loadAsset(String path) async {
    return await rootBundle.load(path);
  }

}