
import 'package:animated_rotation/animated_rotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mangues_da_amazonia/app/Presenter/GameMap/GameMap.dart';
import 'package:mobx/mobx.dart';


class BotaoPergunta extends StatefulWidget {

  Function click;
  bool ativo;
  BotaoPergunta({required this.ativo,required this.click});

  @override
  _BotaoPergunta createState() => _BotaoPergunta(ativo: ativo,click:click);
}

class _BotaoPergunta extends State<BotaoPergunta> with SingleTickerProviderStateMixin {

   bool ativo=true;
  Function click;

  _BotaoPergunta({required this.ativo,required this.click});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: (){
          if (ativo){
            click();
            ativo = false;
          }
        },
          child:
          ativo ?
            Container(width: MediaQuery.of(context).size.width*.1,height:
                 MediaQuery.of(context).size.height*.25,color: Colors.white.withAlpha(150))
              :
              Container(width: 0,height: 0,color: Colors.white.withAlpha(150)
              ,));
  }
}