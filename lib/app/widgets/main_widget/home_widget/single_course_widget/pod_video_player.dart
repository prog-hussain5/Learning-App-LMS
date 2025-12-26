import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:webinar/common/common.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PodVideoPlayerDev extends StatefulWidget {
  final String type;
  final String url;
  final RouteObserver<ModalRoute<void>> routeObserver;
  final ValueKey key;

  const PodVideoPlayerDev(this.url,this.type, this.routeObserver,this.key,) : super(key: key);

  @override
  State<PodVideoPlayerDev> createState() => _VimeoVideoPlayerState();
}

class _VimeoVideoPlayerState extends State<PodVideoPlayerDev> with RouteAware, AutomaticKeepAliveClientMixin {
  YoutubePlayerController? youtubeController;

  @override
  void initState() {
    
    if (widget.type == 'youtube') {
      final videoId = YoutubePlayer.convertUrlToId(widget.url);
      youtubeController = YoutubePlayerController(
        initialVideoId: videoId ?? '',
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }

    
    super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }


  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    widget.routeObserver.unsubscribe(this);
    youtubeController?.dispose();
    super.dispose();
  }

  @override
  void didPush() {}

  @override
  @override
  void didPushNext() {
    // final route = ModalRoute.of(context)?.settings.name;
    try {
      youtubeController?.pause();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      key: widget.key,
      padding: padding(horizontal: 0),
      child: ClipRRect(
        borderRadius: borderRadius(),
        child: SizedBox(
          width: getSize().width,
          child: widget.type == 'youtube'
              ? (youtubeController != null
                  ? YoutubePlayer(
                      controller: youtubeController!,
                      showVideoProgressIndicator: true,
                    )
                  : Center(child: Text('لا يمكن عرض الفيديو، الرابط غير صحيح')))
              : Center(child: Text('نوع الفيديو غير مدعوم')), // يمكنك إضافة دعم vimeo لاحقاً
        ),
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}