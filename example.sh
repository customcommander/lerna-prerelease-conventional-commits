cd /workspaces/dev

echo "

This is the non-prerelease repository
-------------------------------------------------

"

echo "000" >>packages/major/README.md; git commit -a -F /example/commit-msg-major.txt
echo "000" >>packages/minor/README.md; git commit -a -F /example/commit-msg-minor.txt
echo "000" >>packages/patch/README.md; git commit -a -F /example/commit-msg-patch.txt

npx lerna publish --conventional-commits --yes 2>/dev/null

echo "

This is the prerelease repository
-------------------------------------------------

"


cd /workspaces/dev-prerelease

echo "000" >>packages/major/README.md; git commit -a -F /example/commit-msg-major.txt
echo "000" >>packages/minor/README.md; git commit -a -F /example/commit-msg-minor.txt
echo "000" >>packages/patch/README.md; git commit -a -F /example/commit-msg-patch.txt

npx lerna publish --conventional-commits --yes 2>/dev/null
