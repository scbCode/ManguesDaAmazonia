
import 'package:animated_rotation/animated_rotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mangues_da_amazonia/app/LocalDB/Repository.dart';
import 'package:mangues_da_amazonia/app/Models/Jogador.dart';
import 'package:mangues_da_amazonia/app/Presenter/GameMap/GameMap.dart';
import 'package:mangues_da_amazonia/app/Presenter/home/Home.dart';
import 'package:mobx/mobx.dart';


class TelaAnimacao extends StatefulWidget {

  TelaAnimacao();

  @override
  _TelaAnimacao createState() => _TelaAnimacao();
}

class _TelaAnimacao extends State<TelaAnimacao> with SingleTickerProviderStateMixin  {
  Repository repository = Repository();
  late Jogador jogador;
  bool v_telaInicial=false;
  // late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.asset(
    //     "assets/videos/butterfly.mp4")
    //   ..setVolume(1.0)
    //   ..initialize()
    //   ..play();
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(

        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              intro(),
            ]),
      );
  }

  Widget intro(){
    return
      Stack(children: [

        Container(
            alignment:Alignment.center,
            height:MediaQuery.of(context).size.height,
            width:MediaQuery.of(context).size.width,
            child: new Image.asset('lib/assets/images/tela_03.jpg',fit: BoxFit.cover,
              height:MediaQuery.of(context).size.height,
              width:MediaQuery.of(context).size.width,),
          ),

        // Positioned (
        //   top:0,
        //   right: MediaQuery.of(context).size.width*.05,
        //   child:Image.asset('lib/assets/images/elementos/placa_intro.png',width: MediaQuery.of(context).size.width*.2,)),
        // Center(
        //   child: _controller.value.isInitialized
        //       ? AspectRatio(
        //     aspectRatio: _controller.value.aspectRatio,
        //     child: VideoPlayer(_controller),
        //   )
        //       : Container(),
        // ),
        Positioned (
            bottom:MediaQuery.of(context).size.height*.05,
            right: MediaQuery.of(context).size.width*.025,
            child:
            GestureDetector(
                onTap: (){
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home(false)),
                    );
                  });
                },
                child:
                Container(
                  child:
                  Image.asset(
                    "lib/assets/images/elementos/botao_pular.png",
                     height:MediaQuery.of(context).size.height*.25,
                    width:MediaQuery.of(context).size.width*.25,),
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(100)),)))
      ],);

  }



}