#!/bin/bash

if [ X$CMSSW_VERSION == X ]; then
  echo "CMSSW is not set. Run cmsenv to setup environment"
  exit
fi

if [ $# -le 2 ]; then
  echo "Usage: $0 SUBPKGNAME1 SUBPKGNAME2 ..."
  exit
fi

## Parse arguments
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$0, installation tool for KoPFA"
      echo "Usage: $0 SUBPKGNAME1 SUBPKGNAME2 ..."
      shift
      ;;
    *)
      break
      ;;
  esac
done
PKGNAMES=$*

cd $CMSSW_BASE/src
if [ ! -d KoPFA ]; then
  mkdir KoPFA
  cd KoPFA
  git init
  git remote add -f KoPFA git://github.com/cms-top-kr/KoPFA
  git config core.sparsecheckout true
fi

for SUBPKG in $PKGNAMES; do
  echo $SUBPKG >> .git/info/sparse-checkout
done

git checkout master
