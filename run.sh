#!/bin/sh

if [[ "$(docker images -q lerna-prerelease-conventional-commits 2>/dev/null)" == "" ]]; then
  echo "Building the Docker container first..."
  docker build . -q -t lerna-prerelease-conventional-commits
fi

echo "
  TL; DR

  run: ./example.sh

  ---

  Hi!

  There are two separate git repositories in this Docker container:

  1.  /workspaces/dev
  2.  /workspaces/dev-prerelease

  Each repository is a Lerna-managed monorepo with three packages each: major, minor and patch.
  The packages in the second repository are in a prerelease state.

  dev (or dev-prerelease)
  |-- packages
  |   |-- major
  |   |   |-- package.json (1.0.0 or 1.0.0-alpha.0)
  |   |-- minor
  |   |   |-- package.json (1.0.0 or 1.0.0-alpha.0)
  |   |-- patch
  |   |   |-- package.json (1.0.0 or 1.0.0-alpha.0)
  |-- package.json
  |-- lerna.json

  You are currently in the '/example' directory.

  Run './example.sh' to: (in both repositories)

  1. Make a breaking change in the 'major' package
  2. Make a minor change in the 'minor' package
  3. Make a fix in the 'patch' package

  And see how Lerna bumps each package.

  Feel free to then navigate to '/workspaces/dev' or '/workspaces/dev-prerelease' and experiment by yourself.

  To start afresh, exit the container and run 'run.sh' again ;)
"

docker run -it --rm --mount type=bind,src=$PWD,dst=/example -w /example lerna-prerelease-conventional-commits sh
