#!/bin/bash
git status
git add -A
git commit -m "add things."
git fetch
git branch -a
echo "[GIT] Which branch do you want to push to remote?"
read BRANCH
echo "[GIT] Pushing $BRANCH to Github."
git push origin $BRANCH
echo "[GIT] Done."
