import 'package:flutter/material.dart';
import '../config/theme.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample gallery images
    final galleryImages = [
      'https://via.placeholder.com/400x300/1A237E/FFFFFF?text=Event+1',
      'https://via.placeholder.com/400x300/1A237E/FFFFFF?text=Event+2',
      'https://via.placeholder.com/400x300/1A237E/FFFFFF?text=Event+3',
      'https://via.placeholder.com/400x300/1A237E/FFFFFF?text=Event+4',
      'https://via.placeholder.com/400x300/1A237E/FFFFFF?text=Event+5',
      'https://via.placeholder.com/400x300/1A237E/FFFFFF?text=Event+6',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: galleryImages.length,
          itemBuilder: (context, index) {
            return _buildGalleryItem(context, galleryImages[index]);
          },
        ),
      ),
    );
  }

  Widget _buildGalleryItem(BuildContext context, String imageUrl) {
    return InkWell(
      onTap: () {
        _showFullImage(context, imageUrl);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundGrey,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.dividerGrey),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(
                  Icons.image,
                  size: 48,
                  color: AppTheme.textGrey,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  color: AppTheme.backgroundGrey,
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 64,
                      color: AppTheme.textGrey,
                    ),
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
