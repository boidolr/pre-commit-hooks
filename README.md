pre-commit-hooks [![Build Status](https://travis-ci.org/boidolr/pre-commit-hooks.svg?branch=master)](https://travis-ci.org/boidolr/pre-commit-hooks) [![release](https://img.shields.io/github/v/tag/boidolr/pre-commit-hooks)](https://github.com/boidolr/pre-commit-hooks/releases)
================

Some hooks for pre-commit.

See also: https://github.com/pre-commit/pre-commit


### Using pre-commit-hooks with pre-commit

Add this to your `.pre-commit-config.yaml`

    -   repo: https://github.com/boidolr/pre-commit-hooks
        rev: v1.1.0  # Use the ref you want to point at
        hooks:
        -   id: console-logging
        # -   id: ...


### Hooks available

#### Commit message related

- `prepare-message`: Change commit messages to include a prefix.
    - `--ignore-branch` will lead to the branch not being checked
    - `--pattern` can be used to change the feature branch pattern to take the message prefix from.
        Needs to match with `--prefix-pattern`. Defaults to `feature/(\w+-\d+)`
    - `--prefix-pattern` should match the prefix of the message to normalize it.
        Needs to match with `--pattern`. Defaults to `^\s*\w+-\d+\s*:`
- `check-message`: Ensure commit message conforms to format of headline followed by two empty lines.
- `save-message`: Save commit message - hook needs to be used in conjunction with `restore-message`.
    In case the commit is aborted during processing this hook enables saving the content of the commit message.
    It needs to be included as first hook in the processing chain.
- `restore-message`: Restore commit message - hook needs to be used in conjunction with `save-message`.
    In case the previous commit was aborted this hook restores the content of the commit message into the editor.

#### Code related

- `check-test`: Remove focus and ignore from [jasmine](https://jasmine.github.io/) and [jest](https://jestjs.io/) tests.
- `ng-lint`: Execute `ng lint` for changed files only.
    - `--fix` will call `ng lint` with `--fix`
    - `--ng-path` can be used to give the path to the `ng` executable. Default is `node_modules/.bin/ng`
- `console-logging`: Remove lines containing javascript console statements.
- `properties-whitespace`: Remove whitespace around equal signs in property files.
