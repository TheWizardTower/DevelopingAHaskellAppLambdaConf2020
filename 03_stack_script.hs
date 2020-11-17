#!/usr/bin/env stack
-- stack --resolver lts-16.20 script

{-# LANGUAGE OverloadedStrings #-}

import Data.Text (pack)
import Turtle
import Turtle.Prelude
import Control.Concurrent.Async (mapConcurrently)
import Prelude hiding (FilePath)

repositories :: [String]
repositories =  [  "main-engineering"
                , "abrazo"
                , "interview_questions"
                , "DevelopingAHaskellAppLambdaConf2020"
                , "TheWizardTower.github.io"
                ]

checkIfDirExists :: String -> IO Bool
checkIfDirExists repoName = do
    currDir <- pwd
    let currDirStr = encodeString currDir
        repoDirStr = currDirStr ++ "/" ++ repoName
        repoDir = decodeString repoDirStr
        repoNamePath = decodeString repoName
    testdir repoNamePath

gitPull :: String -> IO (ExitCode, Text)
gitPull repoName = do
    let repoNamePath = decodeString repoName
        parentDirPath = decodeString ".."
    cd repoNamePath
    exitCode <- procStrict "git" ["config", "pull.rebase", "false"] ""
    cd parentDirPath
    return exitCode

gitClone :: String -> IO (ExitCode, Text)
gitClone repoName = do
    let repoURL = pack $ "https://github.com/TheWizardTower/" ++ repoName ++ ".git"
    procStrict "git" ["clone", "-o", "TheWizardTower", repoURL] ""

gitPullOrClone :: String -> IO (ExitCode, Text)
gitPullOrClone repoName = do
    repoExists <- checkIfDirExists repoName
    if repoExists then gitPull repoName else gitClone repoName

main :: IO ()
main = do
    let parentDir = decodeString ".."
    cd parentDir
    results <- mapConcurrently gitPullOrClone repositories
    mapM_ print results