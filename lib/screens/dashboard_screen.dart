import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/member.dart';
import 'members_screen.dart';
import 'committee_screen.dart';
import 'events_screen.dart';
import 'gallery_screen.dart';
import 'helpline_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Member> _birthdayMembers = [];
  List<Member> _anniversaryMembers = [];

  @override
  void initState() {
    super.initState();
    _loadBirthdaysAndAnniversaries();
  }

  Future<void> _loadBirthdaysAndAnniversaries() async {
    try {
      final allMembers = await DataService.getAllMembers();
      final now = DateTime.now();
      
      // Filter members with birthdays this month
      final birthdayMembers = allMembers.where((member) {
        if (member.dateOfBirth == null) return false;
        return member.dateOfBirth!.month == now.month;
      }).toList();
      
      // Filter members with anniversaries this month
      final anniversaryMembers = allMembers.where((member) {
        if (member.dateOfAnniversary == null) return false;
        return member.dateOfAnniversary!.month == now.month;
      }).toList();
      
      setState(() {
        _birthdayMembers = birthdayMembers;
        _anniversaryMembers = anniversaryMembers;
      });
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.black87, size: 28),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.person_outline, color: Colors.black87),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              const Text(
                'Latest News',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A3B3B),
                ),
              ),
              const SizedBox(height: 12),

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
                    icon: Icons.groups_rounded,
                    label: 'Find A Member',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MembersScreen()),
                      );
                    },
                  ),
                  MenuButton(
                    icon: Icons.receipt_long_rounded,
                    label: 'Events',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EventsScreen()),
                      );
                    },
                  ),
                  MenuButton(
                    icon: Icons.people_alt_rounded,
                    label: 'Committee\nMembers',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CommitteeScreen()),
                      );
                    },
                  ),
                  MenuButton(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GalleryScreen()),
                      );
                    },
                  ),
                  MenuButton(
                    icon: Icons.cake_rounded,
                    label: 'Today\'s\nBirthday',
                    onTap: () {
                      _showTodayBirthdays(context);
                    },
                  ),
                  MenuButton(
                    icon: Icons.favorite_rounded,
                    label: 'Today\'s\nAnniversary',
                    onTap: () {
                      _showTodayAnniversaries(context);
                    },
                  ),
                  MenuButton(
                    icon: Icons.description_rounded,
                    label: 'Byelaws of\nSangh',
                    onTap: () {
                      _showByelaws(context);
                    },
                  ),
                  MenuButton(
                    icon: Icons.support_agent_rounded,
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
            ],
          ),
        ),
      ),
    );
  }

  void _showTodayBirthdays(BuildContext context) {
    final now = DateTime.now();
    final todayBirthdays = _birthdayMembers.where((member) {
      if (member.dateOfBirth == null) return false;
      return member.dateOfBirth!.day == now.day && 
             member.dateOfBirth!.month == now.month;
    }).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.cake, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text('Today\'s Birthdays'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: todayBirthdays.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No birthdays today',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: todayBirthdays.length,
                  itemBuilder: (context, index) {
                    final member = todayBirthdays[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.cake, color: Colors.white, size: 20),
                        ),
                        title: Text(
                          member.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(member.mobile),
                        trailing: IconButton(
                          icon: const Icon(Icons.phone, color: Color(0xFFFF6B9D)),
                          onPressed: () {
                            // Handle call
                          },
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

  void _showTodayAnniversaries(BuildContext context) {
    final now = DateTime.now();
    final todayAnniversaries = _anniversaryMembers.where((member) {
      if (member.dateOfAnniversary == null) return false;
      return member.dateOfAnniversary!.day == now.day && 
             member.dateOfAnniversary!.month == now.month;
    }).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFD868C), Color(0xFFFEDBD0)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.favorite, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text('Today\'s Anniversaries'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: todayAnniversaries.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No anniversaries today',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: todayAnniversaries.length,
                  itemBuilder: (context, index) {
                    final member = todayAnniversaries[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFD868C), Color(0xFFFEDBD0)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.favorite, color: Colors.white, size: 20),
                        ),
                        title: Text(
                          member.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(member.mobile),
                        trailing: IconButton(
                          icon: const Icon(Icons.phone, color: Color(0xFFE91E63)),
                          onPressed: () {
                            // Handle call
                          },
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

  void _showByelaws(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B8DD6), Color(0xFF3B5596)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.description, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text('Byelaws of Sangh'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Constitution and Byelaws',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B5596),
                ),
              ),
              const SizedBox(height: 16),
              _buildByelawItem('1', 'Name and Registered Office',
                  'The name of the organization shall be "Shree Sirohi Jain Sangh" with its registered office in Chennai.'),
              _buildByelawItem('2', 'Objectives',
                  'To promote social, cultural, and educational activities among Sirohi Jain community members.'),
              _buildByelawItem('3', 'Membership',
                  'Membership is open to all members of the Sirohi Jain community residing in Chennai and surrounding areas.'),
              _buildByelawItem('4', 'Executive Committee',
                  'The Sangh shall be managed by an Executive Committee consisting of President, Vice President, Secretary, Joint Secretary, and Treasurer.'),
              _buildByelawItem('5', 'General Body Meetings',
                  'Annual General Meeting shall be held once a year. Special meetings may be called as required.'),
              _buildByelawItem('6', 'Funds and Accounts',
                  'All funds shall be deposited in the name of the Sangh. Proper accounts shall be maintained and audited annually.'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF3B5596)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'For complete byelaws document, please contact the office.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF3B5596)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  Widget _buildByelawItem(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6B8DD6), Color(0xFF3B5596)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF3B5596),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

// Custom Widget for the Gradient Menu Buttons
class MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const MenuButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6B8DD6),
              Color(0xFF4E6CB8),
              Color(0xFF3B5596),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              label,
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
    );
  }
}

// Custom Widget for Banner Carousel with Multiple Banners
class PromotionalBanner extends StatefulWidget {
  const PromotionalBanner({super.key});

  @override
  State<PromotionalBanner> createState() => _PromotionalBannerState();
}

class _PromotionalBannerState extends State<PromotionalBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // List of banner data
  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'BEST BUSINESS',
      'subtitle': 'DEALING',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'buttonText': 'GET STARTED',
      'icon': Icons.lightbulb,
      'gradientColors': [Colors.purpleAccent, Colors.blueAccent],
    },
    {
      'title': 'COMMUNITY',
      'subtitle': 'CONNECT',
      'description': 'Join our vibrant community and stay connected with members.',
      'buttonText': 'JOIN NOW',
      'icon': Icons.groups,
      'gradientColors': [Colors.orangeAccent, Colors.deepOrangeAccent],
    },
    {
      'title': 'LATEST',
      'subtitle': 'EVENTS',
      'description': 'Stay updated with upcoming events and celebrations.',
      'buttonText': 'VIEW EVENTS',
      'icon': Icons.event,
      'gradientColors': [Colors.greenAccent, Colors.tealAccent],
    },
    {
      'title': 'MEMBER',
      'subtitle': 'BENEFITS',
      'description': 'Explore exclusive benefits and services for all members.',
      'buttonText': 'LEARN MORE',
      'icon': Icons.card_membership,
      'gradientColors': [Colors.pinkAccent, Colors.purpleAccent],
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scroll banners every 4 seconds
    Future.delayed(const Duration(seconds: 4), _autoScrollBanners);
  }

  void _autoScrollBanners() {
    if (!mounted) return;
    
    final nextPage = (_currentPage + 1) % _banners.length;
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    
    Future.delayed(const Duration(seconds: 4), _autoScrollBanners);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return _buildBannerCard(banner);
            },
          ),
        ),
        const SizedBox(height: 8),
        // Page Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? const Color(0xFF2C5282)
                    : Colors.grey[300],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCard(Map<String, dynamic> banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: banner['gradientColors'],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            // Left Side: Text Content
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(banner['icon'], color: Colors.red, size: 20),
                        const SizedBox(width: 4),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "SHREE SIROHI",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "JAIN SANGH",
                              style: TextStyle(fontSize: 8, color: Colors.grey),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      banner['title'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      banner['subtitle'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.red,
                        height: 0.9,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      banner['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        banner['buttonText'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Right Side: Image/Graphics
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Decorative triangle/background
                    CustomPaint(
                      painter: TrianglePainter(),
                    ),
                    // Icon representation
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Icon(
                          banner['icon'],
                          size: 80,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
