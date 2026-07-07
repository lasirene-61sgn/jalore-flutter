import shutil
import re

source = "/Users/admin/Downloads/flutter_projects/sirohi/sirohi-flutter/lib/screens/profile/ui/family_details_screen.dart"
dest = "lib/screens/profile/ui/family_details_screen.dart"

with open(source, "r") as f:
    content = f.read()

# Replace AppBar background colors to match Jalore's style
content = re.sub(
    r"appBar: AppBar\(\s*title: Text\('Family Members'\),\s*backgroundColor: Colors.white,",
    r"appBar: AppBar(\n        title: const Text('Family Members'),\n        backgroundColor: AppTheme.ssjsSecondaryBlue,",
    content
)

content = re.sub(
    r"appBar: AppBar\(\s*title: Text\(member\.name\),\s*backgroundColor: Colors.white,",
    r"appBar: AppBar(\n        title: Text(member.name),\n        backgroundColor: AppTheme.ssjsSecondaryBlue,",
    content
)

with open(dest, "w") as f:
    f.write(content)

