import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../models/service_detail.dart';

class MediaCarouselWidget extends StatefulWidget {
  const MediaCarouselWidget({
    super.key,
    required this.mediaItems,
  });

  final List<MediaItem> mediaItems;

  @override
  State<MediaCarouselWidget> createState() => _MediaCarouselWidgetState();
}

class _MediaCarouselWidgetState extends State<MediaCarouselWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.mediaItems.isEmpty) {
      return Container(
        height: 300,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 64,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Main carousel
        carousel.CarouselSlider.builder(
          itemCount: widget.mediaItems.length,
          itemBuilder: (context, index, realIndex) {
            final mediaItem = widget.mediaItems[index];
            return _MediaItemWidget(
              mediaItem: mediaItem,
              isActive: index == _currentIndex,
            );
          },
          options: carousel.CarouselOptions(
            height: 300,
            viewportFraction: 1.0,
            enableInfiniteScroll: widget.mediaItems.length > 1,
            autoPlay: false,
            initialPage: _currentIndex,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),

        // Overlay gradient
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),

        // Media indicators
        if (widget.mediaItems.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.mediaItems.asMap().entries.map((entry) {
                final index = entry.key;
                final mediaItem = entry.value;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  child: Container(
                    width: 32,
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                    ),
                    child: _currentIndex == index && mediaItem.type == MediaType.video
                        ? const Center(
                            child: Icon(
                              Icons.play_circle_filled,
                              color: Colors.white,
                              size: 16,
                            ),
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),

        // Media type indicator
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.mediaItems[_currentIndex].type == MediaType.video
                      ? Icons.videocam
                      : Icons.photo,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_currentIndex + 1}/${widget.mediaItems.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Caption overlay
        if (widget.mediaItems[_currentIndex].caption != null)
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: Text(
              widget.mediaItems[_currentIndex].caption!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

class _MediaItemWidget extends StatefulWidget {
  const _MediaItemWidget({
    required this.mediaItem,
    required this.isActive,
  });

  final MediaItem mediaItem;
  final bool isActive;

  @override
  State<_MediaItemWidget> createState() => _MediaItemWidgetState();
}

class _MediaItemWidgetState extends State<_MediaItemWidget> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.mediaItem.type == MediaType.video && widget.isActive) {
      _initializeVideo();
    }
  }

  @override
  void didUpdateWidget(_MediaItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mediaItem.type == MediaType.video) {
      if (widget.isActive && !oldWidget.isActive) {
        _initializeVideo();
      } else if (!widget.isActive && oldWidget.isActive) {
        _disposeVideo();
      }
    }
  }

  @override
  void dispose() {
    _disposeVideo();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    if (_videoController != null) return;

    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.mediaItem.url),
      );

      await _videoController!.initialize();

      if (mounted) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: false,
          looping: false,
          aspectRatio: _videoController!.value.aspectRatio,
          allowFullScreen: true,
          placeholder: widget.mediaItem.thumbnailUrl != null
              ? CachedNetworkImage(
                  imageUrl: widget.mediaItem.thumbnailUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                )
              : Container(color: Colors.black),
        );

        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  void _disposeVideo() {
    _chewieController?.dispose();
    _videoController?.dispose();
    _chewieController = null;
    _videoController = null;
    _isVideoInitialized = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaItem.type == MediaType.image) {
      return _buildImageWidget();
    } else {
      return _buildVideoWidget();
    }
  }

  Widget _buildImageWidget() {
    return CachedNetworkImage(
      imageUrl: widget.mediaItem.url,
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: (context, url) => Container(
        color: Colors.grey[300],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(
            Icons.broken_image,
            size: 64,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildVideoWidget() {
    if (!widget.isActive || !_isVideoInitialized || _chewieController == null) {
      // Show thumbnail or loading state
      return Stack(
        fit: StackFit.expand,
        children: [
          if (widget.mediaItem.thumbnailUrl != null)
            CachedNetworkImage(
              imageUrl: widget.mediaItem.thumbnailUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
            )
          else
            Container(color: Colors.black),
          
          // Play button overlay
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),

          // Duration badge
          if (widget.mediaItem.duration != null)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _formatDuration(widget.mediaItem.duration!),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return Chewie(controller: _chewieController!);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
