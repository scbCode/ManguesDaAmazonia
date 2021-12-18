import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
class Video360 extends StatefulWidget {
  Video360();

  @override
  _Video360 createState() => _Video360();

}

class _Video360 extends State<Video360> with SingleTickerProviderStateMixin {
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'sPyAQQklc1s',
    flags: YoutubePlayerFlags(
      controlsVisibleAtStart: false, autoPlay: true,
      mute: true,
    ),
  );
  YoutubePlayerController _2controller = YoutubePlayerController(
    initialVideoId: 'sPyAQQklc1s',
    flags: YoutubePlayerFlags(controlsVisibleAtStart: false,
      autoPlay: true,
      mute: true,
    ),
  );

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    launch("www.youtube.com",);
  }
  @override
  Widget build(BuildContext context) {
    return 
     Container();
  }

}