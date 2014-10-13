#!/bin/bash
git status
git add -A
git commit -m "add things."
echo "Which branch you want to pull from remote?"
git branch -a
read BRANCH
git pull origin $BRANCH
echo "done."
