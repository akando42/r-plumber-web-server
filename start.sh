#!/usr/bin/env bash

R 'library(plumber)'
R 'r <- plumb("app.R")'
R 'r$run(port=8000)'