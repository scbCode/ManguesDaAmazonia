
import 'package:flutter/material.dart';

class Game extends StatefulWidget {

  Game();

  @override
  _Game createState() => _Game();
}

class _Game extends State<Game> with SingleTickerProviderStateMixin  {

  late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        alignment: Alignment.center,
        child: Stack(
            children:[
            ]),
      );
  }

}