import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/theme.dart';
import '../notifier/helpline_notifier.dart';
import '../model/helpline_model.dart';

class HelplineScreen extends ConsumerStatefulWidget {
  const HelplineScreen({super.key});

  @override
  ConsumerState<HelplineScreen> createState() => _HelplineScreenState();
}

class _HelplineScreenState extends ConsumerState<HelplineScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(helplineNotifierProvider.notifier).loadHelpline();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(helplineNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.ssjsSecondaryBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'HelpLine',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: state.isLoading && state.helplineList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : state.error != null && state.helplineList.isEmpty
                ? Center(child: Text(state.error!))
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: state.helplineList.length,
                    itemBuilder: (context, index) {
                      final category = state.helplineList[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppTheme.ssjsSecondaryBlue,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ExpansionTile(
                          shape: const RoundedRectangleBorder(
                            side: BorderSide.none,
                          ),
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          title: Text(
                            category.name.toUpperCase(),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                          ),
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: category.headings.map((helpline) {
                                  return Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    color: Colors.white,
                                    child: ExpansionTile(
                                      shape: const RoundedRectangleBorder(
                                        side: BorderSide.none,
                                      ),
                                      iconColor: AppTheme.ssjsPrimaryBlue,
                                      collapsedIconColor: AppTheme.ssjsPrimaryBlue,
                                      title: Text(
                                        helpline.headingName,
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              color: AppTheme.ssjsPrimaryBlue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      subtitle: helpline.name.isNotEmpty
                                          ? Text(
                                              helpline.name,
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    color: AppTheme.textGrey,
                                                  ),
                                            )
                                          : null,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          child: _buildDynamicContacts(context, helpline),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildDynamicContacts(BuildContext context, HelplineModel helpline) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (helpline.mobileNumbers.isNotEmpty)
              _buildContactSection(
                context,
                title: 'Mobile',
                items: helpline.mobileNumbers,
                icon: Icons.phone,
              ),
            if (helpline.whatsappNumbers.isNotEmpty)
              _buildContactSection(
                context,
                title: 'WhatsApp',
                items: helpline.whatsappNumbers,
                icon: Icons.chat,
                isWhatsapp: true,
              ),
            if (helpline.emails.isNotEmpty)
              _buildContactSection(
                context,
                title: 'Email',
                items: helpline.emails,
                icon: Icons.email,
                isEmail: true,
              ),
            if (helpline.locations.isNotEmpty)
              _buildContactSection(
                context,
                title: 'Location',
                items: helpline.locations,
                icon: Icons.location_on,
                isLocation: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(
    BuildContext context, {
    required String title,
    required List<String> items,
    required IconData icon,
    bool isWhatsapp = false,
    bool isEmail = false,
    bool isLocation = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textGrey,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...items.map((value) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: AppTheme.ssjsPrimaryBlue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.ssjsPrimaryBlue,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isEmail
                          ? Icons.alternate_email
                          : (isLocation
                              ? Icons.map
                              : (isWhatsapp ? Icons.chat : Icons.phone_in_talk)),
                      size: 20,
                    ),
                    color: AppTheme.ssjsPrimaryBlue,
                    onPressed: () {
                      if (isEmail) {
                        _launchUrl('mailto:$value');
                      } else if (isWhatsapp) {
                        _launchUrl('https://wa.me/$value');
                      } else if (isLocation) {
                        _launchUrl(
                            'https://www.google.com/maps/search/?api=1&query=$value');
                      } else {
                        _launchUrl('tel:$value');
                      }
                    },
                  ),
                ],
              ),
            )),
        const Divider(height: 1),
      ],
    );
  }


  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}
