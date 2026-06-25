import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:webinar/config/colors.dart';

/// ponytail: branded custom controls for the Chewie (direct/offline) video player.
/// The SAME widget is reused inline (vertical) and inside Chewie's landscape
/// fullscreen, so all sizing is driven off the available constraints (small phones
/// -> tablets, portrait -> landscape) — no hardcoded layout that can overflow.
class CustomVideoControls extends StatefulWidget {
  const CustomVideoControls({super.key});

  @override
  State<CustomVideoControls> createState() => _CustomVideoControlsState();
}

class _CustomVideoControlsState extends State<CustomVideoControls> {
  ChewieController? _chewie;
  VideoPlayerController? _vpc;
  bool _visible = true;
  Timer? _hideTimer;

  static const List<double> _speeds = [0.5, 1.0, 1.25, 1.5, 2.0];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final c = ChewieController.of(context);
    if (!identical(c, _chewie)) {
      _vpc?.removeListener(_onTick);
      _chewie = c;
      _vpc = c.videoPlayerController;
      _vpc!.addListener(_onTick);
      _startHideTimer();
    }
  }

  void _onTick() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _vpc?.removeListener(_onTick);
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && (_vpc?.value.isPlaying ?? false)) {
        setState(() => _visible = false);
      }
    });
  }

  void _toggleVisible() {
    setState(() => _visible = !_visible);
    if (_visible) _startHideTimer();
  }

  void _playPause() {
    if (_vpc!.value.isPlaying) {
      _vpc!.pause();
    } else {
      _vpc!.play();
    }
    setState(() => _visible = true);
    _startHideTimer();
  }

  void _seekBy(int seconds) {
    final v = _vpc!.value;
    var target = v.position + Duration(seconds: seconds);
    if (target < Duration.zero) target = Duration.zero;
    if (v.duration > Duration.zero && target > v.duration) target = v.duration;
    _vpc!.seekTo(target);
    setState(() => _visible = true);
    _startHideTimer();
  }

  void _cycleSpeed() {
    final cur = _vpc!.value.playbackSpeed;
    var i = _speeds.indexWhere((s) => (s - cur).abs() < 0.01);
    if (i < 0) i = 1; // default to 1.0x
    _vpc!.setPlaybackSpeed(_speeds[(i + 1) % _speeds.length]);
    setState(() => _visible = true);
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
    final vpc = _vpc, chewie = _chewie;
    if (vpc == null || chewie == null || !vpc.value.isInitialized) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }
    final v = vpc.value;
    final green = green77();

    return LayoutBuilder(
      builder: (context, c) {
        final big = c.maxWidth >= 600; // fullscreen / tablet
        final centerIcon = big ? 60.0 : 46.0;
        final sideIcon = big ? 34.0 : 26.0;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggleVisible,
          onDoubleTapDown: (d) =>
              _seekBy(d.localPosition.dx < c.maxWidth / 2 ? -10 : 10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (v.isBuffering)
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
                            _iconButton(Icons.replay_10, sideIcon, () => _seekBy(-10)),
                            SizedBox(width: big ? 40 : 26),
                            _circleButton(
                              v.isPlaying ? Icons.pause : Icons.play_arrow,
                              centerIcon,
                              _playPause,
                            ),
                            SizedBox(width: big ? 40 : 26),
                            _iconButton(Icons.forward_10, sideIcon, () => _seekBy(10)),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                          child: Row(
                            children: [
                              Text(_fmt(v.position),
                                  style: const TextStyle(color: Colors.white, fontSize: 12)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: VideoProgressIndicator(
                                  vpc,
                                  allowScrubbing: true,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  colors: VideoProgressColors(
                                    playedColor: green,
                                    bufferedColor: Colors.white38,
                                    backgroundColor: Colors.white24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(_fmt(v.duration),
                                  style: const TextStyle(color: Colors.white, fontSize: 12)),
                              const SizedBox(width: 10),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: _cycleSpeed,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white60),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text('${_speedLabel(v.playbackSpeed)}×',
                                      style: const TextStyle(color: Colors.white, fontSize: 12)),
                                ),
                              ),
                              const SizedBox(width: 6),
                              _iconButton(
                                chewie.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                                sideIcon * 0.85,
                                chewie.toggleFullScreen,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
