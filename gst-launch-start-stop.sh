#!/bin/sh

#/ Usage: gst-launch-start-stop.sh <video-device>
#/
#/ Captures video from the Hauppauge HDPVR for ~25 seconds; stops and repeats.
#/ This is to attempt to reproduce an HDPVR lock-up.
#/
#/ Arguments:
#/
#/   video-device     The device node for the HDPVR to test, e.g. /dev/video1

usage() { grep '^#/' "$0" | cut -c4-; }  # Print the above usage message.

[ $# -eq 1 ] || { usage >&2; exit 1; }
dev="$1"

timestamp() { date '+%b %d %H:%M:%S'; }

while true; do
    echo "$(timestamp) gst-launch started"
    timeout 60s gst-launch -eq \
        v4l2src num-buffers=5000 "device=$dev" ! mpegtsdemux ! video/x-h264 ! \
        decodebin2 ! ffmpegcolorspace ! fakesink sync=false
    ret=$?
    case $ret in
        124) echo "$(timestamp) gst-launch timed out";;
        *)   echo "$(timestamp) gst-launch returned $ret";;
    esac
    sleep 5
done
