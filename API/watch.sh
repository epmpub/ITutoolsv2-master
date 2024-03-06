#!/bin/bash
while sleep 0.1; do ls *.go | entr -d ./deploy.sh; done