import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
// import 'package:webinar/app/widgets/main_widget/home_widget/single_course_widget/custom_video_controls.dart'; // unused
import 'package:webinar/common/components.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/common/utils/download_manager.dart';
import 'package:webinar/config/assets.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/config/styles.dart';

import '../../../../../common/common.dart';

class CourseVideoPlayer extends StatefulWidget {
  final String url;
  final String imageCover;

  final bool isLoadNetwork;
  final String? localFileName;
  final RouteObserver<ModalRoute<void>> routeObserver;

  const CourseVideoPlayer(this.url, this.imageCover, this.routeObserver,
      {this.isLoadNetwork = true, this.localFileName, super.key});

  @override
  State<CourseVideoPlayer> createState() => _CourseVideoPlayerState();
}

class _CourseVideoPlayerState extends State<CourseVideoPlayer> with RouteAware {
  late VideoPlayerController controller;
  ChewieController? chewieController;
  bool _hasController = false;  // ponytail: controller finished initializing (safe to pause/play)
  bool _controllerCreated = false;  // ponytail: controller object exists -> dispose must free it
  bool _hasError = false;  // ponytail: init failed / no file -> show retry instead of a forever spinner

  bool isShowVideoPlayer = false;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    chewieController?.dispose();
    // ponytail: free the controller whenever it was CREATED (not only when init finished),
    // otherwise leaving a lecture mid-initialize leaks the player.
    if(_controllerCreated) controller.dispose();
    super.dispose();
  }

  @override
  void didPush() {}

  @override
  void didPushNext() {
    if(_hasController) controller.pause();
  }

  @override
  void didPopNext() {
    if(_hasController) controller.play();
  }

  initVideo() async {
    if (widget.isLoadNetwork) {
      // ponytail: no url -> fail fast instead of spinning forever on Uri.parse('')
      if (widget.url.trim().isEmpty) {
        if (mounted) setState(() => _hasError = true);
        return;
      }
      _controllerCreated = true;
      controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      )..initialize().then((_) {
          // ponytail: page may be gone before init completes
          if (!mounted) return;
          isShowVideoPlayer = true;
          _hasController = true;

          // Initialize Chewie with fullscreen support
          chewieController = ChewieController(
            videoPlayerController: controller,
            autoPlay: true,
            looping: false,
            showControls: true,
            allowFullScreen: true,
            allowMuting: true,
            showControlsOnInitialize: true,
            autoInitialize: true,
            useRootNavigator: true,
            materialProgressColors: ChewieProgressColors(
              playedColor: green77(),
              handleColor: green77(),
              backgroundColor: Colors.grey,
              bufferedColor: Colors.grey.withOpacity(0.5),
            ),
            cupertinoProgressColors: ChewieProgressColors(
              playedColor: green77(),
              handleColor: green77(),
              backgroundColor: Colors.grey,
              bufferedColor: Colors.grey.withOpacity(0.5),
            ),
            deviceOrientationsAfterFullScreen: [
              DeviceOrientation.portraitUp,
            ],
            deviceOrientationsOnEnterFullScreen: [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ],
            systemOverlaysAfterFullScreen: SystemUiOverlay.values,
            systemOverlaysOnEnterFullScreen: [],
          );

          setState(() {});
        }).catchError((e) {
          // ponytail: bad/expired/unplayable url -> show retry, never spin forever
          if (mounted) setState(() => _hasError = true);
        });
    } else {
      String directory = (await getApplicationSupportDirectory()).path;

      bool isExistFile = await DownloadManager.findFile(
          directory, widget.localFileName ?? '',
          isOpen: false);

      if (isExistFile) {
        _controllerCreated = true;
        controller = VideoPlayerController.file(
          File('${directory.toString()}/${widget.localFileName}'),
        )..initialize().then((_) {
            if (!mounted) return;
            isShowVideoPlayer = true;
          _hasController = true;

            // Initialize Chewie with fullscreen support
            chewieController = ChewieController(
              videoPlayerController: controller,
              autoPlay: true,
              looping: false,
              showControls: true,
              allowFullScreen: true,
              allowMuting: true,
              showControlsOnInitialize: true,
              autoInitialize: true,
              useRootNavigator: true,
              materialProgressColors: ChewieProgressColors(
                playedColor: green77(),
                handleColor: green77(),
                backgroundColor: Colors.grey,
                bufferedColor: Colors.grey.withOpacity(0.5),
              ),
              cupertinoProgressColors: ChewieProgressColors(
                playedColor: green77(),
                handleColor: green77(),
                backgroundColor: Colors.grey,
                bufferedColor: Colors.grey.withOpacity(0.5),
              ),
              deviceOrientationsAfterFullScreen: [
                DeviceOrientation.portraitUp,
              ],
              deviceOrientationsOnEnterFullScreen: [
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ],
              systemOverlaysAfterFullScreen: SystemUiOverlay.values,
              systemOverlaysOnEnterFullScreen: [],
            );

            setState(() {});
          }).catchError((e) {
            if (mounted) setState(() => _hasError = true);
          });
      } else {
        // ponytail: downloaded file is missing -> tell the user instead of a blank box
        if (mounted) setState(() => _hasError = true);
      }
    }
  }

  // ponytail: retry a failed video init
  void _retryVideo() {
    setState(() {
      _hasError = false;
      isShowVideoPlayer = false;
    });
    initVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // video
        if (isShowVideoPlayer && chewieController != null) ...{
          Container(
            width: getSize().width,
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: Chewie(
                controller: chewieController!,
              ),
            ),
          ),
          space(12),
        } else if (_hasError) ...{
          // ponytail: video failed to load -> message + retry (never a forever spinner)
          Container(
            width: getSize().width,
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: borderRadius(),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.black87,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white70, size: 34),
                      space(8),
                      Padding(
                        padding: padding(horizontal: 16),
                        child: Text(
                          appText.serverExceptionError,
                          style: style12Regular().copyWith(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      space(10),
                      button(
                        onTap: _retryVideo,
                        width: 140,
                        height: 40,
                        text: appText.retry,
                        bgColor: green77(),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          space(12),
        } else if (!isShowVideoPlayer) ...{
          // Loading placeholder
          Container(
            width: getSize().width,
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: borderRadius(),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.imageCover,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AppAssets.placePng,
                          width: getSize().width,
                          height: getSize().width,
                        );
                      },
                    ),
                    // ponytail: buffering feedback while the video initializes
                    Container(color: Colors.black26),
                    Center(child: CircularProgressIndicator(color: green77())),
                  ],
                ),
              ),
            ),
          ),
          space(12),
        },
      ],
    );
  }
}
