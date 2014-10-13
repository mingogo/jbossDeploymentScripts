#!/bin/bash
git status
git add -A
read -p "[GIT] Enter commiting message (Add things.):" MESSAGE
MESSAGE=${MESSAGE:-Add things.}
#echo $MESSAGE
#read MESSAGE
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
