#!/bin/bash

function print_results {
        echo
        echo -n "$TOTAL tests, $FAILURES failures"
        if [ "$PENDING" -ne 0 ] ; then
                echo -n ", $PENDING pending"
        fi
        if [ "$SKIPPED" -ne 0 ] ; then
                echo -n ", $SKIPPED skipped"
        fi
        echo
        cat -n $FAIL_LOG
}

trap "print_results; exit" SIGINT

TEST_DIR=$1
: ${TEST_DIR:='./spec'}

let FAILURES=0
let TOTAL=0
let PENDING=0
let SKIPPED=0

FAIL_LOG=/tmp/$$.failures.txt
touch $FAIL_LOG

for SPEC in `find $TEST_DIR -name '*_spec.sh' ` ; do
        if ! [ -x $SPEC ] ; then
                echo -n p
                let "PENDING+=1"
                continue
        fi
        if $SPEC >& /dev/null ; then
                echo -n .
        else
                let TEST_ERROR=$?
                if [ $TEST_ERROR -eq 11 ] ; then
                        echo -n '~'
                        let "SKIPPED+=1"
                else
                        echo $SPEC >> $FAIL_LOG
                        let "FAILURES+=1"
                        echo -n F
                fi
        fi
        let "TOTAL+=1"
done

print_results

[ $FAILURES -eq 0 ]
