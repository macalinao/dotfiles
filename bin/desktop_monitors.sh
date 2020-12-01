#!/usr/bin/env sh

configure_monitors() {
  xrandr --output DVI-D-0 --off \
    --output HDMI-0 --mode 3840x2160 --pos 3840x0 --rotate normal \
    --output HDMI-1 --mode 3840x2160 --pos 0x0 --rotate normal \
    --output DP-0 --mode 2560x1440 --pos 7108x2160 --rotate normal \
    --output DP-1 --off \
    --output DP-2 --mode 2560x1440 --pos 1988x2160 --rotate normal --rate 165.08 \
    --output DP-3 --off \
    --output DP-1-1 --mode 2560x1440 --pos 4548x2160 --rotate normal --rate 165.08 \
    --output HDMI-1-1 --off \
    --output HDMI-1-2 --off \
    --output DP-1-2 --off \
    --output HDMI-1-3 --off
}

configure_monitors

# set a monitor small
xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1920x1080 --pos 3840x0 --rotate normal --output HDMI-1 --mode 3840x2160 --pos 0x0 --rotate normal --output DP-0 --mode 2560x1440 --pos 7108x2160 --rotate normal --output DP-1 --off --output DP-2 --mode 2560x1440 --pos 1988x2160 --rotate normal --output DP-3 --off --output DP-1-1 --mode 2560x1440 --pos 4548x2160 --rotate normal --output HDMI-1-1 --off --output HDMI-1-2 --off --output DP-1-2 --off --output HDMI-1-3 --off

configure_monitors
