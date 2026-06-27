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
  bool _isFullScreen = false;

  @override
  void initState() {
    if (widget.type == 'youtube') {
      final videoId = YoutubePlayer.convertUrlToId(widget.url);
      youtubeController = YoutubePlayerController(
        initialVideoId: videoId ?? '',
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: false,
          hideControls: false,
          controlsVisibleAtStart: true,
          forceHD: false,
          disableDragSeek: false,
          hideThumbnail: false,
          loop: false,
          isLive: false,
          useHybridComposition: true,
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
  void didPushNext() {
    if (_isFullScreen) return;
    try {
      if (youtubeController == null || youtubeController!.value.isFullScreen) {
        return;
      }
      youtubeController?.pause();
    } catch (_) {}
  }

  void _openFullScreen() async {
    if (youtubeController == null) return;
    _isFullScreen = true;
    final currentPos = youtubeController!.value.position;
    final videoId = YoutubePlayer.convertUrlToId(widget.url) ?? '';
    
    youtubeController!.pause();

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenVideoPlayer(
          videoId: videoId,
          startAt: currentPos.inSeconds,
        ),
      ),
    );

    _isFullScreen = false;
    
    if (result != null && result is Duration) {
      youtubeController!.seekTo(result);
    }
    
    // إعادة بناء الواجهة بعد العودة وتأكيد الوضع العمودي
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    if (mounted) {
      setState(() {});
    }
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
                      progressIndicatorColor: green77(),
                      progressColors: ProgressBarColors(
                        playedColor: green77(),
                        handleColor: green77(),
                        bufferedColor: Colors.grey.withOpacity(0.5),
                        backgroundColor: Colors.black26,
                      ),
                      actionsPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      bottomActions: [
                        CurrentPosition(),
                        const SizedBox(width: 10),
                        ProgressBar(
                          isExpanded: true,
                          colors: ProgressBarColors(
                            playedColor: green77(),
                            handleColor: green77(),
                            bufferedColor: Colors.grey.withOpacity(0.5),
                            backgroundColor: Colors.black26,
                          ),
                        ),
                        const SizedBox(width: 5),
                        RemainingDuration(),
                        const SizedBox(width: 5),
                        const PlaybackSpeedButton(),
                        const SizedBox(width: 5),
                        IconButton(
                          icon: const Icon(Icons.fullscreen,
                              color: Colors.white),
                          onPressed: _openFullScreen,
                        ),
                      ],
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

// Full Screen Video Player Widget
class _FullScreenVideoPlayer extends StatefulWidget {
  final String videoId;
  final int startAt;

  const _FullScreenVideoPlayer({
    required this.videoId,
    required this.startAt,
  });

  @override
  State<_FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<_FullScreenVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        startAt: widget.startAt,
        mute: false,
        enableCaption: false,
        hideControls: false,
        controlsVisibleAtStart: true,
        forceHD: false,
        disableDragSeek: false,
        hideThumbnail: false,
        loop: false,
        isLive: false,
        useHybridComposition: true,
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(_controller.value.position);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: green77(),
            progressColors: ProgressBarColors(
              playedColor: green77(),
              handleColor: green77(),
              bufferedColor: Colors.grey.withOpacity(0.5),
              backgroundColor: Colors.black26,
            ),
            bottomActions: [
              CurrentPosition(),
              const SizedBox(width: 10),
              ProgressBar(
                isExpanded: true,
                colors: ProgressBarColors(
                  playedColor: green77(),
                  handleColor: green77(),
                  bufferedColor: Colors.grey.withOpacity(0.5),
                  backgroundColor: Colors.black26,
                ),
              ),
              const SizedBox(width: 10),
              RemainingDuration(),
              const SizedBox(width: 10),
              const PlaybackSpeedButton(),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                onPressed: () {
                  _onWillPop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
