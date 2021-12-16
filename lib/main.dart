import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangues_da_amazonia/app/Aguarde/AguardePage.dart';
import 'package:mangues_da_amazonia/app/Presenter/TelaAnimacao/TelaAnimacao.dart';

import 'app/Presenter/GameMap/GameMap.dart';
import 'app/Presenter/home/Home.dart';
import 'app/Splash/Splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mangues da Amazonia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin  {
  late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    _controller = AnimationController(
      duration: const Duration(milliseconds:1000),
      vsync: this,

    );
    _controller.repeat();
  
  }

  Tween<double> _tween = Tween(begin: 0.4, end: 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        type: MaterialType.transparency,
        child: Splash())
    );
  }
}
