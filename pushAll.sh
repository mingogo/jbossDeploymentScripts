#!/bin/bash
git status
git add -A
echo "[GIT] Enter commiting message"
read MESSAGE
#git commit -m "add things."
git commit -m "$MESSAGE"
git fetch
clear
git branch -a
echo "[GIT] Which branch do you want to push to remote?"
read BRANCH
echo "[GIT] Pushing $BRANCH to Github."
git push origin $BRANCH
echo "[GIT] Done."
