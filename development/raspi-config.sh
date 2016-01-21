#!/bin/bash

# Commands are sourced from https://github.com/asb/raspi-config

CONFIG=/boot/config.txt
BLACKLIST=/etc/modprobe.d/raspi-blacklist.conf

# Exit if the script was not launched by root or through sudo
if [[ $UID != 0 ]];
then
    echo "The script needs to run as root" && exit 1
fi

set_config_var() {
  lua - "$1" "$2" "$3" <<EOF > "$3.bak"
local key=assert(arg[1])
local value=assert(arg[2])
local fn=assert(arg[3])
local file=assert(io.open(fn))
local made_change=false
for line in file:lines() do
  if line:match("^#?%s*"..key.."=.*$") then
    line=key.."="..value
    made_change=true
  end
  print(line)
end

if not made_change then
  print(key.."="..value)
end
EOF
mv "$3.bak" "$3"
}

get_config_var() {
  lua - "$1" "$2" <<EOF
local key=assert(arg[1])
local fn=assert(arg[2])
local file=assert(io.open(fn))
for line in file:lines() do
  local val = line:match("^#?%s*"..key.."=(.*)$")
  if (val ~= nil) then
    print(val)
    break
  end
end
EOF
}

# Create blacklist file
if ! [ -e $BLACKLIST ]; then
    touch $BLACKLIST
fi

# disable device tree
#sed $CONFIG -i -e "s/^\(device_tree=\)$/#\1/"
#sed $CONFIG -i -e "s/^#\(device_tree=.\)/\1/"

# enable device tree
sed $CONFIG -i -e "s/^#\(device_tree=\)$/\1/"
sed $CONFIG -i -e "s/^\(device_tree=.\)/#\1/"
if ! grep -q "^device_tree=$" $CONFIG; then
    printf "device_tree=\n" >> $CONFIG
fi

# enable i2c
SETTING=on
sed $CONFIG -i -r -e "s/^((device_tree_param|dtparam)=([^,]*,)*i2c(_arm)?)(=[^,]*)?/\1=$SETTING/"
if ! grep -q -E "^(device_tree_param|dtparam)=([^,]*,)*i2c(_arm)?=[^,]*" $CONFIG; then
    printf "dtparam=i2c_arm=$SETTING\n" >> $CONFIG
fi

# load the I2C lernal module by default
sed $BLACKLIST -i -e "s/^\(blacklist[[:space:]]*i2c[-_]bcm2708\)/#\1/"
modprobe i2c-bcm2708

# Enable the raspberry pi camera
set_camera() {
    # Stop if /boot is not a mountpoint
    if ! mountpoint -q /boot; then
        return 1
        fi

    [ -e $CONFIG ] || touch $CONFIG

    if [ "$1" -eq 0 ]; then # disable camera
        set_config_var start_x 0 $CONFIG
        sed $CONFIG -i -e "s/^startx/#startx/"
        sed $CONFIG -i -e "s/^start_file/#start_file/"
        sed $CONFIG -i -e "s/^fixup_file/#fixup_file/"
    else # enable camera
        set_config_var start_x 1 $CONFIG
        CUR_GPU_MEM=$(get_config_var gpu_mem $CONFIG)
        if [ -z "$CUR_GPU_MEM" ] || [ "$CUR_GPU_MEM" -lt 128 ]; then
            set_config_var gpu_mem 128 $CONFIG
        fi
        sed $CONFIG -i -e "s/^startx/#startx/"
        sed $CONFIG -i -e "s/^fixup_file/#fixup_file/"
    fi
}
set_camera 1
