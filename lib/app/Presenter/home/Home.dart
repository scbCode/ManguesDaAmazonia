
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:animated_rotation/animated_rotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mangues_da_amazonia/app/LocalDB/Repository.dart';
import 'package:mangues_da_amazonia/app/Models/Jogador.dart';
import 'package:mangues_da_amazonia/app/Presenter/CompartilharCertificado/CompartilharCertificado.dart';
import 'package:mangues_da_amazonia/app/Presenter/GameMap/GameMap.dart';
import 'package:mobx/mobx.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  bool selo=false;

  Home(this.selo);

  @override
  _Home createState() => _Home(selo);
}

class _Home extends State<Home> with SingleTickerProviderStateMixin  {
  Repository repository = Repository();
  static Jogador? jogador;
  bool v_telaInicial=false;
  bool selo=false;
  bool som=true;
  bool open=true;
  bool pop_nome_jogador=false;
  GlobalKey _globalKey = new GlobalKey();
  String fase ="0";
  _Home(this.selo);
  TextEditingController _controller = TextEditingController();

  ScreenshotController screenshotController = ScreenshotController();
  late AnimationController _controller_anim_selo;
  Tween<double> _tween = Tween(begin: 1.4, end: 1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    _controller_anim_selo = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _controller_anim_selo.repeat(reverse: true);
    getJogador_();

  }

  getJogador_() async {
    await repository.initBD();
    jogador = await repository.getJogador(1);
    open=false;
     if (jogador==null){
       setState(() {
           selo=false;
       });
     }else {
         fase=jogador!.fase_atual;
         fase="0";
         som = jogador!.som == 0 ? false : true;
         setState(() {
           if (fase=="3")
                 selo=true;
               else
                 selo=false;
         });
     }
  }

  @override
  Widget build(BuildContext context) {
    return
      Material(
        type: MaterialType.transparency,
        child:Scaffold(
            resizeToAvoidBottomInset: true,
            body:
        Stack(
            alignment: Alignment.center,
            children:[
                SizedBox(width: MediaQuery.of(context).size.width,
                    height:MediaQuery.of(context).size.height
                ),

                Positioned(
                    top: 5,
                    right: MediaQuery.of(context).size.width*.025,
                    child:
                    GestureDetector(
                        onTap:(){
                          setState(() {
                            open=false;
                            som=!som;
                            updateSom();
                          });
                        },
                        child:
                    Container(
                        padding: EdgeInsets.all(15),
                        alignment:Alignment.center,
                        child: !som ? Image.asset('lib/assets/images/elementos/botao_audio.png',
                          width:MediaQuery.of(context).size.width*.04,fit: BoxFit.cover,) :
                        Image.asset('lib/assets/images/elementos/botao_audio_ativo.png',
                          width:MediaQuery.of(context).size.width*.04,fit: BoxFit.cover,)
                    ))),

                Positioned(
                    bottom: 0,
                    right: MediaQuery.of(context).size.width*.05,
                    child:
                GestureDetector(
                        onTap: (){

                          if (jogador==null || jogador!.nome=="-" )
                            setState(() {
                              pop_nome_jogador=true;
                            });
                            else
                          if (jogador!.nome!="-"){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GameMap(fase,som,false,repository)),
                            );}
                          },
                     child:
                Container(
                    padding: EdgeInsets.all(15),
                    alignment:Alignment.center,
                    width: MediaQuery.of(context).size.width*.4,
                    child: Image.asset('lib/assets/images/elementos/botao_jogar.png',fit: BoxFit.cover,)))),

                Visibility(visible: selo,
                    child:
                    Positioned(
                        top: MediaQuery.of(context).size.height*.23,
                        right: MediaQuery.of(context).size.width*.112,
                        child:
                GestureDetector(
                    onTap:(){
                      if (jogador==null)
                          getJogador_();
                      else
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CompartilharCertificado(selo,jogador!.nome)),
                      );
                    },child:    ScaleTransition(
                    scale: _tween.animate(CurvedAnimation(parent: _controller_anim_selo, curve: Curves.easeInExpo)),
                    child:Image.asset('lib/assets/images/elementos/selo.png',
                      fit: BoxFit.scaleDown,
                      height: MediaQuery.of(context).size.height*.2,
                      width: MediaQuery.of(context).size.width*.2)))
                )),

                Positioned(
                    top: MediaQuery.of(context).size.height*.15,
                    left: MediaQuery.of(context).size.height*.25,
                    child:
                    Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child:
                        Image.asset("lib/assets/images/elementos/logo_preferencial.png",
                            width: MediaQuery.of(context).size.height*.55))),

                Positioned(
                    bottom: 15,
                    left: MediaQuery.of(context).size.width*.05,
                    child:
                  Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child:
                      Image.asset("lib/assets/images/elementos/logo_petrobras.png",
                          width: MediaQuery.of(context).size.width*.45))),

                Visibility(visible: pop_nome_jogador,child:
                Positioned(
                left: 0,
                child:
                Container(
                    color: Colors.black54,
                    width: MediaQuery.of(context).size.width,
                    height:MediaQuery.of(context).size.height,
                    child:
                Column (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                 Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    width: 350,
                    height: 250,
                    decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.black)],
                        color: Colors.white, borderRadius:
                    BorderRadius.all(Radius.circular(20))),
                  child:
                  Column (
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        Text("Antes de começar, digite\no seu nome",textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold
                                ,fontFamily: 'Ubuntu'),),

                        TextField(controller: _controller,decoration:
                        InputDecoration(hintText: "Qual o seu nome?"),
                          style: TextStyle(fontFamily: 'Ubuntu'),textAlign: TextAlign.center,),


                        TextButton(onPressed: (){
                          if (jogador==null)
                            if (_controller.text.isNotEmpty)
                              repository.setJogador(_controller.text);
                              getJogador_();
                              setState(() {
                                pop_nome_jogador=false;
                              });

                        },
                            child: Text("Salvar",
                                style: TextStyle(fontFamily: 'Ubuntu',fontSize: 16)) )

                      ]))])))),

              ])),
        );

  }

  updateSom() async {
      repository.updateSom(som);
  }


}