import 'package:flutter/material.dart';
import 'package:flutter_app/screens/galllery/ui/images_screen_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../config/theme.dart';
import '../notifier/gallery_notifier.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(galleryNotifierProvider.notifier).loadGallery();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(galleryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        title: const Text('Gallery'),
      ),
      body: SafeArea(
        child: _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, GalleryState state) {
    if (state.isLoading && state.galleryList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: Text(state.error!));
    }

    if (state.galleryList.isEmpty) {
      return const Center(child: Text('No images found'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: state.galleryList.length,
      itemBuilder: (context, index) {
        final gallery = state.galleryList[index];

        final String imageUrl = gallery.imagePathsurls.isNotEmpty
            ? gallery.imagePathsurls.first
            : '';

        return _buildGalleryItem(context, gallery.imagePathsurls, gallery.videoPathsurls, imageUrl, gallery.title);
      },

    );
  }

  Widget _buildGalleryItem(
      BuildContext context,
      List<String> images,
      List<String> videos,
      String imageUrl,
      String name, // This is your title
      ) {
    return InkWell(
      // onTap: () => _showImageSlider(context, images),
      onTap: (){
        navigator?.push(
          MaterialPageRoute(
            builder: (context) => ImagesScreenView(images: images, videos: videos, title: name,),
          ),
        );
      },
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: imageUrl.isEmpty
                    ? const Icon(Icons.image, size: 48)
                    : Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),

            // 2. The Title Section at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis, // Prevents overflow if text is long
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showImageSlider(BuildContext context, List<String> images) {
    final PageController controller = PageController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              // Removes default padding around the dialog
              insetPadding: const EdgeInsets.all(16),
              // Clips the image to the dialog corners
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6, // Adjust height as needed
                width: double.infinity,
                child: Stack(
                  children: [
                    // 1. Background Image Slider (Fills everything)
                    PageView.builder(
                      controller: controller,
                      onPageChanged: (index) => setState(() {}),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          images[index],
                          fit: BoxFit.cover, // Makes image cover full area
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.broken_image, size: 50),
                          ),
                        );
                      },
                    ),

                    // 2. Gradient Overlay (Optional: makes dots/close button visible on bright images)
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
                            colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                          ),
                        ),
                      ),
                    ),

                    // 3. Dots Indicator (Floating on top of image)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(images.length, (index) {
                          bool isActive = false;
                          if (controller.hasClients) {
                            isActive = controller.page?.round() == index;
                          } else {
                            isActive = index == 0;
                          }

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: isActive ? 24 : 8,
                            decoration: BoxDecoration(
                              color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                if (isActive)
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                  )
                              ],
                            ),
                          );
                        }),
                      ),
                    ),

                    // 4. Close Button (Floating on top)
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
              ),
            );
          },
        );
      },
    );
  }

}
