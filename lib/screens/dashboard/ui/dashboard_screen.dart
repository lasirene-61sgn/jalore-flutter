import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/dashboard/model/banner_model.dart';
import 'package:flutter_app/screens/dashboard/notifier/dashboard_notifier.dart';
import 'package:flutter_app/screens/dashboard/ui/anniversary.dart';
import 'package:flutter_app/screens/dashboard/ui/birthday_screen.dart';
import 'package:flutter_app/screens/matrimoney/ui/matrimony_screen.dart';
import 'package:flutter_app/screens/news/notifier/news_notifier.dart';
import 'package:flutter_app/screens/news/ui/news_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/theme.dart' show AppTheme;
import '../../members/ui/members_screen.dart';
import '../../commitie/ui/committee_screen.dart';
import '../../events/ui/events_screen.dart';
import '../../galllery/ui/gallery_screen.dart';
import '../../helpline/ui/helpline_screen.dart';
import '../../business/ui/business_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
import '../../profile/notifier/profile_notifier.dart';
import '../../profile/ui/profile_edit_screen.dart';
import '../../about/ui/about_us_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileNotifierProvider.notifier).loadProfile();
      ref.read(dashboardNotifierProvider.notifier).loadBirthdays();
      ref.read(dashboardNotifierProvider.notifier).loadBanner();
      ref.read(newsNotifierProvider.notifier).loadNews();
      ref.read(dashboardNotifierProvider.notifier).loadAnniversaries();
      ref.read(dashboardNotifierProvider.notifier).loadNotification();
      ref.read(dashboardNotifierProvider.notifier).loadDashboardCounters();
      ref.read(dashboardNotifierProvider.notifier).loadSocialLinks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardNotifierProvider);
    final newsState = ref.watch(newsNotifierProvider);
    final profileState = ref.watch(profileNotifierProvider);
    final unreadCount = state.notification.where((n) => n.isRead == false).length;
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppTheme.ssjsSecondaryBlue,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: profileState.profile != null
                        ? InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileEditScreen(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: const Color(0xFF1E90FF).withOpacity(0.1),
                                  backgroundImage: profileState.profile!.image != null && profileState.profile!.image!.isNotEmpty
                                      ? NetworkImage(profileState.profile!.image!)
                                      : null,
                                  child: profileState.profile!.image == null || profileState.profile!.image!.isEmpty
                                      ? const Icon(Icons.person, color: Color(0xFF1E90FF))
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Welcome back,',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        (profileState.profile!.labelName != null && profileState.profile!.labelName!.isNotEmpty)
                                            ? profileState.profile!.labelName!
                                            : profileState.profile!.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.chevron_right, color: Colors.black87, size: 28),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Stack(
                      children: [
                        const Icon(
                          Icons.notifications_none_outlined,
                          color: Colors.black87,
                          size: 28,
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                              child: Text(
                                unreadCount.toString(),
                                style: const TextStyle(
                                  color: AppTheme.textDark,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onPressed: () {
                      _showNotifications(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          ),
          Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Header
             if(newsState.newsList.isNotEmpty) const Text(
                'Latest News',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A3B3B),
                ),
              ),
              if(newsState.newsList.isNotEmpty) const SizedBox(height: 12),

              // Running News Ticker
              const RunningNewsTicker(),
              const SizedBox(height: 16),

              // Banner Slider
              const PromotionalBanner(),

              const SizedBox(height: 20),

              // Grid Menu
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  MenuButton(
                    riveIcon: RiveIcon.home,
                    label: 'About Us',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                      );
                    },
                  ),
                  MenuButton(
                    riveIcon: RiveIcon.profile2,
                    label: 'Committee\nMembers',
                    badgeCount: state.counters?.newCommitteeCount,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CommitteeScreen()),
                      );
                    },
                  ),
                  MenuButton(
                    riveIcon: RiveIcon.home2,
                    label: 'Business\nDirectory',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BusinessScreen()),
                      );
                    },
                  ),
                  MenuButton(
                    riveIcon: RiveIcon.profile2,
                    label: 'Matrimony',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MatrimoneyScreen()),
                      );
                    },
                  ),
                  MenuButton(
                    riveIcon: RiveIcon.search,
                    label: 'Find A Member',
                    badgeCount: state.counters?.newCustomerCount,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MembersScreen()),
                      );
                    },
                  ),
                  MenuButton(
                    riveIcon: RiveIcon.timer,
                    label: 'Events',
                    badgeCount: state.counters?.newEventCount,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EventsScreen()),
                      );
                    },
                  ),
                  MenuButton(
                    riveIcon: RiveIcon.gift,
                    label: 'Birthdays',
                    badgeCount: state.todayBirthdayCount,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BirthdayScreen(),
                        ),
                      );
                    },
                  ),
                  MenuButton(
                    riveIcon: RiveIcon.like,
                    label: 'Anniversaries',
                    badgeCount: state.todayAnniversaryCount,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AnniversaryScreen(),
                        ),
                      );
                    },
                  ),
                  MenuButton(
                    riveIcon: RiveIcon.gallery,
                    label: 'Gallery',
                    badgeCount: state.counters?.newGalleryCount,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GalleryScreen()),
                      );
                    },
                  ),
                  MenuButton(
                    riveIcon: RiveIcon.profile2,
                    label: 'HelpLine',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelplineScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
                            
              // Social Media Icons Row
              if (state.socialLinks != null &&
                  (state.socialLinks!.facebookLink != null ||
                   state.socialLinks!.whatsappLink != null ||
                   state.socialLinks!.instagramLink != null ||
                   state.socialLinks!.linkedinLink != null ||
                   state.socialLinks!.emailLink != null ||
                   state.socialLinks!.twitterLink != null)) ...[
                const Center(
                  child: Text(
                    'Connect with us',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Wrap(
                    spacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      if (state.socialLinks!.facebookLink != null && state.socialLinks!.facebookLink!.isNotEmpty)
                        _buildSocialIcon(
                          icon: const FaIcon(FontAwesomeIcons.facebook, color: Color(0xFF1877F2), size: 24),
                          color: const Color(0xFF1877F2),
                          onTap: () => _launchURL(state.socialLinks!.facebookLink!),
                        ),
                      if (state.socialLinks!.whatsappLink != null && state.socialLinks!.whatsappLink!.isNotEmpty)
                        _buildSocialIcon(
                          icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366), size: 24),
                          color: const Color(0xFF25D366),
                          onTap: () {
                            String waLink = state.socialLinks!.whatsappLink!;
                            if (!waLink.startsWith('http')) {
                              if (waLink.length == 10 && !waLink.startsWith('+')) waLink = '91$waLink';
                              waLink = 'https://wa.me/$waLink';
                            }
                            _launchURL(waLink);
                          },
                        ),
                      if (state.socialLinks!.instagramLink != null && state.socialLinks!.instagramLink!.isNotEmpty)
                        _buildSocialIcon(
                          icon: const FaIcon(FontAwesomeIcons.instagram, color: Color(0xFFE4405F), size: 24),
                          color: const Color(0xFFE4405F),
                          onTap: () => _launchURL(state.socialLinks!.instagramLink!),
                        ),
                      if (state.socialLinks!.linkedinLink != null && state.socialLinks!.linkedinLink!.isNotEmpty)
                        _buildSocialIcon(
                          icon: const FaIcon(FontAwesomeIcons.linkedin, color: Color(0xFF0A66C2), size: 24),
                          color: const Color(0xFF0A66C2),
                          onTap: () => _launchURL(state.socialLinks!.linkedinLink!),
                        ),
                      if (state.socialLinks!.twitterLink != null && state.socialLinks!.twitterLink!.isNotEmpty)
                        _buildSocialIcon(
                          icon: const FaIcon(FontAwesomeIcons.xTwitter, color: Colors.black, size: 24),
                          color: Colors.black,
                          onTap: () => _launchURL(state.socialLinks!.twitterLink!),
                        ),
                      if (state.socialLinks!.emailLink != null && state.socialLinks!.emailLink!.isNotEmpty)
                        _buildSocialIcon(
                          icon: const Icon(Icons.email, color: Color(0xFFD44638), size: 24),
                          color: const Color(0xFFD44638),
                          onTap: () => _launchURL('mailto:${state.socialLinks!.emailLink!}'),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ],
          ),
        ),
      ),
            ),
          ],
        ),
    );
  }

  Widget _buildSocialIcon({required Widget icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }


  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  void _showNotifications(BuildContext context) {
    final state = ref.watch(dashboardNotifierProvider);
    final unreadCount = state.notification
        .where((n) => n.isRead == false)
        .length;


    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.ssjsSecondaryBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.notifications, color: AppTheme.textDark),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Notifications',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (unreadCount > 0)
              TextButton(
                onPressed: () async {
                  await ref
                      .read(dashboardNotifierProvider.notifier)
                      .loadNotificationPost();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All notifications marked as read'),
                      backgroundColor: Color(0xFF1E90FF),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  'Mark all read',
                  style: TextStyle(fontSize: 12, color: Color(0xFF1E90FF)),
                ),
              ),
          ],
        ),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: double.maxFinite,
          child: state.isSaving && state.notification.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : state.notification.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No notifications',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.notification.length,
                  itemBuilder: (context, index) {
                    final notification = state.notification[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening: ${notification.title}'),
                            backgroundColor: const Color(0xFF1E90FF),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);

                          if(notification.type == "event" ||notification.type == "event_added") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EventsScreen(),
                              ),
                            );
                          }else if(notification.type == "news" ||notification.type == "news_added") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewsScreen(),
                              ),
                            );
                          }
                          else if(notification.type == "gallery_added"  ||notification.type == "gallery") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GalleryScreen(),
                              ),
                            );
                          }
                          // else if(notification.type == "birthday"  ||notification.type == "birthday_added") {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => const GalleryScreen(),
                          //     ),
                          //   );
                          // }
                          await ref.read(dashboardNotifierProvider.notifier).loadSingleNotificationPost(notification.id.toString());

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                // notification['isRead'] as bool
                                //     ?
                                Colors.white,
                            // : const Color(0xFF1E90FF).withValues(alpha: 0.05),
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[200]!),
                            ),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: notification.type == "event" ||
                                    notification.type == "event_added"
                                    ? Color(0xFF4CAF50)
                                    : notification.type == "gallery" ||
                                  notification.type == "gallery_added"
                                    ? Color(0xFF2196F3)
                                    : notification.type == "news" ||
                                    notification.type == "news_added"
                                    ? Color(0xFF4CAF50)
                                    : notification.type == "anniversary" ||
                                    notification.type == "anniversary_added"
                                    ? Color(0xFFE91E63)
                                    : notification.type == "birthday"||
                                   notification.type == "birthday_added"
                                    ? Color(0xFF9C27B0)
                                    : null,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                notification.type == "event" ||
                                    notification.type == "event_added"
                                    ? Icons.event
                                    : notification.type == "gallery" ||
                                    notification.type == "gallery_added"
                                    ? Icons.photo_library
                                    : notification.type == "news" ||
                                    notification.type == "news_added"
                                    ? Icons.newspaper
                                    : notification.type == "anniversary" ||
                                    notification.type == "anniversary_added"
                                    ? Icons.favorite
                                    : notification.type == "birthday" ||
                                    notification.type == "birthday_added"
                                    ? Icons.celebration
                                    : null,
                                color: AppTheme.textDark,
                                size: 24,
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    notification.title,
                                    style: TextStyle(
                                      fontWeight:
                                          // notification['isRead'] as bool
                                          //     ?
                                          FontWeight.normal,
                                      // : FontWeight.bold
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                // if (!(notification['isRead'] as bool))
                                //   Container(
                                //     width: 8,
                                //     height: 8,
                                //     decoration: const BoxDecoration(
                                //       color: Color(0xFF1E90FF),
                                //       shape: BoxShape.circle,
                                //     ),
                                //   ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  notification.message.toString(),
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notification.createdAt.toString(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// Custom Widget for the Gradient Menu Buttons
class MenuButton extends StatefulWidget {
  final RiveIcon riveIcon;
  final String label;
  final VoidCallback onTap;
  final int? badgeCount;

  const MenuButton({
    super.key,
    required this.riveIcon,
    required this.label,
    required this.onTap,
    this.badgeCount,
  });

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.15),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(20),
        child: IgnorePointer(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  color: AppTheme.ssjsSecondaryBlue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideTransition(
                      position: _floatAnimation,
                      child: RiveAnimatedIcon(
                        riveIcon: widget.riveIcon,
                        width: 48,
                        height: 48,
                        color: Colors.white,
                        strokeWidth: 2,
                        loopAnimation: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.badgeCount != null && widget.badgeCount! > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      widget.badgeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PromotionalBanner extends ConsumerStatefulWidget {
  const PromotionalBanner({super.key});

  @override
  ConsumerState<PromotionalBanner> createState() => _PromotionalBannerState();
}

class _PromotionalBannerState extends ConsumerState<PromotionalBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final state = ref.read(dashboardNotifierProvider);
      final banners = state.banners;

      if (banners.isEmpty || !_pageController.hasClients) return;

      final nextPage = (_currentPage + 1) % banners.length;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

      setState(() => _currentPage = nextPage);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardNotifierProvider);
    final banners = state.banners;

    if (state.isLoading && banners.isEmpty) {
      return const Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (banners.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: banners.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return _buildBannerCard(banners[index]);
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? const Color(0xFF1E90FF)
                    : Colors.grey[300],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCard(BannerModel banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          banner.imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            );
          },
          errorBuilder: (_, __, ___) {
            return const Center(child: Icon(Icons.broken_image, size: 40));
          },
        ),
      ),
    );
  }
}

class RunningNewsTicker extends ConsumerStatefulWidget {
  const RunningNewsTicker({super.key});

  @override
  ConsumerState<RunningNewsTicker> createState() => _RunningNewsTickerState();
}

class _RunningNewsTickerState extends ConsumerState<RunningNewsTicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  final List<String> _newsItems = [
    '📢 Welcome to Shri Jalore Jain Sangh Chennai',
    '🎉 Annual General Meeting on 15th December 2024',
    '🌟 New member registrations are now open',
    '📅 Upcoming Diwali celebration on 20th December',
    '💼 Business networking event next month',
    '🎊 Cultural program registrations open',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _animation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newsNotifierProvider);
    final newsText = state.newsList.map((news) => news.title).join('   •   ');

    return newsText.isEmpty
        ? SizedBox()
        : Container(
            height: 40,
            decoration: BoxDecoration(
              // Change color to transparent or a neutral color to remove blue
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade300,
              ), // Optional border for visibility
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  // Animated scrolling text
                  SlideTransition(
                    position: _animation,
                    child: Row(
                      children: [
                        _buildNewsText(newsText),
                        // _buildNewsText(newsText),
                      ],
                    ),
                  ),

                  // ✅ REMOVED: Left fade gradient Positioned widget
                  // ✅ REMOVED: Right fade gradient Positioned widget

                  // "LATEST" badge
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.ssjsSecondaryBlue,
                        // Changed to match your theme
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'LATEST',
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildNewsText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black87, // Changed from white to black for contrast
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Simple painter to create the geometric shape background in the banner
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade100
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);

    // Decorative background only (simplified)
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
