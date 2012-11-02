#!/usr/bin/env bash

PATH="$(dirname $0):$PATH"

t() {
    local testname=$1 input="$2" expected_output="$3"
    diff -u <(echo "$expected_output") \
            <(gst-launch-start-stop-report.py <(echo "$input")) \
        > log.$$ 2>&1 &&
    echo "$testname... OK" ||
    { echo "$testname... FAILED"; cat log.$$; echo; }
    rm -f log.$$
}

t successes \
"Nov 01 01:00:00 gst-launch started
Nov 01 01:15:00 gst-launch returned 0
Nov 01 01:15:05 gst-launch started
Nov 01 01:30:00 gst-launch returned 0" \
"Ran successfully since Nov 01 01:00:00 for 0:30:00"

t success_interrupted \
"Nov 01 01:00:00 gst-launch started
Nov 01 01:15:00 gst-launch returned 0
Nov 01 01:15:05 gst-launch started" \
"Ran successfully since Nov 01 01:00:00 for 0:15:00"

t allfailed \
"Nov 01 01:00:00 gst-launch started
libv4l2: error getting pixformat: Bad address
Nov 01 01:01:00 gst-launch timed out
Nov 01 01:01:05 gst-launch started
libv4l2: error getting pixformat: Bad address
Nov 01 01:02:05 gst-launch timed out" \
"Failed at Nov 01 01:01:00 after running for 0:01:00 (2 failures)"

t transient_failure \
"Nov 01 01:00:00 gst-launch started
Nov 01 01:00:30 gst-launch returned 0
Nov 01 01:00:35 gst-launch started
Nov 01 01:01:05 gst-launch returned 0
Nov 01 01:01:10 gst-launch started
Nov 01 01:02:10 gst-launch timed out
Nov 01 01:02:15 gst-launch started
Nov 01 01:02:45 gst-launch returned 0
Nov 01 01:02:50 gst-launch started
Nov 01 01:03:20 gst-launch returned 0
" \
"Failed at Nov 01 01:02:10 after running for 0:02:10 (1 failures)
Ran successfully since Nov 01 01:02:10 for 0:01:10"

t lockup \
"Nov 01 01:00:00 gst-launch started
Nov 01 01:00:30 gst-launch returned 0
Nov 01 01:00:35 gst-launch started
Nov 01 01:01:05 gst-launch returned 0
Nov 01 01:01:10 gst-launch started
libv4l2: error getting pixformat: Bad address
Nov 01 01:02:10 gst-launch timed out
Nov 01 01:02:15 gst-launch started
libv4l2: error getting pixformat: Bad address
Nov 01 01:03:15 gst-launch timed out" \
"Failed at Nov 01 01:02:10 after running for 0:02:10 (2 failures)"

t lockup_interrupted \
"Nov 01 01:00:00 gst-launch started
libv4l2: error getting pixformat: Bad address
Nov 01 01:01:00 gst-launch timed out
Nov 01 01:01:05 gst-launch started
libv4l2: error getting pixformat: Bad address
Nov 01 01:02:05 gst-launch timed out
Nov 01 01:02:10 gst-launch started
libv4l2: error getting pixformat: Bad address" \
"Failed at Nov 01 01:01:00 after running for 0:01:00 (2 failures)"
