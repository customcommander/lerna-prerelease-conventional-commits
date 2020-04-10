# Summary

In this repository I will show that Lerna 3.20.2 does not bump prerelease packages
according to the ["Conventional Commits" specification][cc-spec].

Whether this is a bug or by design is unknown at this stage. However the thread in this [issue][gh-issue] seems to suggest that it is a bug.

## Minimal Reproducible Example


### TL; DR

```
git clone https://github.com/customcommander/lerna-prerelease-conventional-commits.git
cd lerna-prerelease-conventional-commits
./run.sh
```

---

I have setup two separate repositories in a Docker container.

Both are Lerna-managed monorepos with three sub-packages. However the packages in the second repositories are in a prerelease state:

```
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
```

I will then make the following commits in both repositories:

1. A breaking change in the `major` package
2. A new feature in the `minor` package
3. A bug fix in the `patch` package

I then run the following command in both repositories:

```
npx lerna publish --conventional-commits --yes 2>/dev/null
```

### Observations

Lerna does bump the non-prerelease versions correctly:

```
Changes:
 - major: 1.0.0 => 2.0.0 (private)
 - minor: 1.0.0 => 1.1.0 (private)
 - patch: 1.0.0 => 1.0.1 (private)
```

However the prerelease versions see a patch update only:

```
Changes:
 - major: 1.0.0-alpha.0 => 1.0.0-alpha.1 (private)
 - minor: 1.0.0-alpha.0 => 1.0.0-alpha.1 (private)
 - patch: 1.0.0-alpha.0 => 1.0.0-alpha.1 (private)
```

[cc-spec]: https://www.conventionalcommits.org/
[gh-issue]: https://github.com/lerna/lerna/issues/1433