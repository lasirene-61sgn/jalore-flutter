import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/theme.dart';
import '../notifier/gallery_notifier.dart';
import 'video_player_widget.dart';

class ImagesScreenView extends ConsumerStatefulWidget {
  final List<String> images;
  final List<String> videos;
  final String? title;
  const ImagesScreenView({super.key, required this.images, required this.videos, this.title});

  @override
  ConsumerState<ImagesScreenView> createState() => _ImagesScreenViewState();
}

class _ImagesScreenViewState extends ConsumerState<ImagesScreenView> {



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.ssjsSecondaryBlue,
        title:  Text(widget.title ?? ''),
      ),
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {



    final List<Map<String, dynamic>> mediaList = [
      ...widget.images.map((url) => {'url': url, 'isVideo': false}),
      ...widget.videos.map((url) => {'url': url, 'isVideo': true}),
    ];

    if (mediaList.isEmpty) {
      return const Center(child: Text('No media found'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: mediaList.length,
      itemBuilder: (context, index) {
        final media = mediaList[index];

        return _buildGalleryItem(context, media['url'] as String, media['isVideo'] as bool);
      },
    );
  }

  Widget _buildGalleryItem(
      BuildContext context,
      String mediaUrl,
      bool isVideo,
      ) {
    return InkWell(
      onTap: () => _showMediaSlider(context, mediaUrl, isVideo),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundGrey,
          borderRadius: BorderRadius.circular(12), // Slightly smoother corners
          border: Border.all(color: AppTheme.dividerGrey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. The Image Section
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12), bottom: Radius.circular(12)),
                child: mediaUrl.isEmpty
                    ? const Icon(Icons.image, size: 48)
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          if (isVideo)
                            // Placeholder for video (could use a thumbnail if available)
                            Container(
                              color: Colors.black12,
                              child: const Icon(Icons.movie, size: 48, color: Colors.blueGrey),
                            )
                          else
                            Image.network(
                              mediaUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.image),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: CircularProgressIndicator());
                              },
                            ),
                          if (isVideo)
                            const Center(
                              child: Icon(Icons.play_circle_fill, color: Colors.white, size: 48),
                            ),
                        ],
                      ),
              ),
            ),

            // 2. The Title Section at the bottom
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            //   child: Text(
            //     name,
            //     style: const TextStyle(
            //       fontWeight: FontWeight.bold,
            //       fontSize: 14,
            //       overflow: TextOverflow.ellipsis, // Prevents overflow if text is long
            //     ),
            //     textAlign: TextAlign.center,
            //     maxLines: 1,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
  void _showMediaSlider(BuildContext context, String mediaUrl, bool isVideo) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              /// 1️⃣ Media (Image or Video)
              isVideo
                  ? GalleryVideoPlayer(videoUrl: mediaUrl)
                  : Image.network(
                      mediaUrl,
                      fit: BoxFit.contain, // Better for full view
                      errorBuilder: (_, __, ___) => const Padding(
                        padding: EdgeInsets.all(50),
                        child: Icon(Icons.broken_image, size: 50),
                      ),
                    ),

                /// 2️⃣ Gradient Overlay (Optional)
                if (!isVideo)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                /// 3️⃣ Close Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
        );
      },
    );
  }
}
