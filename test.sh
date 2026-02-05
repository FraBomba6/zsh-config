#!/bin/bash
# Validation script for zsh-config

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

pass() { echo -e "${GREEN}[PASS]${NC} $1"; }
fail() { echo -e "${RED}[FAIL]${NC} $1"; ((ERRORS++)); }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; ((WARNINGS++)); }

echo "=== zsh-config Validation ==="
echo ""

# Check symlinks
echo "Checking symlinks..."
[ -L "$HOME/.zshrc" ] && pass ".zshrc symlink exists" || fail ".zshrc symlink missing"
[ -L "$HOME/.zshenv" ] && pass ".zshenv symlink exists" || warn ".zshenv symlink missing"
[ -L "$HOME/.p10k.zsh" ] && pass ".p10k.zsh symlink exists" || warn ".p10k.zsh symlink missing"

# Check required commands
echo ""
echo "Checking required commands..."
command -v zsh &>/dev/null && pass "zsh installed" || fail "zsh not installed"
command -v git &>/dev/null && pass "git installed" || fail "git not installed"

# Check optional commands
echo ""
echo "Checking optional commands..."
command -v fzf &>/dev/null && pass "fzf installed" || warn "fzf not installed"
command -v colorls &>/dev/null && pass "colorls installed" || warn "colorls not installed"

# Test zshrc loads without errors
echo ""
echo "Testing zshrc loads..."
if zsh -c 'source ~/.zshrc' 2>&1 | grep -qi "error"; then
    fail "zshrc has errors"
else
    pass "zshrc loads without errors"
fi

# Summary
echo ""
echo "=== Summary ==="
echo "Errors: $ERRORS"
echo "Warnings: $WARNINGS"

[ $ERRORS -eq 0 ] && echo -e "${GREEN}All critical checks passed!${NC}" || echo -e "${RED}Some checks failed!${NC}"
exit $ERRORS
