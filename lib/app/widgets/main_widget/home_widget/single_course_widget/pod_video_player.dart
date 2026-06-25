import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/config/colors.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// YouTube lecture player.
/// ponytail: moved off youtube_player_flutter to youtube_player_iframe (already a
/// dependency) so we can hide ALL native YouTube UI (share button, logo, "watch on
/// YouTube") with showControls:false, and set pointerEvents:none so the embed ignores
/// touches — that blocks the copy-URL context menu AND lets our own overlay own every
/// gesture. Controls + fullscreen are branded and identical to the uploaded-video player.
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
  State<PodVideoPlayerDev> createState() => _PodVideoPlayerDevState();
}

class _PodVideoPlayerDevState extends State<PodVideoPlayerDev>
    with RouteAware, AutomaticKeepAliveClientMixin {
  YoutubePlayerController? _controller;
  String? _videoId;
  String _coverUrl = '';

  @override
  void initState() {
    super.initState();
    if (widget.type == 'youtube') {
      _videoId = YoutubePlayerController.convertUrlToId(widget.url) ??
          (widget.url.trim().length == 11 ? widget.url.trim() : null);

      if (_videoId != null) {
        // ponytail: plain YouTube thumbnail used as a cover so the embed's own
        // cued UI (title bar + center YouTube play button) is never shown.
        _coverUrl = 'https://i.ytimg.com/vi/$_videoId/hqdefault.jpg';
        _controller = YoutubePlayerController.fromVideoId(
          videoId: _videoId!,
          autoPlay: false, // cue only — don't force a full download on mount (faster load)
          params: const YoutubePlayerParams(
            showControls: false, // no native YouTube controls -> no share / logo / "watch on youtube"
            showFullscreenButton: false,
            showVideoAnnotations: false,
            enableCaption: false,
            strictRelatedVideos: true, // no related-video spam on the end screen
            // NOTE: pointerEvents:none was removed — it broke the IFrame player's
            // init so playVideo() never started. The copy-URL menu is instead
            // blocked by an onLongPress absorber on the controls overlay below.
          ),
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    _controller?.close();
    super.dispose();
  }

  @override
  void didPushNext() {
    // pause when the student navigates away from the lecture
    try {
      _controller?.pauseVideo();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.type != 'youtube') {
      return const Center(child: Text('نوع الفيديو غير مدعوم'));
    }
    if (_controller == null) {
      return const Center(child: Text('لا يمكن عرض الفيديو، الرابط غير صحيح'));
    }

    return Padding(
      key: widget.key,
      padding: padding(horizontal: 0),
      child: ClipRRect(
        borderRadius: borderRadius(),
        child: YoutubePlayerScaffold(
          controller: _controller!,
          aspectRatio: 16 / 9,
          builder: (context, player) {
            return Stack(
              children: [
                player,
                Positioned.fill(child: _YoutubeControls(_controller!, _coverUrl)),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/// Branded custom controls overlaid on the (touch-disabled) YouTube embed.
/// Mirrors CustomVideoControls (the uploaded-video player) so both players feel identical.
class _YoutubeControls extends StatefulWidget {
  final YoutubePlayerController controller;
  final String coverUrl;
  const _YoutubeControls(this.controller, this.coverUrl);

  @override
  State<_YoutubeControls> createState() => _YoutubeControlsState();
}

class _YoutubeControlsState extends State<_YoutubeControls> {
  bool _visible = true;
  Timer? _hideTimer;
  StreamSubscription<YoutubePlayerValue>? _valueSub;

  bool _isPlaying = false;
  bool _isBuffering = false;
  bool _isFullScreen = false;
  bool _hasStarted = false; // hide the cover once playback actually begins
  double _speed = 1.0;
  Duration _duration = Duration.zero;

  static const List<double> _speeds = [0.5, 1.0, 1.25, 1.5, 2.0];

  YoutubePlayerController get c => widget.controller;

  @override
  void initState() {
    super.initState();
    _valueSub = c.listen(_onValue);
    _startHideTimer();
  }

  void _onValue(YoutubePlayerValue v) {
    if (!mounted) return;
    final playing = v.playerState == PlayerState.playing;
    final buffering = v.playerState == PlayerState.buffering;
    final fs = v.fullScreenOption.enabled;
    final dur = v.metaData.duration;
    if (playing != _isPlaying ||
        buffering != _isBuffering ||
        fs != _isFullScreen ||
        dur != _duration ||
        (playing && !_hasStarted) ||
        (v.playbackRate - _speed).abs() > 0.01) {
      setState(() {
        _isPlaying = playing;
        _isBuffering = buffering;
        _isFullScreen = fs;
        _duration = dur;
        if (playing) _hasStarted = true;
        if (v.playbackRate > 0) _speed = v.playbackRate;
      });
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _valueSub?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) setState(() => _visible = false);
    });
  }

  void _toggleVisible() {
    setState(() => _visible = !_visible);
    if (_visible) _startHideTimer();
  }

  void _playPause() {
    _isPlaying ? c.pauseVideo() : c.playVideo();
    setState(() => _visible = true);
    _startHideTimer();
  }

  // First play from the cover. Hide the cover immediately so the user is never
  // stuck on it even if the player takes a moment to report 'playing'.
  void _startPlayback() {
    c.playVideo();
    setState(() {
      _hasStarted = true;
      _visible = true;
    });
    _startHideTimer();
  }

  void _seekBy(int seconds, Duration current) {
    var target = current + Duration(seconds: seconds);
    if (target < Duration.zero) target = Duration.zero;
    if (_duration > Duration.zero && target > _duration) target = _duration;
    c.seekTo(seconds: target.inMilliseconds / 1000.0, allowSeekAhead: true);
    setState(() => _visible = true);
    _startHideTimer();
  }

  void _cycleSpeed() {
    var i = _speeds.indexWhere((s) => (s - _speed).abs() < 0.01);
    if (i < 0) i = 1;
    final next = _speeds[(i + 1) % _speeds.length];
    c.setPlaybackRate(next);
    setState(() {
      _speed = next;
      _visible = true;
    });
    _startHideTimer();
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours, m = d.inMinutes.remainder(60), s = d.inSeconds.remainder(60);
    return h > 0 ? '${two(h)}:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }

  String _speedLabel(double s) =>
      s == s.roundToDouble() ? s.toInt().toString() : s.toString();

  @override
  Widget build(BuildContext context) {
    final green = green77();

    return StreamBuilder<YoutubeVideoState>(
      stream: c.videoStateStream,
      builder: (context, snap) {
        final pos = snap.data?.position ?? Duration.zero;
        final durMs = _duration.inMilliseconds;
        final progress =
            durMs > 0 ? (pos.inMilliseconds / durMs).clamp(0.0, 1.0) : 0.0;

        return LayoutBuilder(
          builder: (context, cns) {
            final big = cns.maxWidth >= 600; // fullscreen / tablet
            final centerIcon = big ? 60.0 : 46.0;
            final sideIcon = big ? 34.0 : 26.0;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _toggleVisible,
              onLongPress: () {}, // absorb long-press so the WebView copy-URL menu can't open
              onDoubleTapDown: (d) =>
                  _seekBy(d.localPosition.dx < cns.maxWidth / 2 ? -10 : 10, pos),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_isBuffering)
                    const Center(child: CircularProgressIndicator(color: Colors.white)),
                  AnimatedOpacity(
                    opacity: _visible ? 1 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: IgnorePointer(
                      ignoring: !_visible,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                            colors: [Colors.black54, Colors.transparent],
                          ),
                        ),
                        child: Column(
                          children: [
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _iconButton(Icons.replay_10, sideIcon, () => _seekBy(-10, pos)),
                                SizedBox(width: big ? 40 : 26),
                                _circleButton(_isPlaying ? Icons.pause : Icons.play_arrow,
                                    centerIcon, _playPause),
                                SizedBox(width: big ? 40 : 26),
                                _iconButton(Icons.forward_10, sideIcon, () => _seekBy(10, pos)),
                              ],
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                              child: Row(
                                children: [
                                  Text(_fmt(pos),
                                      style: const TextStyle(color: Colors.white, fontSize: 12)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: SliderTheme(
                                      data: SliderThemeData(
                                        trackHeight: 3,
                                        activeTrackColor: green,
                                        inactiveTrackColor: Colors.white24,
                                        thumbColor: green,
                                        overlayColor: green.withOpacity(0.25),
                                        thumbShape:
                                            const RoundSliderThumbShape(enabledThumbRadius: 6),
                                        overlayShape:
                                            const RoundSliderOverlayShape(overlayRadius: 12),
                                      ),
                                      child: Slider(
                                        value: progress,
                                        onChanged: durMs > 0
                                            ? (v) {
                                                c.seekTo(
                                                    seconds: (v * durMs) / 1000.0,
                                                    allowSeekAhead: true);
                                                setState(() => _visible = true);
                                              }
                                            : null,
                                        onChangeEnd: (_) => _startHideTimer(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(_fmt(_duration),
                                      style: const TextStyle(color: Colors.white, fontSize: 12)),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: _cycleSpeed,
                                    child: Container(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white60),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text('${_speedLabel(_speed)}×',
                                          style: const TextStyle(color: Colors.white, fontSize: 12)),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  _iconButton(
                                    _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                                    sideIcon * 0.85,
                                    () => c.toggleFullScreen(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!_hasStarted) _buildCover(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ponytail: opaque cover (plain YT thumbnail + our play button) shown until the
  // first play — hides YouTube's cued thumbnail/title/center-play entirely.
  Widget _buildCover() => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _startPlayback,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (widget.coverUrl.isNotEmpty)
              Image.network(
                widget.coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.black),
              )
            else
              Container(color: Colors.black),
            Container(color: Colors.black26),
            Center(child: _circleButton(Icons.play_arrow, 56, _startPlayback)),
          ],
        ),
      );

  Widget _iconButton(IconData icon, double size, VoidCallback onTap) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white, size: size),
        ),
      );

  Widget _circleButton(IconData icon, double size, VoidCallback onTap) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: size + 18,
          height: size + 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.4),
          ),
          child: Icon(icon, color: Colors.white, size: size),
        ),
      );
}
