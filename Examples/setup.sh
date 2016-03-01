#!/bin/bash
set -e

# Script folder
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Parent folder
ROOT="$( dirname ${DIR} )"
# Is carthage installed?
hash carthage 2>/dev/null || { echo >&2 "Please install Carthage (https://github.com/Carthage/Carthage)"; exit 1; }

# Run carthage
cd ${ROOT}
echo "Setting up dependencies..."
echo ""
echo "*********************"
carthage bootstrap
carthage build --no-skip-current --platform osx

# Done
echo "*********************"
echo "DONE."
echo ""
echo "You can now run the examples, try to run:"
echo " cd ${ROOT} && Examples/roll.swift 3d6+5"
