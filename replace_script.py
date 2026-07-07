import re

with open("lib/screens/dashboard/ui/dashboard_screen.dart", "r") as f:
    content = f.read()

# Replace GridView children
old_grid = """              // Grid Menu
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: ["""

new_grid = """              // Grid Menu
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
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
                    riveIcon: RiveIcon.profile2,
                    label: 'Committee\\nMembers',
                    badgeCount: state.counters?.newCommitteeCount,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CommitteeScreen()),
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
                    riveIcon: RiveIcon.home2,
                    label: 'Business\\nDirectory',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BusinessScreen()),
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
                ],
              ),
              const SizedBox(height: 20),
              """

# We have to extract the part between old_grid and `const SizedBox(height: 20),`
start_idx = content.find(old_grid)
end_idx = content.find("const SizedBox(height: 20),", start_idx)
if start_idx != -1 and end_idx != -1:
    content = content[:start_idx] + new_grid + content[end_idx + len("const SizedBox(height: 20),\n"):]

old_menu_button_regex = r"class MenuButton extends StatelessWidget \{.*?\n\}"
new_menu_button = """class MenuButton extends StatefulWidget {
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
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4DA6FF),
                      Color(0xFF1E90FF),
                      Color(0xFF1873CC),
                    ],
                  ),
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
                  top: -8,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      widget.badgeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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
}"""
content = re.sub(old_menu_button_regex, new_menu_button, content, flags=re.DOTALL)

with open("lib/screens/dashboard/ui/dashboard_screen.dart", "w") as f:
    f.write(content)
