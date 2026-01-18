#!/data/data/com.termux/files/usr/bin/bash

echo "🔁 Restoring Termux from backup..."

# Restore packages
if [ -f packages.txt ]; then
    echo "📦 Installing packages..."
    pkg update -y
    while read -r pkg; do
        if [ -n "$pkg" ] && [[ "$pkg" != "Listing..." ]]; then
            echo "Installing: $pkg"
            pkg install "$pkg" -y 2>/dev/null || true
        fi
    done < packages.txt
fi

# Restore configs
echo "📄 Restoring config files..."
[ -f .zshrc ] && { cp .zshrc ~/ && echo "✓ .zshrc restored"; }
[ -f .bashrc ] && { cp .bashrc ~/ && echo "✓ .bashrc restored"; }
[ -f .p10k.zsh ] && { cp .p10k.zsh ~/ && echo "✓ .p10k.zsh restored"; }

# Restore dashboard scripts
if [ -d scripts ]; then
    echo "🚀 Restoring dashboard scripts..."
    script_count=0
    for script_path in scripts/*; do
        if [ -f "$script_path" ]; then
            script_name=$(basename "$script_path")
            echo "Installing: $script_name"
            cp "$script_path" "$PREFIX/bin/$script_name"
            chmod +x "$PREFIX/bin/$script_name"
            ((script_count++))
        fi
    done
    echo "✓ Total scripts installed: $script_count"
fi

echo ""
echo "✅ RESTORE COMPLETE!"
echo "Run: source ~/.zshrc"
echo "Then: ultimate-dash"
