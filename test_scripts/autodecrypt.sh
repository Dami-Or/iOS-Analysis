#!/bin/sh

expect << EOF

spawn ssh mobile@155.41.118.17
expect "*assword:"
send "alpine\r"
expect "*$"
send "Clutch -b 1\r"
expect "*$"
send "exit\r"

spawn scp -r mobile@155.41.118.17:/var/tmp/clutch /home/ubuntu
expect "*$"
send "alpine\r"
sleep 5
expect "*100%*"

EOF
