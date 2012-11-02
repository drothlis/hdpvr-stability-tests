#!/usr/bin/env python
# -*- eval: (if (fboundp 'pretty-symbols-mode) (pretty-symbols-mode -1)) -*-

from datetime import datetime
import re
import sys


if len(sys.argv) != 2 or sys.argv[1] in ("-h", "--help"):
    sys.stderr.write("""Usage: gst-launch-start-stop-report.py <logfile>

        Reports on the output from gst-launch-start-stop.sh.""".lstrip())
    sys.exit(0 if len(sys.argv) == 2 else 1)


def main(f):
    eof = False

    state_machine = [
    #From state, To state, condition,                                tStart,        nSuccesses,    tFail, nFailures,     tLast, print
    (None,      "started", r"gst-launch started",                    ts,            lambda n: 0,   None,  lambda n: 0,   ts,    None),
    ("started", "success", r"gst-launch returned 0",                 None,          lambda n: n+1, None,  lambda n: 0,   ts,    None),
    ("started", "failure", r"gst-launch (returned [1-9]|timed out)", None,          None,          ts,    lambda n: n+1, ts,    None),
    ("success", "success", r"gst-launch returned 0",                 None,          lambda n: n+1, None,  None,          ts,    None),
    ("success", "failure", r"gst-launch (returned [1-9]|timed out)", None,          None,          ts,    lambda n: 1,   ts,    None),
    ("success", "eof",     lambda: eof,                              None,          None,          None,  None,          None,  lambda: "Ran successfully since %s for %s" % (tStart, tLast-tStart)),
    ("failure", "failure", r"gst-launch (returned [1-9]|timed out)", None,          None,          None,  lambda n: n+1, ts,    None),
    ("failure", "success", r"gst-launch returned 0",                 lambda: tLast, lambda n: 1,   None,  lambda n: 0,   ts,    lambda: "Failed at %s after running for %s (%d failures)" % (tFail, tFail-tStart, nFailures)),
    ("failure", "eof",     lambda: eof,                              None,          None,          None,  None,          None,  lambda: "Failed at %s after running for %s (%d failures)" % (tFail, tFail-tStart, nFailures)),
    ]

    for line in open(f):
        transition(state_machine, line)

    eof = True
    transition(state_machine, "")


def transition(state_machine, line):
    global state, tStart, nSuccesses, tFail, nFailures, tLast

    for (from_, to, condition, f_tStart, f_nSuccesses, f_tFail, f_nFailures,
            f_tLast, f_print) in state_machine:
        if state == from_ and search(condition, line):
            if f_print: print f_print()
            if f_tStart: tStart = f_tStart()
            if f_nSuccesses: nSuccesses = f_nSuccesses(nSuccesses)
            if f_tFail: tFail = f_tFail()
            if f_nFailures: nFailures = f_nFailures(nFailures)
            if f_tLast: tLast = f_tLast()
            state = to
            break


def search(condition, line):  # Why didn't I just write this script in perl?
    global m
    if type(condition) == str:
        m = re.search("^(.*) %s" % condition, line)
        return m
    else:
        return condition()


def ts():
    class PrettyDate(datetime):
    # How I wish I'd made gst-launch-start-stop.sh print a full timestamp!
        def __new__(cls, d):
            return super(PrettyDate, cls).__new__(
                cls, d.year, d.month, d.day, d.hour, d.minute, d.second)
        def __str__(self):
            return self.strftime("%b %d %H:%M:%S")

    return PrettyDate(datetime.strptime(m.group(1), "%b %d %H:%M:%S"))


state = None
tLast = None
tStart = None
nSuccesses = None
tFail = None
nFailures = None
m = None


main(sys.argv[1])
