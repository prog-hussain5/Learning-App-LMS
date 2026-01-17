import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/config/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PodVideoPlayerDev extends StatefulWidget {
  final String type;
  final String url;
  final RouteObserver<ModalRoute<void>> routeObserver;
  final ValueKey key;

  const PodVideoPlayerDev(
    this.url,
    this.type,
    this.routeObserver,
    this.key,
  ) : super(key: key);

  @override
  State<PodVideoPlayerDev> createState() => _VimeoVideoPlayerState();
}

class _VimeoVideoPlayerState extends State<PodVideoPlayerDev>
    with RouteAware, AutomaticKeepAliveClientMixin {
  YoutubePlayerController? youtubeController;

  @override
  void initState() {
    if (widget.type == 'youtube') {
      final videoId = YoutubePlayer.convertUrlToId(widget.url);
      youtubeController = YoutubePlayerController(
        initialVideoId: videoId ?? '',
        flags: const YoutubePlayerFlags(
          autoPlay: false,              // تشغيل تلقائي عند فتح الفيديو
          mute: false,                   // كتم الصوت عند البداية
          enableCaption: false,          // إخفاء الترجمة/الشرح (CC)
          hideControls: false,           // إخفاء أزرار التحكم بالكامل
          controlsVisibleAtStart: true,  // إظهار أزرار التحكم عند البداية
          forceHD: false,                // إجبار جودة عالية HD
          disableDragSeek: false,        // منع التقديم والترجيع بالسحب
          hideThumbnail: false,          // إخفاء صورة الفيديو المصغرة
          loop: false,                   // تكرار الفيديو تلقائياً
          isLive: false,                 // وضع البث المباشر
          useHybridComposition: true,    // تحسين الأداء على Android
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
                  ? YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: youtubeController!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.blue,
                        progressColors: ProgressBarColors(
                          playedColor: Colors.blue,
                          handleColor: Colors.blue,
                          bufferedColor: Colors.grey.withOpacity(0.5),
                          backgroundColor: Colors.black26,
                        ),
                        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        bottomActions: [
                          CurrentPosition(),
                          const SizedBox(width: 10),
                          ProgressBar(
                            isExpanded: true,
                            colors: ProgressBarColors(
                              playedColor: Colors.blue,
                              handleColor: Colors.blue,
                              bufferedColor: Colors.grey.withOpacity(0.5),
                              backgroundColor: Colors.black26,
                            ),
                          ),
                          const SizedBox(width: 10),
                          RemainingDuration(),
                          const SizedBox(width: 10),
                          const FullScreenButton(),
                        ],
                      ),
                      builder: (context, player) {
                        return player;
                      },
                    )
                  : Center(child: Text('لا يمكن عرض الفيديو، الرابط غير صحيح')))
              : Center(
                  child: Text(
                      'نوع الفيديو غير مدعوم')), // يمكنك إضافة دعم vimeo لاحقاً
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
