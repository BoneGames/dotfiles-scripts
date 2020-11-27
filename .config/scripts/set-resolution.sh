#!/bin/zsh

# to add new mode run:
# cvt width height refreshrate
# this will output Modeline
# insert modeline values into 2 commands below


function set_res () {
# create mode
TRY_ADD_MODE=$(xrandr --newmode "1920x1080_60.00" 173.00 1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync 2>&1)

if [ -z "$TRY_ADD_MODE" ]; then
    echo "setting resolution"
else
    echo "resolution already set"
    exit
fi

# Add mode
xrandr --addmode Virtual1 1920x1080_60.00

# Apply mode
xrandr --output Virtual1 --primary --mode 1920x1080_60.00

}
echo oi
# If vmware machine
if [ -c /dev/vsock ]; then
    echo "you are using a vmware machine u little fucker"

elif [ -c /dev/vhost-vsock ]; then
    echo "you are using a virtualbox machine u little cunt"
    set_res
else
    echo "you are using a host machine u braggart"
fi
