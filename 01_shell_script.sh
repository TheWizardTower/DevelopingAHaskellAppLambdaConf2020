#!/usr/bin/env bash

REPOSITORIES="abrazo \
    main-engineering \
    interview_questions \
    DevelopingAHaskellAppLambdaConf2020 \
    TheWizardTower.github.io"

pushd ../

for REPOSITORY in ${REPOSITORIES}
do
    if [ -d "${REPOSITORY}" ]
    then
        pushd "${REPOSITORY}"
        git config pull.rebase false
        git pull TheWizardTower master
        popd
    else
        git clone -o TheWizardTower "https://github.com/TheWizardTower/${REPOSITORY}.git"
    fi
done

popd

git pull TheWizardTower master