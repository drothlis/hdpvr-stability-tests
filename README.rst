Stress tests for the Hauppauge HD PVR video-capture device
==========================================================

See http://stb-tester.com/hardware.html#hauppauge-hd-pvr for details.

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
