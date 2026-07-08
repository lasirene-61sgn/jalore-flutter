import re
import os

def update_dashboard():
    file = "lib/screens/dashboard/ui/dashboard_screen.dart"
    with open(file, 'r') as f:
        content = f.read()

    # 1. AppBar in dashboard
    # The dashboard screen's app bar is a custom container or Scaffold AppBar?
    # Actually, in dashboard_screen.dart, it uses a Container with SafeArea.
    content = content.replace("color: AppTheme.secondaryBlue,", "color: AppTheme.ssjsSecondaryBlue,")
    content = content.replace("color: AppTheme.backgroundWhite,", "color: AppTheme.ssjsSecondaryBlue,")
    
    # In my previous script, I replaced gradient in dashboard boxes with color: AppTheme.backgroundWhite.
    # Now it should be ssjsSecondaryBlue.
    # And the text should be white.
    # And the icon should be white.
    
    # We need to be careful with replace. Let's fix MenuButton specifically.
    content = re.sub(
        r"color:\s*AppTheme\.textDark,\s*fontSize:\s*16,",
        "color: Colors.white,\n                        fontSize: 16,",
        content
    )
    
    content = re.sub(
        r"color:\s*AppTheme\.textDark,\s*strokeWidth:\s*2,",
        "color: Colors.white,\n                        strokeWidth: 2,",
        content
    )

    # Notification icon background
    # It was backgroundWhite, make it transparent or ssjsSecondaryBlue. In the image, the notification icon has no background box, just a bell on the app bar.
    # Wait, the bell icon is black in the screenshot!
    content = content.replace(
        "child: const Icon(Icons.notifications, color: AppTheme.primaryBlue)",
        "child: const Icon(Icons.notifications, color: AppTheme.textDark)"
    )

    with open(file, 'w') as f:
        f.write(content)

def update_home():
    file = "lib/screens/home_screen.dart"
    with open(file, 'r') as f:
        content = f.read()
    
    # BNB background
    content = content.replace("backgroundColor: AppTheme.backgroundWhite,", "backgroundColor: AppTheme.ssjsPrimaryBlue,")
    
    # Selected/Unselected item colors
    content = content.replace("selectedItemColor: AppTheme.primaryBlue,", "selectedItemColor: Colors.white,")
    content = content.replace("unselectedItemColor: AppTheme.textGrey,", "unselectedItemColor: Colors.white70,")
    
    # Label style
    content = content.replace("color: AppTheme.primaryBlue", "color: Colors.white")
    
    # Selected icon circular background
    content = content.replace("color: AppTheme.primaryBlue,\n                              shape: BoxShape.circle,", "color: Colors.white,\n                              shape: BoxShape.circle,")
    
    # Selected Rive icon color
    content = content.replace("color: AppTheme.secondaryBlue,\n                              loopAnimation: true,", "color: AppTheme.ssjsPrimaryBlue,\n                              loopAnimation: true,")
    
    with open(file, 'w') as f:
        f.write(content)

def update_all_appbars():
    files = [
        "lib/screens/dashboard/ui/anniversary.dart",
        "lib/screens/dashboard/ui/birthday_screen.dart",
        "lib/screens/matrimoney/ui/matrimoney_details.dart",
        "lib/screens/matrimoney/ui/matrimony_screen.dart",
        "lib/screens/member_detail_screen.dart",
        "lib/screens/news/ui/news_screen.dart",
        "lib/screens/profile/ui/family_details_screen.dart",
        "lib/screens/profile/ui/profile_edit_screen.dart",
        "lib/screens/profile/ui/profile_screen.dart",
        "lib/screens/galllery/ui/images_screen_view.dart"
    ]
    for file in files:
        if os.path.exists(file):
            with open(file, 'r') as f:
                content = f.read()
            
            # Change AppBars to ssjsSecondaryBlue
            content = content.replace("backgroundColor: AppTheme.backgroundWhite,\n        foregroundColor: AppTheme.textDark,", "backgroundColor: AppTheme.ssjsSecondaryBlue,\n        foregroundColor: AppTheme.textDark,")
            
            # Also handle if it's on one line
            content = content.replace("backgroundColor: AppTheme.backgroundWhite,", "backgroundColor: AppTheme.ssjsSecondaryBlue,")
            
            with open(file, 'w') as f:
                f.write(content)

update_dashboard()
update_home()
update_all_appbars()
print("Applied image colors")
