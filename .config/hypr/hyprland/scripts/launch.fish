#!/usr/bin/env fish

for cmd in $argv
    if test -z "$cmd"
        continue
    end

    set first_word (string split ' ' -- $cmd)[1]

    if type -q $first_word
        eval $cmd &
        exit
    end
end
