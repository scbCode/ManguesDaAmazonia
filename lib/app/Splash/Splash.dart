
import 'package:animated_rotation/animated_rotation.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {

  Splash();

  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> with SingleTickerProviderStateMixin  {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
          height: 150.0,
          width: 150.0,
          child: new Image.asset('img_app.jpg'),
      );
  }


}