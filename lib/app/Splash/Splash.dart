
import 'dart:async';

import 'package:animated_rotation/animated_rotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangues_da_amazonia/app/Presenter/TelaAnimacao/TelaAnimacao.dart';
import 'package:mangues_da_amazonia/app/Presenter/home/Home.dart';

class Splash extends StatefulWidget {

  Splash();

  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> with SingleTickerProviderStateMixin  {
  late Timer _timer;
  int _start = 5;
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
      Container(
          alignment:Alignment.center,
          height:MediaQuery.of(context).size.height,
          width:MediaQuery.of(context).size.width,
          child: new Image.asset('lib/assets/images/logo_mangue.jpeg',
            height:MediaQuery.of(context).size.height,
            width:MediaQuery.of(context).size.width,fit: BoxFit.fill,),
      );
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