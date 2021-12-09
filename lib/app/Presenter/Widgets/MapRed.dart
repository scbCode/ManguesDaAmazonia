
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
  int _start_carang = 8;
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
      ["Resposta Certa","Resposta","Resposta","Resposta","Resposta"],
      ["Resposta","Resposta","Resposta","Resposta","Resposta"],
      ["Resposta","Resposta","Resposta","Resposta","Resposta"],
      ["Resposta","Resposta","Resposta","Resposta","Resposta"],
      ["Resposta","Resposta","Resposta","Resposta","Resposta"],
  ];

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

            Visibility(visible: visible_itensmap,child:
            mapPerguntas()),

            Positioned(
                bottom: MediaQuery.of(context).size.height*.25,
                right: MediaQuery.of(context).size.width*.4325,
                child:
                Visibility(visible: anim_carangueijo,child:
                Container(child:
                Image.asset('lib/assets/images/elementos/caixa_dialogo.png',
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*.34, fit: BoxFit.cover)))),

            Positioned(
                    bottom: MediaQuery.of(context).size.height*.26,
                    left: MediaQuery.of(context).size.width*.27,
                    child:
                    Visibility(visible: anim_carangueijo,child:
              Container(
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height*.27,
                  width: MediaQuery.of(context).size.width*.25,
                child:Text(textCarang,textAlign: TextAlign.start,style:
                  TextStyle(color:  Colors.black,fontSize: MediaQuery.of(context).size.width*.018),))
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
                Image.asset('lib/assets/images/elementos/placa_mangue_vermelho_map.png',
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
              top: 15,
              right: MediaQuery.of(context).size.width*.2,
              child:  Image.asset('lib/assets/images/elementos/caixa_pergunta.png',
                  width:MediaQuery.of(context).size.width*.5,
                  fit: BoxFit.cover),),

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
                    .width*.25, fit: BoxFit.cover) :
           acerto ? Image.asset('lib/assets/images/elementos/garca_feliz.png' ,
                width: MediaQuery
                    .of(context)
                    .size
                    .width*.25, fit: BoxFit.cover) :
           Image.asset('lib/assets/images/elementos/garca_questoes.png' ,
               width: MediaQuery
                   .of(context)
                   .size
                   .width*.25, fit: BoxFit.cover)
            ))),

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

              Column(children: [

                GestureDetector(
                    onTap: (){
                      setState(() {
                        resp_jogada=0;
                        if (resp_jogada == resp_red){
                          startTimerPop();
                          acerto=true;
                          _timer.cancel();
                        }else{
                          vidas--;
                          startTimerPop();
                          erro=true;
                          _timer.cancel();
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
                        _timer.cancel();
                      }else{
                        vidas--;
                        startTimerPop();
                        erro=true;
                        _timer.cancel();
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
                          _timer.cancel();
                        }else{
                          vidas--;
                          startTimerPop();
                          erro=true;
                          _timer.cancel();
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

                      Positioned(left:MediaQuery.of(context).size.width*.08,top:20,child:
                      Text( form_red[mapaSelect_red][2],style: TextStyle(fontSize: 14,color: Colors.white,fontFamily: 'MochiyPopPOne'))),
                    ]))),

                GestureDetector(
                    onTap: (){
                      setState(() {
                        resp_jogada=3;
                        if (resp_jogada == resp_red){
                          startTimerPop();
                          acerto=true;
                          _timer.cancel();
                        }else{
                          vidas--;
                          startTimerPop();
                          erro=true;
                          _timer.cancel();
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

                      Positioned(left:MediaQuery.of(context).size.width*.08,top:20,child:
                      Text( form_red[mapaSelect_red][3],style: TextStyle(fontSize: 14,color: Colors.white,fontFamily: 'MochiyPopPOne'))),
                    ]))),

                // GestureDetector(
                //     onTap: (){setState(() {resp_jogada=4;
                //         if (resp_jogada == resp_red){
                //           acerto=true;
                //           startTimerPop();
                //           _timer.cancel();
                //         }else{
                //             vidas--;
                //             erro=true;
                //             startTimerPop();
                //             _timer.cancel();
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


              ]))
          )


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

            if (_start_carang == 6)
              textCarang = 'Basta tu tocar em um dos lixos que uma caixa de pergunta vai se abrir.';

            if (_start_carang == 4)
              textCarang = 'Basta escolher a pergunta certa e PUFF! Magicamente o lixo vai sumir.';

            if (_start_carang == 2)
              textCarang = 'Boa sorte!';

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
                          setPerguntaRespondida();
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
            height: MediaQuery.of(context).size.height*.4,));

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
    return
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.white,
              boxShadow: [BoxShadow(color:Colors.black26,blurRadius: 3,spreadRadius: 3)]),
          child:
          Stack(children: [

            // img_bg_form,
            Image.asset(
                "lib/assets/images/elementos/cenario_tralhoto.jpg",
                fit: BoxFit.cover,  height:MediaQuery.of(context).size.height,
              width:MediaQuery.of(context).size.width,),
            Positioned(top:MediaQuery.of(context).size.height*.01,right:5,child:
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
                  setState((){finalizado(true);});
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
                left:15,child:
            Container(
              margin: EdgeInsets.all(15),
              child:
              Image.asset(
                "lib/assets/images/elementos/garca_e_carangueijo.png",
                height:MediaQuery.of(context).size.height*.6,),)),

            Positioned(
                top:20,
                right:MediaQuery.of(context).size.width*.35,child:
            Container(
              margin: EdgeInsets.all(15),
              child:
              Image.asset(
                "lib/assets/images/elementos/caixa_dialogo.png",
                height:MediaQuery.of(context).size.height*.4,),)),

            Positioned(
                bottom:0,
                right:MediaQuery.of(context).size.width*.15,child:
              Container(
                  margin: EdgeInsets.all(15),
                  child:
                Image.asset(
                 "lib/assets/images/elementos/tralhoto.png",
                 height:MediaQuery.of(context).size.height*.5,),)),

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