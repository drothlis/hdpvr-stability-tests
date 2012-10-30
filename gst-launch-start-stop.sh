#!/bin/sh

# Capture video from the Hauppauge HDPVR for ~25 seconds; then stop and repeat.
# This is to attempt to reproduce an HDPVR lock-up.

timestamp() { date '+%b %d %H:%M:%S'; }

while \
    echo "$(timestamp) gst-launch started"; \
    gst-launch -eq \
        v4l2src num-buffers=5000 ! mpegtsdemux ! video/x-h264 ! decodebin2 ! \
        ffmpegcolorspace ! fakesink sync=false
do
   echo "$(timestamp) gst-launch ended"
   sleep 5
done
