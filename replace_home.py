import re

with open("lib/screens/home_screen.dart", "r") as f:
    content = f.read()

# 1. Add import
if "import 'package:rive_animated_icon/rive_animated_icon.dart';" not in content:
    content = content.replace("import 'package:flutter/material.dart';", 
                              "import 'package:flutter/material.dart';\nimport 'package:rive_animated_icon/rive_animated_icon.dart';")

# 2. Replace items
old_items = """              items: [
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
              ],"""

new_items = """              items: [
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
                              color: AppTheme.ssjsSecondaryBlue,
                              loopAnimation: true,
                            ),
                          )
                        : RiveAnimatedIcon(
                            key: const ValueKey('home_inactive'),
                            riveIcon: RiveIcon.home,
                            width: 24,
                            height: 24,
                            color: Colors.grey,
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
              ],"""

content = content.replace(old_items, new_items)

with open("lib/screens/home_screen.dart", "w") as f:
    f.write(content)
