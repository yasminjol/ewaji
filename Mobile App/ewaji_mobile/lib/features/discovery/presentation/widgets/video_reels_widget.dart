import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/provider.dart';

class VideoReelsWidget extends StatefulWidget {
  const VideoReelsWidget({
    super.key,
    required this.videoReels,
    required this.isLoading,
  });

  final List<VideoReel> videoReels;
  final bool isLoading;

  @override
  State<VideoReelsWidget> createState() => _VideoReelsWidgetState();
}

class _VideoReelsWidgetState extends State<VideoReelsWidget> {
  PageController? _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.videoReels.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No video reels available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemCount: widget.videoReels.length,
      itemBuilder: (context, index) {
        final reel = widget.videoReels[index];
        return VideoReelPlayer(
          videoReel: reel,
          isCurrentReel: index == _currentIndex,
        );
      },
    );
  }
}

class VideoReelPlayer extends StatefulWidget {
  const VideoReelPlayer({
    super.key,
    required this.videoReel,
    required this.isCurrentReel,
  });

  final VideoReel videoReel;
  final bool isCurrentReel;

  @override
  State<VideoReelPlayer> createState() => _VideoReelPlayerState();
}

class _VideoReelPlayerState extends State<VideoReelPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    if (widget.isCurrentReel) {
      _initializeVideo();
    }
  }

  @override
  void didUpdateWidget(VideoReelPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrentReel && !oldWidget.isCurrentReel) {
      _initializeVideo();
    } else if (!widget.isCurrentReel && oldWidget.isCurrentReel) {
      _disposeVideo();
    }
  }

  @override
  void dispose() {
    _disposeVideo();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoReel.videoUrl),
      );

      await _videoController!.initialize();

      if (mounted) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: true,
          looping: true, // TikTok-style looping as per requirements
          aspectRatio: 9 / 16, // Vertical video aspect ratio
          showControls: false, // Hide controls for TikTok-style experience
          allowFullScreen: false,
          allowMuting: true,
          placeholder: Container(
            color: Colors.black,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: widget.videoReel.thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(
                  Icons.video_library_outlined,
                  color: Colors.white,
                  size: 64,
                ),
              ),
            ),
          ),
        );

        setState(() {
          _isInitialized = true;
          _hasError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isInitialized = false;
        });
      }
    }
  }

  void _disposeVideo() {
    _chewieController?.dispose();
    _videoController?.dispose();
    _chewieController = null;
    _videoController = null;
    _isInitialized = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video player
          if (_isInitialized && _chewieController != null)
            Center(
              child: Chewie(controller: _chewieController!),
            )
          else if (_hasError)
            _buildErrorWidget()
          else
            _buildLoadingWidget(),

          // Overlay with video info and actions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildVideoOverlay(),
          ),

          // Video controls (tap to pause/play)
          if (_isInitialized)
            GestureDetector(
              onTap: () {
                if (_videoController!.value.isPlaying) {
                  _videoController!.pause();
                } else {
                  _videoController!.play();
                }
              },
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'Error loading video',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _initializeVideo,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Thumbnail as background
          CachedNetworkImage(
            imageUrl: widget.videoReel.thumbnailUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.grey[900]),
            errorWidget: (context, url, error) => Container(color: Colors.grey[900]),
          ),
          // Loading indicator
          const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Video info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.videoReel.title != null) ...[
                  Text(
                    widget.videoReel.title!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                if (widget.videoReel.description != null) ...[
                  Text(
                    widget.videoReel.description!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                ],
                // Video stats
                Row(
                  children: [
                    const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.videoReel.views}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.videoReel.duration.inSeconds}s',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Like button
              GestureDetector(
                onTap: () {
                  // Handle like action
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.videoReel.likes}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Share button
              GestureDetector(
                onTap: () {
                  // Handle share action
                },
                child: const Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(height: 16),

              // More options
              GestureDetector(
                onTap: () {
                  // Show more options
                },
                child: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
