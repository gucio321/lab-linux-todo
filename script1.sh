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

if [[ $# == 0 ]]; then
        usage
        exit 1
fi

cmd=$1
shift # for convinience ;-)
case $cmd in
        add)
                echo "dupa"
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
