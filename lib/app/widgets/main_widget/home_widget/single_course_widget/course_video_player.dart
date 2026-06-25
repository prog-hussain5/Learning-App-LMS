import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
// import 'package:webinar/app/widgets/main_widget/home_widget/single_course_widget/custom_video_controls.dart'; // unused
import 'package:webinar/common/utils/download_manager.dart';
import 'package:webinar/config/assets.dart';
import 'package:webinar/config/colors.dart';

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
  bool _hasController = false;  // ponytail: controller may never be assigned (missing local file)

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
    if(_hasController) controller.dispose();  // ponytail: guard — controller may be unassigned
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
      print(Uri.parse(widget.url));
      controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      )..initialize().then((_) {
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
        });
    } else {
      String directory = (await getApplicationSupportDirectory()).path;
      print('${directory.toString()}/${widget.localFileName}');

      bool isExistFile = await DownloadManager.findFile(
          directory, widget.localFileName!,
          isOpen: false);

      if (isExistFile) {
        controller = VideoPlayerController.file(
          File('${directory.toString()}/${widget.localFileName}'),
        )..initialize().then((_) {
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
          });
      }
    }
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
