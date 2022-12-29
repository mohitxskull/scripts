# Scripts by skull

This repository contains a collection of scripts that I use on a daily basis. I have tried to make them as simple as possible, so that they can be easily understood and modified.

## Scripts

### `git.sh`
source: `/src/git.src.sh`

> don't get scared by the obfuscated code in `git.sh`, it is just a wrapper that will download the real script from github and execute it, it will take care that you use the `latest version` of the script.

This script will help you with github cmds.

It will help you with the following commands:

- initialize a new repository.
- push changes to the remote.
- update and push changes to the remote.
- force push changes to the remote.
- resolve conflicts.

Resolve conflicts options:
- Keep the version in the current branch.
- Keep the version in the remote branch.
- Keep both versions and create a new commit.
- Discard both versions and start over.

It has easy to use menus and will clear the terminal screen after each step.

### `obf.sh`
source: `obf.sh`

this is a very simple script to ofuscate bash scripts.

points to remember:
- it does not check for syntax errors or anything like that.
- it just base64 encodes the script and then decodes it and evals it.
- it is not meant to be used for anything serious.
- it is just a fun little project.

usage: `obf.sh <script>`