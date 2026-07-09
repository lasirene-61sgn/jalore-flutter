import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme.dart';
import '../notifier/about_notifier.dart';

class AboutUsScreen extends ConsumerStatefulWidget {
  const AboutUsScreen({super.key});

  @override
  ConsumerState<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends ConsumerState<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(aboutNotifierProvider.notifier).loadAboutUs());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aboutNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: AppTheme.ssjsSecondaryBlue,
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(AboutState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(aboutNotifierProvider.notifier).loadAboutUs(),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.ssjsSecondaryBlue),
                child: const Text('Retry', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    final nullableData = state.data;
    
    final bool isEmpty = nullableData == null || (
      (nullableData.description == null || nullableData.description!.trim().isEmpty) &&
      (nullableData.vision == null || nullableData.vision!.trim().isEmpty) &&
      (nullableData.mission == null || nullableData.mission!.trim().isEmpty) &&
      (nullableData.imagePath == null || nullableData.imagePath!.trim().isEmpty)
    );

    if (isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Information about us is coming soon!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final data = state.data!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.imagePath != null && data.imagePath!.isNotEmpty) ...[
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: const EdgeInsets.all(0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        InteractiveViewer(
                          panEnabled: true,
                          minScale: 1.0,
                          maxScale: 4.0,
                          child: Image.network(
                            data.imagePath!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  data.imagePath!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (data.description != null && data.description!.isNotEmpty) ...[
            const Text(
              'About Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.ssjsSecondaryBlue),
            ),
            const SizedBox(height: 8),
            Text(
              data.description!,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
          ],
          if (data.vision != null && data.vision!.isNotEmpty) ...[
            const Text(
              'Our Vision',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.ssjsSecondaryBlue),
            ),
            const SizedBox(height: 8),
            Text(
              data.vision!,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
          ],
          if (data.mission != null && data.mission!.isNotEmpty) ...[
            const Text(
              'Our Mission',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.ssjsSecondaryBlue),
            ),
            const SizedBox(height: 8),
            Text(
              data.mission!,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}
