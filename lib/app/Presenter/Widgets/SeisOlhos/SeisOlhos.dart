
import 'dart:async';

import 'package:flutter/material.dart';

class SeisOlhos extends StatefulWidget {
  int part = 0;
  SeisOlhos(this.part);
  @override
  _SeisOlhos createState() => _SeisOlhos(part);

}

class _SeisOlhos extends State<SeisOlhos> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Timer _timer;
  late Timer _timer_branco;
  late Timer _timer_preto;
  int _start = 0;
  String text = "Parabéns!\nParece que finalmente\no Mangue Vermelho\nfoi salvo!";
  int part = 0;
  _SeisOlhos(this.part);

  @override
  void initState() {
    super.initState();

    // TODO: implement initState
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
    _controller.repeat(reverse: true);

    if (part==0)
      startTimerAnim();
    if (part==1)
      startTimerAnimPreto();
    if (part==2)
      startTimerAnimBranco();

  }
  @override
  Widget build(BuildContext context) {
    return
      Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/assets/images/elementos/caixa_dialogo.png",),
              fit: BoxFit.scaleDown,
            ),
          ),
          child:
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(40,30,30,30),
            padding: EdgeInsets.all(15),
            child:
            Text(text, textAlign: TextAlign.start,style:
            TextStyle(fontFamily: "MochiyPopPOne",color:  Colors.black,fontSize: MediaQuery.of(context).size.width*.017)),));
      Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/assets/images/elementos/caixa_dialogo.png"),
              fit: BoxFit.cover,
            ),
          ),
          child:
            FittedBox(
              fit: BoxFit.fitWidth,
              child:     Container(
                  padding: EdgeInsets.fromLTRB(25, 15, 01, 15),
                  child: Text(text, textAlign: TextAlign.start,style:
            TextStyle(fontFamily: "MochiyPopPOne",color:  Colors.black,fontSize: MediaQuery.of(context).size.width*.017))),));
  }

  void startTimerAnim() {
    _start=0;
    const oneSec = const Duration(seconds: 1);
     _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 18) {
          setState(() {
            _timer.cancel();
          });
        } else {
          setState(() {

            _start++;

            if (_start == 0)
              text = 'Parabéns!\nParece que finalmente\no Mangue Vermelho\nfoi salvo!';

            if (_start == 3)
              text = 'Agora os caranguejos\npoderão ajudar a\nmanter o equilíbrio\ndo manguezal.';

            if (_start == 6)
              text = 'As tocas que eles\nfazem no chão oxigenam\ne distribuem\nnutrientes.';

            if (_start == 9)
              text = '\nE as folhas que comem\nretornam para o meio ambiente\nna forma de partículas, que\npotencializam a ação\nbacteriana.';

            if (_start == 12)
              text = 'Tu podes olhar de\nperto o Mangue Vermelho\nem 360o neste botão\naqui do lado.';

            if (_start == 15)
              text = 'Mas se quiser,\npodes ir direto para\na próxima fase também.\nA decisão é sua!';

          });
        }
      },
    );
  }
  void startTimerAnimPreto() {
    _start=0;
    const oneSec = const Duration(seconds: 1);
    _timer_preto = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 18) {
          setState(() {
            _timer_preto.cancel();
          });
        } else {
          setState(() {

            _start++;

            if (_start == 0)
              text = 'Tu conseguiu mais\numa vez!\nEu não tinha dúvidas\nque conseguirias.\nHAHAHA!';

            if (_start == 3)
              text = 'Tudo bem, eu duvidava\num pouco sim...\nMas você mostrou agora\nque não foi sorte!';

            if (_start == 6)
              text = 'Nossa vegetação é\ncomposta por espécies\nde troncos finos com\nraízes aéreas e respiratórias,\npois se desenvolveram\nfora dáguá.';

            if (_start == 9)
              text = 'E nossa flora é\nimportantíssima no\nprocesso de fixação do solo,\nevitando erosões.';

            if (_start == 12)
              text = 'Agora que você\nsabe disso tudo,\nque tal visitar o\nmangue preto com este\nvídeo em 360o?';

            if (_start == 15)
              text = 'Mas se quiser, podes\nir direto para\na próxima fase também.\nA decisão é sua!';

          });
        }
      },
    );
  }
  void startTimerAnimBranco() {
    _start=0;
    const oneSec = const Duration(seconds: 1);
    _timer_branco = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 18) {
          setState(() {
            _timer_branco.cancel();
          });
        } else {
          setState(() {

            _start++;

            if (_start == 0)
              text = 'Meus parabéns!\nVocê concluiu sua missão!';

            if (_start == 3)
              text = 'Agora você é\noficialmente um(a)\nProtetor(a) do Mangue!';

            if (_start == 6)
              text = 'Seus feitos serão\ncontados em rodas\nde história,\ncanções com seu nome serão';

            if (_start == 7)
              text = 'escritas e até\nfilmes com sua biografia\nserão estrelados pelo\nWagner Moura!';

            if (_start == 10)
              text = 'O Mangue produz cerca\nde 95% dos alimentos\nretirados do mar.\nMuitas famílias se\nnutrem disso.';

            if (_start == 14)
              text = 'Agora que você\nsabe disso tudo,\nque tal visitar o mangue\nbranco com este\nvídeo em 360o?';

            if (_start == 18)
              text = 'Tu também podes ir\nem frente e compartilhar\nseu Selo de Protetor da\nAmazônia com seus amigos.\nA decisão é sua!';

          });
        }
      },
    );
  }

}