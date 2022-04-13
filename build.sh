#!/bin/bash

echo "Branch: ${GIT_BRANCH}"

echo "Installing dependencies...."
npm install || exit 1

echo "Removing old builds"
rm -rvf dist/*

echo "Building applications..."
ng build --base-href / || exit 1

echo "Dropping old apps on EC2 .."
ssh root@35.154.239.163 'rm -rvf /var/www/jeri_jenk/*'

echo "Deploying application on EC2..."
rsync -avzP dist/Keyshell/* root@35.154.239.163:/var/www/jeri_jenk/

if [ $? -eq 0 ]; then
    echo "Deployed the apps successfully"
fi
