import 'package:flutter/material.dart';
import 'package:flutter_app/config/theme.dart';
import 'dashboard/ui/dashboard_screen.dart';
import 'news/ui/news_screen.dart';
import 'notice/ui/notice_screen.dart';
import 'galllery/ui/gallery_screen.dart';
import 'profile/ui/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    NewsScreen(),
    NoticeScreen(),
    GalleryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 70,
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
            ),
            child: BottomNavigationBar(
          
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppTheme.ssjsPrimaryBlue,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white
              ),
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: _currentIndex == 0
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.description, color: AppTheme.ssjsSecondaryBlue,),
                        )
                      : const Icon(Icons.description),
                  label: 'Dashboard',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper_outlined),
                  label: 'News',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_active_outlined),
                  label: 'Notice',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.business_center_outlined),
                  label: 'Gallery',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
