#!/bin/bash
# Copyright © 2025 gucio321 (mszeptuch@student.agh.edu.pl)
#
# Projekt zaliczeniowy na laboratirum z Systemy Operacyjne Linux
# Projekt przedstawia prosty organizer zadań

# This is .json to make debugging with vim easier (syntax highlight) but can be made `.todo` with no consequences other than losing current state
DATAFILE="$HOME/.todo.json" # I suppose that the file either does not exist or is valid! Making the file invalid may have unpredictable consequences!

if [[ ! -f $DATAFILE ]]; then
        echo "{}" > $DATAFILE
fi

function usage() {
        cat << EOF
Invalid command - usage:
        $0 add <date: yyyy-mm-dd> <task description> [<priority>] - adds a new task
        $0 list [<date: yyyy-mm-dd>] - lists events planned for <date>. If no date is given, lists events for today ($(date))
        $0 del <event ID> - deletes event with given ID
        $0 move <event ID> <new date: yyyy-mm-dd> - moves event with given ID to new date
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

function genNewID() {
        # // is like "or" operator - if newID does not exist, use 0
        newID=$(cat $DATAFILE |jq '.newID // 0') 
        cat $DATAFILE |jq --argjson id "$newID" '.newID = $id+1' > $DATAFILE.tmp
        mv $DATAFILE.tmp $DATAFILE
        echo $newID
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

                newID=$(genNewID)

                cat << EOF
Adding new event:
- When?: $(date -d "@$evDate" +"%Y-%m-%d")
- What?: $evDescription
- Priority: $priority
EOF
                cat $DATAFILE |jq --argjson id "$newID" --argjson date "$evDate" --arg desc "$evDescription" --argjson prio "$priority" \
                        '.events += [{"id":$id, "date": $date, "description": $desc, "priority": $prio}]' > $DATAFILE.tmp
                mv $DATAFILE.tmp $DATAFILE
                ;;
        list)
                validateArgs 0 1 $#
                evDate=$(date -d "$1" +%s 2> /dev/null) # if -d gets empty field, it is considered being todeay by default
                if [[ $? != 0 ]]; then
                        echo "Inalid date format!"
                        usage
                        exit 2
                fi
                ;;
        del)
                validateArgs 1 1 $#
                evID=$1
                ;;
        move)
                validateArgs 2 2 $#
                evID=$1
                newDate=$(date -d "$2" +%s 2> /dev/null)
                if [[ $? != 0 ]]; then
                        echo "Inalid date format!"
                        usage
                        exit 2
                fi
                ;;
        help|--help)
                usage
                exit 0
                ;;
        *)
                usage
                exit 1
                ;;
esac
