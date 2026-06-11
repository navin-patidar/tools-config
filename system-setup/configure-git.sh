# Run from this script's directory so the relative path blow resolve
cd "$(dirname "$0")"

echo "configure git"
cp ../configs/git/git.config ../.gitconfig

echo "configure github"
gh auth login
