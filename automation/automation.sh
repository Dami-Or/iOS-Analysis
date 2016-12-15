!#/bin/sh

clear
exec 3</home/user/Desktop/app_ids.txt

while read -u3 line       
do           
	echo $line
	sshpass  ssh -i cloud.key -tt user@<IP> -p 333 cmd /c "cd C:\Users &download_give_id.exe ${line} & exit" < /dev/tty
	echo "Downloading an app on Windows"
	#sshpass  ssh -i cloud.key -tt user@<IP> -p 333 cmd /c "cd C:\Users\Public\iTunes_apps\Mobile Applications & 2>nul (>>*.ipa (call )) && (echo file is not locked) || (echo file is locked) " < /dev/tty
	sleep 40
	sshpass  ssh -i cloud.key -tt user@<IP> -p 333 cmd /c "cd C:\Users\Public\iTunes_apps\Mobile Applications & echo HELLO &scp -i cloud.key *.ipa user@<IP>:/home/user/Desktop/apps &rm *.ipa & exit"</dev/tty
	cd /home/user/Desktop/apps;
	echo `ls`
	app=*.ipa;
	app_name=$app
	ideviceinstaller -i $app_name;
	List=`ideviceinstaller -l`;
	arr=($List);
	bundle_id=${arr[3]::-1};
	echo $app_name
	sleep 10;
	echo "Removing Encrypted ipa"
	rm *.ipa
	echo "Sshing";
	sshpass -p "paswd" ssh -o StrictHostKeyChecking=no root@10.0.0.17 bash -c "'
	echo \"Decrypting\"
	Clutch -d 1;
	sleep 20;
	echo \"Copying app back to Linux\"
	exit;
          '"
	sshpass -p 'paswd' scp -r root@10.0.0.17:/private/var/mobile/Documents/Dumped/* /home/user/Desktop/apps;
	echo "Copying decrypted file back to Linux"
	sshpass -p "paswd" ssh -o StrictHostKeyChecking=no root@10.0.0.17 bash -c "'
	rm /private/var/mobile/Documents/Dumped/*;
	exit;
          '"
	cd /home/user/Desktop/apps;
	mkdir $line
	mv *ipa $line
	echo "Uninstalling the app";
	ideviceinstaller -U "$@$bundle_id";
	cd /home/user;
	unset $line;
	unset $app_name;
	unset $bundle_id;
	unset $List;
	unset $arr;
	

	done    

echo "Done!"
 



