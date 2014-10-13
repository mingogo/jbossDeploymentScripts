#!/bin/bash
git status
git add -A
git commit -m "add things."
git fetch
clear
git branch -a
echo "[GIT] Which branch you want to pull from remote?"
read BRANCH
echo "[GIT] Pulling $BRANCH from Github."
git pull origin $BRANCH
echo "[GIT] Done."
