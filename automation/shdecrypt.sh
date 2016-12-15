#!/bin/sh

sshpass -p 'passwd' ssh mobile@< IP > << EOF
Clutch -b 1
Clutch -d 1
cd /var/tmp/clutch/*/*
class-dump-z * > CDZ
cp /private/var/mobile/Documents/Dumped/* /var/tmp/clutch/*/*
rm /private/var/mobile/Documents/Dumped/*
exit

EOF

sshpass -p 'passwd' scp -r mobile@< IP >:/var/tmp/clutch/*/* /home/ubuntu/clutchbinary/
echo "scp'd"

sshpass -p 'passwd' ssh mobile@< IP > << TWO
Clutch --clean
exit

TWO

echo "Done"
