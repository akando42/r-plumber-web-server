#!/usr/bin/env bash
echo -n "Enter your commit message: "
read ans
echo $ans
git add .
git commit -m "$ans"
echo -n "Enter your branch: "
read ans
echo $ans
git push origin $ans