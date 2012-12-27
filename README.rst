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
