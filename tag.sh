#!/usr/bin/env bash

if [[ $(git status --porcelain) ]]; then
  echo 'ERROR: Please commit all changes before tagging a new version.'
  exit 1
fi

if [ -z "$1" ]; then
  echo 'ERROR: You must supply a version number.'
  exit 1
fi

TAG=$1
echo "$TAG" > .version

git -c color.ui=always add .
git -c color.ui=always commit -m "chore(release): bump version to ${TAG}"
git -c color.ui=always push
git -c color.ui=always tag "$TAG"
git -c color.ui=always tag latest -f
git -c color.ui=always push --tags -f

# Update and push the release branch so that documentation is updated
echo "Update the release branch"
git -c color.ui=always checkout release
git -c color.ui=always pull
git -c color.ui=always merge master
git -c color.ui=always push

echo "${TAG} tagged. Now go to https://github.com/koel/koel/releases and finish the draft release."
