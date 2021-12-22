
import 'dart:async';

import 'package:animated_rotation/animated_rotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mangues_da_amazonia/app/Presenter/TelaAnimacao/TelaAnimacao.dart';
import 'package:mangues_da_amazonia/app/Presenter/home/Home.dart';

class Splash extends StatefulWidget {

  Splash();

  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> with SingleTickerProviderStateMixin  {
  late Timer _timer;
  int _start = 4;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
          onWillPop: () async => false,
          child:
      Stack(children: [

        Positioned(
            top: MediaQuery.of(context).size.height*.15,
            left: MediaQuery.of(context).size.width *.37,
            child:
            Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child:Image.asset("lib/assets/images/elementos/logo_preferencial.png",
                    width: MediaQuery.of(context).size.width*.27))),

        Positioned(
            bottom: 15,
            left: MediaQuery.of(context).size.width *.25,
            child:
            Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child:
                Image.asset("lib/assets/images/elementos/logo_petrobras.png",
                    width: MediaQuery.of(context).size.width*.45))),


      ],));
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TelaAnimacao()),
            );
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }



}