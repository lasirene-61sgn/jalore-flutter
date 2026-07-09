import 'package:flutter/material.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
import 'package:flutter_app/config/theme.dart';
import 'dashboard/ui/dashboard_screen.dart';
import 'news/ui/news_screen.dart';
import 'notice/ui/notice_screen.dart';
import 'galllery/ui/gallery_screen.dart';
import 'profile/ui/profile_screen.dart';
import 'package:upgrader/upgrader.dart';

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
    return UpgradeAlert(
      upgrader: Upgrader(
        // Optional configuration can be added here
      ),
      child: PopScope(
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
              border: Border(top: BorderSide(color: Colors.white70, width: 0.2)),
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
              unselectedItemColor: Colors.white70,
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
                  icon: IgnorePointer(
                    child: _currentIndex == 0
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: RiveAnimatedIcon(
                              key: const ValueKey('home_active'),
                              riveIcon: RiveIcon.home,
                              width: 24,
                              height: 24,
                              color: AppTheme.ssjsPrimaryBlue,
                              loopAnimation: true,
                            ),
                          )
                        : RiveAnimatedIcon(
                            key: const ValueKey('home_inactive'),
                            riveIcon: RiveIcon.home,
                            width: 24,
                            height: 24,
                            color: Colors.white70,
                            loopAnimation: false,
                          ),
                  ),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: IgnorePointer(
                    child: RiveAnimatedIcon(
                      key: ValueKey('globe_${_currentIndex == 1}'),
                      riveIcon: RiveIcon.globe,
                      width: 24,
                      height: 24,
                      color: _currentIndex == 1 ? Colors.white : Colors.grey,
                      loopAnimation: _currentIndex == 1,
                    ),
                  ),
                  label: 'News',
                ),
                BottomNavigationBarItem(
                  icon: IgnorePointer(
                    child: RiveAnimatedIcon(
                      key: ValueKey('bell_${_currentIndex == 2}'),
                      riveIcon: RiveIcon.bell,
                      width: 24,
                      height: 24,
                      color: _currentIndex == 2 ? Colors.white : Colors.grey,
                      loopAnimation: _currentIndex == 2,
                    ),
                  ),
                  label: 'Notice',
                ),
                BottomNavigationBarItem(
                  icon: IgnorePointer(
                    child: RiveAnimatedIcon(
                      key: ValueKey('gallery_${_currentIndex == 3}'),
                      riveIcon: RiveIcon.gallery,
                      width: 24,
                      height: 24,
                      color: _currentIndex == 3 ? Colors.white : Colors.grey,
                      loopAnimation: _currentIndex == 3,
                    ),
                  ),
                  label: 'Gallery',
                ),
                BottomNavigationBarItem(
                  icon: IgnorePointer(
                    child: RiveAnimatedIcon(
                      key: ValueKey('profile_${_currentIndex == 4}'),
                      riveIcon: RiveIcon.profile,
                      width: 24,
                      height: 24,
                      color: _currentIndex == 4 ? Colors.white : Colors.grey,
                      loopAnimation: _currentIndex == 4,
                    ),
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ), // closes Scaffold
      ), // closes PopScope
    ); // closes UpgradeAlert
  }
}
