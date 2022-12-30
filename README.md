# Scripts by skull

This repository contains a collection of scripts that I use on a daily basis. I have tried to make them as simple as possible, so that they can be easily understood and modified.

## Scripts

### `git.sh`

source: `/src/git.src.sh`
wrapper: `git.sh`

> don't get confuse by `git.sh` file its just a wrapper for `git.src.sh` which is the actual script. `git.sh` is just a wrapper to update the script from github.

This script will help you with github cmds.

It will help you with the following commands:

- initialize a new repository.
- push changes to the remote.
- update and push changes to the remote.
- force push changes to the remote.

It has easy to use menus and will clear the terminal screen after each step.

options:

- `-u` to update the script from github. ( else script will be updated only if it is older than 1 day. )

usage: 

`git.sh` or `git.sh -u`

install:

`curl -s https://raw.githubusercontent.com/servedbyskull/scripts/main/git.sh | bash`

### `obf.sh`

source: `obf.sh`

this is a very simple script to ofuscate bash scripts.

points to remember:

- it does not check for syntax errors or anything like that.
- it just base64 encodes the script and then decodes it and evals it.
- it is not meant to be used for anything serious.
- it is just a fun little project.

usage: `obf.sh <script>`

### `nm.sh`

source: `nm.sh`

nm.sh is an script to setup and next.js + mantine project.

usage: `nm.sh <project name>`
