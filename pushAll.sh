#!/bin/bash
git status
git add -A
git commit -m "add things."
echo "[GIT] Which branch you want to push to remote?"
git fetch
git branch -a
read BRANCH
git push origin $BRANCH
echo "[GIT] Done."
