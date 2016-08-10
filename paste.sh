#!/bin/bash

paste="https://p.pantsu.cat/p/json"
xclip -selection clipboard -o | curl -s -X POST -F 'p=<-' $paste| jq -c -r ".url" | xclip
