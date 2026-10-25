import os
import re

lib_dir = "lib"
files_to_modify = []

replacements = [
    ("AppTheme.bgDark", "Theme.of(context).scaffoldBackgroundColor"),
    ("AppTheme.surfaceDark", "Theme.of(context).colorScheme.surface"),
    ("AppTheme.cardDark", "Theme.of(context).cardTheme.color!"),
    ("AppTheme.textPrimary", "Theme.of(context).colorScheme.onSurface"),
    ("AppTheme.textSecondary", "(Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey)"),
    ("AppTheme.borderDark", "Theme.of(context).dividerColor"),
]

for root, _, files in os.walk(lib_dir):
    for file in files:
        if file.endswith(".dart"):
            path = os.path.join(root, file)
            with open(path, "r") as f:
                content = f.read()
            
            original_content = content
            for old, new in replacements:
                content = content.replace(old, new)
                
            if "Theme.of(context)" in content:
                # Remove common consts that break when dynamic theme is used inside them
                content = re.sub(r'const\s+(Text|Icon|BoxDecoration|TextStyle|BorderSide|Container|Padding|SizedBox|Row|Column)\b', r'\1', content)
                
            if original_content != content:
                with open(path, "w") as f:
                    f.write(content)
                files_to_modify.append(path)

print(f"Modified {len(files_to_modify)} files.")
