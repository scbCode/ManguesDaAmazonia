import 'package:flutter/material.dart';
import 'package:mangues_da_amazonia/app/LocalDB/Repository.dart';

class AguardePage extends StatefulWidget {
  AguardePage();

  @override
  _AguardePage createState() => _AguardePage();
}

class _AguardePage extends State<AguardePage> with SingleTickerProviderStateMixin  {
  late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _controller.repeat(reverse: true);
  }
  Tween<double> _tween = Tween(begin: 0.9, end: 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Center(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logoAnimated(),
            Container(
              margin: EdgeInsets.fromLTRB(0,15,0,0),
              child:
              Text("Game Mangues da Amazônia",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Ubuntu'),),),
            Text("Em construção...",style: TextStyle(color:Colors.black54,fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Ubuntu'),)
          ],),)
    );
  }

  Widget logoAnimated(){
    return           ScaleTransition(
        scale: _tween.animate(CurvedAnimation(parent: _controller, curve: Curves.easeInExpo)),
        child:
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              boxShadow: [BoxShadow(color: Colors.black45,blurRadius:
              15,spreadRadius: 5)],
            ),
            margin: EdgeInsets.all(15),
            child:
            ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child:
                Image.asset('img_app.jpg',width: 150,))));
  }
}
