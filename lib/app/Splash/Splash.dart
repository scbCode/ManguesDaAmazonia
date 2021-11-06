
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {

  Splash();

  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _controllerA;
  late double animScale=0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerA = AnimationController(
        vsync: this,
        lowerBound: 0.5,
        upperBound: 1.0,
        duration: Duration(seconds: 1));
    _controllerA.addListener(() {
      setState(() {
        animScale = _controllerA.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child:
        Transform.scale(
        scale: animScale,
        child: Text("Mangues Da Amazonia...")));
  }

}