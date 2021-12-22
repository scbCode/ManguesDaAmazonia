
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
import 'package:mangues_da_amazonia/app/Presenter/GameMap/GameMap.dart';
import 'package:mobx/mobx.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class CompartilharCertificado extends StatefulWidget {
  bool selo=false;
  String nome="";

  CompartilharCertificado(this.selo,this.nome);

  @override
  _CompartilharCertificado createState() => _CompartilharCertificado(nome);
}

class _CompartilharCertificado extends State<CompartilharCertificado> with SingleTickerProviderStateMixin  {
  GlobalKey _globalKey = new GlobalKey();
  String nome;
  _CompartilharCertificado(this.nome);
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    return
      RepaintBoundary(
          key: _globalKey,
          child:
          Scaffold(
              body:
              Container(
                alignment: Alignment.center,
                child:
                Stack(
                    children:[

                      Stack(children: [

                        Container(
                            height: MediaQuery.of(context).size.height*.8,
                            width: MediaQuery.of(context).size.width*.5,
                            color: Colors.white,
                            alignment: Alignment.center,
                            child:
                          Screenshot(
                              controller: screenshotController,
                              child:
                              Container(
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child:
                            Stack(
                              fit: StackFit.passthrough,
                                children: [

                             Positioned(
                                      top: MediaQuery.of(context).size.height*.0,
                                      left: MediaQuery.of(context).size.width*.225,
                                      child:
                              Image.asset('lib/assets/images/elementos/layout_certificado.png',
                                width: MediaQuery.of(context).size.width*.5)),


                             Positioned(
                                    bottom:  MediaQuery.of(context).size.height*.22,
                                    left: MediaQuery.of(context).size.width*.45,
                                    child:
                               Container(
                                    padding: EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    child:
                                  Text("$nome",
                                        textAlign: TextAlign.center,style:
                                        TextStyle(fontFamily: "MochiyPopPOne",color:  Colors.white,
                                        fontSize: MediaQuery.of(context).size.width*.020)))),
                                  //
                                  // Positioned(
                                  //     top: MediaQuery.of(context).size.height*.05,
                                  //     left: MediaQuery.of(context).size.width*.221,
                                  //     child:
                                  //     Container(
                                  //         padding: EdgeInsets.all(10),
                                  //         alignment: Alignment.center,
                                  //         child:
                                  //     SvgPicture.asset("lib/assets/images/elementos/logo_mangues.svg",
                                  //         width: MediaQuery.of(context).size.width*.225))),

                    ])))),


                      Positioned(
                              bottom: 0,
                              right: MediaQuery.of(context).size.width*.05,
                              child:
                                  ElevatedButton(onPressed:(){
                                      screenshotController
                                          .capture(delay: Duration(milliseconds: 400))
                                          .then((capturedImage) async {
                                              final directory = (await getExternalStorageDirectory())!.path;
                                              File imgFile = new File('$directory/certificado_protetor_do_mangue.png');
                                              await imgFile.writeAsBytes(capturedImage!);
                                              Share.shareFiles([imgFile.path], subject: 'Certificado', text: 'Parabens');
                                          }).catchError((onError) {
                                              SnackBar(content: Text("Ocorreu um erro ao compartilhar"));
                                          });
                                      },
                                      child: Text("Compartilhar"))
                          ),
                      ]),
                    ]),
              )));
  }

  Future<dynamic> ShowCapturedWidget(BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

  Widget Certificado(){
    return
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children:[





          ]);
  }

}