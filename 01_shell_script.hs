#!/usr/bin/env runghc

import System.Directory
    ( doesDirectoryExist, getCurrentDirectory, setCurrentDirectory )
import System.Exit ( ExitCode (..) )
import System.Process ( readProcessWithExitCode )

exitStatus :: (a,b,c) -> a
exitStatus (a,_,_) = a

stdOut :: (a,b,c) -> b
stdOut (_,b,_) = b

stdErr :: (a,b,c) -> c
stdErr (_,_,c) = c

repositories :: [String]
repositories =  [ "abrazo"
                , "main-engineering"
                , "interview_questions"
                , "DevelopingAHaskellAppLambdaConf2020"
                , "TheWizardTower.github.io"
                ]

gitPull :: String -> IO (ExitCode, String, String)
gitPull repoName = do
  pwd <- getCurrentDirectory
  let repoDir = pwd ++ "/" ++ repoName
  print $ "Repo dir: " ++ repoDir
  setCurrentDirectory $ pwd ++ "/" ++ repoName
  exitCode0 <- readProcessWithExitCode "git" ["config", "pull.rebase", "false"] ""
  if (exitStatus exitCode0 == ExitSuccess) then do
    exitCode1 <- readProcessWithExitCode "git" ["pull", "TheWizardTower", "master"] ""
    setCurrentDirectory pwd
    return exitCode1
  else return exitCode0

gitCheckout :: String -> IO (ExitCode, String, String)
gitCheckout repoName = do
  let repoURL = "https://github.com/TheWizardTower/" ++ repoName ++ ".git"
  print $ "Checking out repo " ++ repoName
  readProcessWithExitCode "git" ["clone", "-o", "TheWizardTower", repoURL] ""

gitPullOrCheckout :: String -> IO (ExitCode, String, String)
gitPullOrCheckout repo = do
  print $ "Repo name: " ++ repo
  pwd <- getCurrentDirectory
  repoExists <- doesDirectoryExist $ pwd ++ "/" ++ repo
  if repoExists then gitPull repo else gitCheckout repo

dirChangeTest :: IO ()
dirChangeTest = do
  pwd <- getCurrentDirectory
  pwdSh <- readProcessWithExitCode "pwd" [] ""
  dirExists <- doesDirectoryExist $ pwd ++ "/TestGit"
  setCurrentDirectory $ pwd ++ "/.."
  pwd' <- getCurrentDirectory
  pwdSh' <- readProcessWithExitCode "pwd" [] ""
  dirExists' <- doesDirectoryExist $ pwd' ++ "/TestGit"
  print pwd
  print pwd'
  print pwdSh
  print pwdSh'
  print dirExists
  print dirExists'

main' :: IO ()
main' = dirChangeTest

main :: IO ()
main = do
  putStrLn "Hello, runghc!"
  exitCode <- readProcessWithExitCode "seq" [ "1", "10" ] ""
  pwd <- getCurrentDirectory
  setCurrentDirectory $ pwd ++ "/.."
  print $ exitStatus exitCode
  print $ stdOut exitCode
  print $ stdErr exitCode
  print pwd
  resultList <- mapM gitPullOrCheckout repositories
  mapM_ print resultList
