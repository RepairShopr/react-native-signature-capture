#!/usr/bin/env bash

bump=$1

function release() {
  version=$1
  git add .
  package=${PWD##*/}
  tag="$package@$version"
  echo "using tag: $tag"
  git commit -m "$tag"
  git tag -a "$tag" -m "$tag"
}

# release minor
function rminor() {
  version=$(npm version minor --workspaces=false | cut -d'v' -f2)
  echo "bumped to $version"
  release "$version"
}

function rpatch() {
  version=$(npm version patch --workspaces=false | cut -d'v' -f2)
  echo "bumped to $version"
  release "$version"
}

function rmajor() {
  version=$(npm version major --workspaces=false | cut -d'v' -f2)
  echo "bumped to $version"
  release "$version"
}

r"${bump}"
