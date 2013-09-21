Stress tests for the Hauppauge HD PVR video-capture device
==========================================================

Scripts to reproduce a lock-up of the HD PVR that is only fixed by
power-cycling the device.

Usage
-----

::

    ./gst-launch-start-stop.sh /dev/video0 > hdpvr.log
    ./gst-launch-start-stop-report.py hdpvr.log

Dependencies
------------

* gstreamer
* gstreamer-plugins-good (for v4l2src etc)
* gstreamer-plugins-bad-free (for mpegtsdemux)
* gstreamer-ffmpeg (from rpmfusion or your distro's equivalent; for H.264 decoder)
* GNU coreutils (for "timeout")
* python (tested with 2.7)

(Package names are from Fedora 17; you might have to do a little bit of
searching to find the equivalent package in other Linux distributions or other
operating systems.)

License
-------

Written in 2012 by David Rothlisberger <david@rothlis.net>
under contract to YouView TV Ltd.

To the extent possible under law, YouView TV Ltd. has dedicated all copyright
and related and neighboring rights to this software to the public domain
worldwide. This software is distributed without any warranty.

You should have received a copy of the CC0 Public Domain Dedication along with
this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

Results
-------

We tried all sorts of experiments: Adding a better heatsink to the H.264
encoder chip; adding a heatsink to the A/D chip; different kernel versions;
multiple HD PVRs connected to a single PC versus a single one. The only
significant improvement we found was from removing the lid and `adding fans`_
directly over the circuit board, but this doesn't cure the problem completely,
it only increases the time-to-failure. We've measured the surface temperature
of the encoder chip's heatsink, and of the A/D chip, and neither one was ever
observed to exceed 40°C (with the fan); but the HD PVR still fails.

Our measurements:

=================  ===========  ===========  ============  ===========  ==========  ===========  ===========
Time-to-failure in hours: Average (StdDev) /Samples                     Simultaneous HDPVRs
----------------------------------------------------------------------  ------------------------------------
PC                 Fan          No fan       Kernel 3.6.6  <3.6         1           2            3
=================  ===========  ===========  ============  ===========  ==========  ===========  ===========
dev1                            14 (10) /9   12 (8) /4     16 (13) /5               14 (10) /9
dev2                            15 (13) /9   8 (8) /4      22 (15) /5   16 (14) /9
stb-tester-slave1  33 (43) /10  12 (8) /12   20 (26) /5    22 (33) /17  9 (4) /5    4 (1) /2     28 (36) /15
stb-tester-slave2               20 (18) /20  25 (14) /4    19 (21) /16  18 (13) /7  22 (23) /13
stb-tester-slave5               37 (36) /12  42 (24) /2    36 (39) /10  21 (24) /5  50 (41) /7
=================  ===========  ===========  ============  ===========  ==========  ===========  ===========

* All tests were run using `gst-launch-start-stop.sh`.
* "Failure" means a permanent lock-up; I ignored transient failures where the
  HDPVR continued working after stopping & re-starting recording.
* The runs with 3 simultaneous HDPVRs tended to also be the runs with fans,
  which could explain the longer running times. Of the 3 HDPVRs, the first to
  fail was usually one of the 2 on the same USB controller. Note that we did
  observe failures with the fan and a single HDPVR per PC.
