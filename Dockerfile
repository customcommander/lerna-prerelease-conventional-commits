FROM node:12-alpine

RUN apk upgrade && apk add git jq

RUN     git config --global core.excludesfile '~/.gitignore' \
    &&  echo 'node_modules/' >~/.gitignore \
    &&  echo '*.sh' >>~/.gitignore

# These bare repositories will be the one Lerna will push to.

WORKDIR /workspaces/remote
RUN git init --bare remote.git

WORKDIR /workspaces/remote-pre
RUN git init --bare remote-pre.git

WORKDIR /workspaces/dev
RUN     git init \
    &&  git config user.name john \
    &&  git config user.email john@example.com \
    &&  git remote add origin /workspaces/remote/remote.git \
    &&  yarn init -y \
    &&  yarn add lerna --dev \
    &&  npx lerna init --independent \
    &&  npx lerna create major -y --private \
    &&  npx lerna create minor -y --private \
    &&  npx lerna create patch -y --private \
    &&  git add . \
    &&  git commit -m "build: setup monorepo with two packages" \
    &&  git push origin master

WORKDIR /workspaces/dev-prerelease
RUN     git init \
    &&  git config user.name john \
    &&  git config user.email john@example.com \
    &&  git remote add origin /workspaces/remote-pre/remote-pre.git \
    &&  yarn init -y \
    &&  yarn add lerna --dev \
    &&  npx lerna init --independent \
    &&  npx lerna create major -y --private \
    &&  jq '.version = "1.0.0-alpha.0"' packages/major/package.json >/tmp/package.json \
    &&  cat /tmp/package.json >packages/major/package.json \
    &&  npx lerna create minor -y --private \
    &&  jq '.version = "1.0.0-alpha.0"' packages/minor/package.json >/tmp/package.json \
    &&  cat /tmp/package.json >packages/minor/package.json \
    &&  npx lerna create patch -y --private \
    &&  jq '.version = "1.0.0-alpha.0"' packages/patch/package.json >/tmp/package.json \
    &&  cat /tmp/package.json >packages/patch/package.json \
    &&  git add . \
    &&  git commit -m "build: setup monorepo with two packages" \
    &&  git push origin master

CMD ["sh"]
