#!/bin/bash
## install-KoPFA.sh : Installation script for the KoPFA and subpkgs
## Author : John Goh (jhgoh@cern.ch)

if [ X$CMSSW_VERSION == X ]; then
  echo "CMSSW is not set. Run cmsenv to setup environment"
  exit 1
fi

if [ $# -le 0 ]; then
  echo "Usage: $0 SUBPKGNAME1 SUBPKGNAME2 ..."
  exit
fi

## Parse arguments
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$0, installation tool for KoPFA"
      echo "Usage: $0 [-hb] SUBPKGNAME1 SUBPKGNAME2 ..."
      echo "      -h,--help : Show help message"
      echo "      -b,--build : Build after checkout"
      exit
      shift
      ;;
    -b|--build)
      BUILD=yes
      shift
      ;;
    *)
      break
      ;;
  esac
done
PKGNAMES=$*

## Initialize git in the KoPFA pkg
cd $CMSSW_BASE/src
if [ ! -d KoPFA ]; then
  mkdir KoPFA
  pushd KoPFA
  git init
  git remote add -f KoPFA git://github.com/cms-top-kr/KoPFA
  git config core.sparsecheckout true
  popd
fi

pushd KoPFA

if [ ! -d .git]; then
  echo "!!! FATAL !!! Cannot find .git directory"
  echo "!!! Your KoPFA directory is not set up for git"
  exit 2
fi

## Add sub package into list of sparse checkout
for SUBPKG in $PKGNAMES; do
  echo $SUBPKG >> .git/info/sparse-checkout
done

## Get the master branch
git checkout master
if [ _$BUILD == _yes ]; then
  scram b
fi

popd
