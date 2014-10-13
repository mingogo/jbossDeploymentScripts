#!/bin/bash
git status
git add -A
git commit -m "add things."
git fetch
git branch -a
echo "[GIT] Which branch do you want to push to remote?"
echo "enter:" read BRANCH
git push origin $BRANCH
echo "[GIT] Done."
