#!/bin/bash

paste="https://p.pantsu.cat/api"
xclip -selection clipboard -o | curl -s -X POST -F 'p=<-' $paste| jq -c -r ".url" | xclip
