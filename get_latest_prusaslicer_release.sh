#!/bin/bash
# Get the latest release of PrusaSlicer for Linux-aarch64 (non-AppImage) using the GitHub API
# This was forked from https://github.com/dmagyar/prusaslicer-vnc-docker/blob/main/getLatestPrusaSlicerRelease.sh

set -eu

if [[ $# -lt 1 ]]; then
  echo "~~~ $0 ~~~"
  echo "  !!!NOT EVERY PrusaSlicer RELEASE PROVIDES A COMPILED AARCH64 PACKAGE"
  echo
  echo "	usage: $0 [ url | name | url_ver VERSION | name_ver VERSION_NAME ]"
  echo
  echo "	url: Returns the download URL for the latest release (for download using cURL/wget)"
  echo "	name: Returns the filename of the latest release"
  echo 
  echo "	url_ver: Takes a parameter to specify the version to retrieve (note: download urls have hex-encoded ascii characters)"
  echo "	url_ver example: $0 url_ver 2.4.2"
  echo "	output: https://github.com/prusa3d/PrusaSlicer/releases/download/version_2.4.2/PrusaSlicer-2.4.2%2Blinux-aarch64-GTK2-202204280955.tar.bz2"
  echo
  echo "	name_ver: Takes a parameter to specify the filename to retrieve (note: this has a '+' added on at the end of the provided version number)"
  echo "	name_ver example: $0 name_ver 2.4.2"
  echo "	output: PrusaSlicer-2.4.2+linux-aarch64-GTK2-202204280955.tar.bz2"
  echo
  exit 1
fi

baseDir="/slic3r"
mkdir -p $baseDir

if [[ ! -e "$baseDir/latestReleaseInfo.json" ]]; then

  curl -SsL https://api.github.com/repos/prusa3d/PrusaSlicer/releases/latest > $baseDir/latestReleaseInfo.json

fi

releaseInfo=$(cat $baseDir/latestReleaseInfo.json)

if [[ $# -gt 1 ]]; then

  VER=$2

  if [[ ! -e "$baseDir/releases.json" ]]; then
    curl -SsL https://api.github.com/repos/prusa3d/PrusaSlicer/releases > $baseDir/releases.json
  fi

  allReleases=$(cat $baseDir/releases.json)

fi

if [[ "$1" == "url" ]]; then

  echo "${releaseInfo}" | jq -r '.assets[] | .browser_download_url | select(test("PrusaSlicer-.+(-\\w)?.linux-aarch64-(?!GTK3).+.tar.bz2"))'

elif [[ "$1" == "name" ]]; then

  echo "${releaseInfo}" | jq -r '.assets[] | .name | select(test("PrusaSlicer-.+(-\\w)?.linux-aarch64-(?!GTK3).+.tar.bz2"))'

elif [[ "$1" == "url_ver" ]]; then

  # Note: Releases sometimes have hex-encoded ascii characters tacked on
  # So version '2.0.0+' might need to be requested as '2.0.0%2B' since GitHub returns that as the download URL
  echo "${allReleases}" | jq --arg VERSION "$VER" -r '.[] | .assets[] | .browser_download_url | select(test("PrusaSlicer-" + $VERSION + "%2Blinux-aarch64-(?!GTK3).+.tar.bz2"))'

elif [[ "$1" == "name_ver" ]]; then
   
  echo "${allReleases}" | jq --arg VERSION "$VER" -r '.[] | .assets[] | .name | select(test("PrusaSlicer-" + $VERSION + "\\+linux-aarch64-(?!GTK3).+.tar.bz2"))'

fi