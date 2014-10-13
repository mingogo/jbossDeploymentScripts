#!/bin/bash
git status
git add -A
read -p "[GIT] Enter commiting message (Add things.):" MESSAGE
MESSAGE=${MESSAGE:-Add things.}
git commit -m "$MESSAGE"
git fetch -p
git branch -a
read -p "[GIT] Which branch you want to pull from remote?" BRANCH
echo "[GIT] Pulling $BRANCH from Github."
git pull origin $BRANCH
echo "[GIT] Done."
