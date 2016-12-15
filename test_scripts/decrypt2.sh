#!/bin/sh

expect << EOF

spawn ssh mobile@209.6.77.162
expect "*assword:"
send "alpine\r"
expect "*$"
send "Clutch -b 1\r"
expect "*$"
send "Clutch -d 1\r"

set timeout -1

expect "*$"
send "cp /private/var/mobile/Documents/Dumped/* /var/tmp/clutch/*/\r"
expect "*$"
send "rm /private/var/mobile/Documents/Dumped/*\r"
send "cd /var/tmp/clutch/*/*\r"
expect "*$"
send "class-dump-z * > CDZ\r"
expect "*$"
send "exit\r"

expect "*$"
spawn scp -r mobile@209.6.77.162:/var/tmp/clutch/*/* /home/ubuntu/clutchbinary/
expect "*assword*"
send "alpine\r"

set timeout -1

expect "*$"
spawn ssh mobile@209.6.77.162
expect "*assword:"
send "alpine\r"
expect "*$"
send "Clutch --clean"
expect "*$"
send "exit\r"

EOF
