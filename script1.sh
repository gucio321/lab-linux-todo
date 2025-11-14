#!/bin/bash
# Copyright © 2025 gucio321 (mszeptuch@student.agh.edu.pl)
#
# Projekt zaliczeniowy na laboratirum z Systemy Operacyjne Linux
# Projekt przedstawia prosty organizer zadań

function usage() {
        cat << EOF
Invalid command - usage:
        $0 add <date: yyyy-mm-dd> <task description> [<priority>] - adds a new task
EOF
}

function validateArgs() {
        min=$1
        max=$2
        actual=$3
        if [[ $actual -lt $min || $actual -gt $max ]]; then
                echo "Invalid number of argumetns! At least $min at most $max expected (got $actual)!"
                usage
                exit 1
        fi
}

if [[ $# == 0 ]]; then
        usage
        exit 1
fi

cmd=$1
shift # for convinience ;-)
case $cmd in
        add)
                validateArgs 2 3 $#
                evDate=$(date -d "$1" +%s 2> /dev/null)
                if [[ $? != 0 ]]; then
                        echo "Inalid date format!"
                        usage
                        exit 2
                fi
                # validate date
                # %s is a second since the epoch (comfortable for integer operations)
                today=$(date +%s)
                evDescription=$2
                if [[ $evDate -lt $today ]]; then
                        echo "Date cannot be in the past!"
                        usage
                        exit 3
                fi
                # also date cannot be too far in the future (say one year)
                # well this might intoduce some small error due to +1 year considering current time, but its acceptable for me ;-)
                oneYearFromToday=$(date -d "+1 year" +%s)
                if [[ $evDate -gt $oneYearFromToday ]]; then
                        echo "Date cannot be more than one year in the future!"
                        usage
                        exit 3
                fi

                priority=$3
                if [[ $priority == "" ]]; then
                        priority="0"
                fi

                cat << EOF
Adding new event:
- When?: $(date -d "@$evDate" +"%Y-%m-%d")
- What?: $evDescription
- Priority: $priority
EOF
                ;;
        --help)
                usage
                exit 0
                ;;
        *)
                usage
                exit 1
                ;;
esac
