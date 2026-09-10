import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPostWidget extends StatefulWidget {
  final String videoPath;
  const VideoPostWidget({super.key, required this.videoPath});

  @override
  State<VideoPostWidget> createState() => _VideoPostWidgetState();
}

class _VideoPostWidgetState extends State<VideoPostWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                VideoPlayer(_controller),
                VideoProgressIndicator(_controller, allowScrubbing: true),
                Center(
                  child: IconButton(
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      size: 50,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        : Container(
            height: 200,
            color: Colors.black12,
            child: const Center(child: CircularProgressIndicator()),
          );
  }
}