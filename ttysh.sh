#!/bin/bash

# TTYSH : A daily driver and "desktop/non-desktop" experience for the tty.
# 	  For all level of user. 


#
# VARIABLES
#

# variable for while loop
x=0

# splash screen variable for tty/pts

splash=$(tty | tr -d '0123456789')

# ps aux kill xorg
xorg=$(ps aux | grep -i xorg | awk '{print }' | sed -n '1p')

# url from xclip for yt-dlp
url=$(xclip -o)

# filebackup
# find uuid
bdrive=$(cat /home/$SUDO_USER/.uuidfiles)
buuid=$(echo $bdrive)
bdevname=$(ls /dev/disk/by-uuid/ -l | grep $buuid | awk '{print $11}' | tr -d /.)

# timeshift
# find uuid
tdrive=$(cat /home/$SUDO_USER/.uuidtimeshift)
tuuid=$(echo $tdrive)
#devname=$(lsblk | awk '{print $1}' | sed -n 8p | sed s/└─//g)
tdevname=$(ls /dev/disk/by-uuid/ -l | grep $tuuid | awk '{print$11}' | tr -d /.)
tencryptedname="timeshiftbackup"
tunmounting=$(lsblk | grep $tencryptedname | awk '{print $7}')
#echo -e "\nAwaiting $tuuid\n"


#
# FUNCTIONS
# 

# function for tty or pts splash screen
function splashscreen(){
if [ $splash = /dev/pts/ ]; then
	devour mpv --really-quiet /home/$USER/.splash_ttysh.png; clear
else	
	mpv --really-quiet /home/$USER/.splash_ttysh.png; clear
fi
}

# function for shortcuts selection 
function ttyshhelp(){

cat /home/$USER/.ttysh.selection | less
}

# function for TTYSH configuration
function wizardttysh(){
# TO DO LIST
# insert newsboat rss for my instruction videos
# ttysh.selection

# a wizard to configure TTYSH

# first, update the system

sudo pacman -Syu --noconfirm

# install go as dependency for yay
# install yay package manager
# need to research

sudo pacman -S --noconfirm go
sudo pacman -S --needed --noconfirm git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm

# install some misc. AUR packages

yay -S --noconfirm devour
yay -S --noconfirm xdo-git

# install curl

sudo pacman -S --noconfirm curl

# install python

sudo pacman -S --noconfirm python

# install Cmus music player

sudo pacman -S --noconfirm cmus

# install alsa-utils for alsamixer

sudo pacman -S --noconfirm alsa-utils

# install yt-dlp

sudo pacman -S --noconfirm yt-dlp

# install lynx browser/pager

sudo pacman -S --noconfirm lynx

# install mpv
# install fzf
# make the fzf file for use with lynx
# make the .screenrc.lynx conf file and install screen

sudo pacman -S --noconfirm mpv
sudo pacman -S --noconfirm fzf
sudo pacman -S --noconfirm screen

echo -e "#!/bin/bash

x=0

while [ \$x = 0 ]; do

echo \"Press 'c' to start your search. Press 'q' to exit\"
	read answer
	case \$answer in

	c)
	mpv \"\$(find /home/\$USER/Downloads | fzf)\"
	x=0
	;;
	q)
	x=1
	;;
	esac
done

" > /home/$USER/.mpv_fzf_screen.sh

chmod +x /home/$USER/.mpv_fzf_screen.sh

echo -e "
split

focus up

chdir /home/\$USER/Downloads

screen -t bash /bin/bash

screen -t ./mpv_fzf_screen.sh /home/\$USER/.mpv_fzf_screen.sh

focus down

screen -t lynx /usr/bin/lynx /home/\$USER/Downloads

" > /home/$USER/.screenrc.lynx

# install browsh web browser

yay -S --noconfirm browsh

# install librewolf

yay -S --noconfirm librewolf-bin

# install arkenfoxuser.js

yay -S --noconfirm arkenfox-user.js

# install vim, and make the .screenrc.birthdays_split file

sudo pacman -S --noconfirm vim

mkdir /home/$USER/info

echo -e "
BIRTHDAYS

" > /home/$USER/info/birthdays.txt

echo -e "
split

focus up

screen -t vim /usr/bin/vim /home/\$USER/info/birthdays.txt

focus down

chdir /home/\$USER/

screen -t bash /bin/bash

focus up

" > /home/$USER/.screenrc.birthdays_split

# make notes file and the sceenrc_notes_split

echo -e "
\nNOTES

" > /home/$USER/info/notes.txt

echo -e "split

focus up

screen -t vim /usr/bin/vim /home/\$USER/info/notes.txt

focus down

chdir /home/\$USER/

screen -t bash /bin/bash

focus up

" > /home/$USER/.screenrc.notes_split

# install newsboat and make the .screenrc.rss and the yt.sh script

sudo pacman -S --noconfirm newsboat

echo -e "#!/bin/bash

# A script for yt-dlp with search arguments.

x=0

url=\$(xclip -o)

while [ \$x = 0 ]
do

	echo \"y to enter video creator and video discription. x to download url from xclip. m to download music url from xclip. q to quit. yt to run again.\"

	read answer
	case \"\$answer\" in
	
	y)
	echo \"Enter the creator and discription.\"
	read video
	yt-dlp -f 'bv*[height=480]+ba' \"ytsearch1:\$video\"
	x=0
	;;
	x)
	yt-dlp -f 'bv*[height=480]+ba' \"\$url\"
	x=0
	;;
	m)
	yt-dlp -f 'ba' -x --audio-format mp3 \$url
	x=0
	;;
	yt)
	/home/\$USER/./.yt.sh
	x=1
	;;
	q)
	x=1
	;;
	esac

done

" > /home/$USER/.yt.sh

chmod +x /home/$USER/.yt.sh

echo -e "split

focus up

screen -t newsboat /usr/bin/newsboat

focus down

chdir /home/\$USER/Videos/

screen -t bash /bin/bash

screen -t ./yt.sh /home/\$USER/.yt.sh

focus up

" > /home/$USER/.screenrc.rss

# install mutt email and make muttrc for configuration

sudo pacman -S --noconfirm mutt

mkdir -p /home/$USER/.config/mutt/ && touch /home/$USER/.config/mutt/muttrc

echo -e "set folder = \"imaps://\"
set smtp_url = \"smtp://\"

set from = \"\"
set realname = \"\"
set editor = \"vim\"

set spoolfile = \"+INBOX\"
set record = \"+Sent\"
set trash = \"+Trash\"
set postponed = \"+Drafts\"

mailboxes =INBOX =Sent =Trash =Drafts =Junk

" > /home/$USER/.config/mutt/muttrc

# make mutt config screen split

echo -e "split

focus up

screen -t vim /usr/bin/vim /home/\$USER/.config/mutt/muttrc

focus down

chdir /home/\$USER/.config/mutt/

screen -t bash /bin/bash

focus up

" > /home/$USER/.screenrc.mutt_conf

# make screen config for listing saved articles

echo -e "split

focus up

screen -t vim /usr/bin/vim /home/\$USER/Downloads

focus down

chdir /home/\$USER/Downloads

screen -t bash /bin/bash

focus up

" > /home/$USER/.screenrc.articles

# install xorg-server, i3, etc... and make the various configuration files

sudo pacman -S --noconfirm xorg-server
sudo pacman -S --noconfirm xorg-xinit
sudo pacman -S --noconfirm i3-wm
sudo pacman -S --noconfirm xterm

echo -e "exec i3

" > /home/$USER/.xinitrc

echo "
#URxvt*background: black
#URxvt*foreground: white
#URxvt*font: xft:monospace:size=12
#URxvt*scrollBar: false


XTerm.vt100.foreground: white
XTerm.vt100.background: black

xterm*faceName: Monospace
xterm*faceSize: 12
XTerm*font: -*-terminus-medium-*-*-*-18-*-*-*-*-*-iso10646-1
# unreadable
XTerm*font1: -*-terminus-medium-*-*-*-12-*-*-*-*-*-iso10646-1
# tiny
XTerm*font2: -*-terminus-medium-*-*-*-14-*-*-*-*-*-iso10646-1
# small
XTerm*font3: -*-terminus-medium-*-*-*-16-*-*-*-*-*-iso10646-1
# medium
XTerm*font4: -*-terminus-medium-*-*-*-22-*-*-*-*-*-iso10646-1
# large
XTerm*font5: -*-terminus-medium-*-*-*-24-*-*-*-*-*-iso10646-1
# huge
XTerm*font6: -*-terminus-medium-*-*-*-32-*-*-*-*-*-iso10646-1

" > /home/$USER/.Xdefaults

echo "
XTerm.vt100.foreground: white
XTerm.vt100.background: black
XTerm.vt100.color0: rgb:28/28/28
! ...
XTerm.vt100.color15: rgb:e4/e4/e4XTerm.vt100.reverseVideo: true# default

XTerm*font: -*-terminus-medium-*-*-*-18-*-*-*-*-*-iso10646-1
XTerm*font1: -*-terminus-medium-*-*-*-12-*-*-*-*-*-iso10646-1
XTerm*font2: -*-terminus-medium-*-*-*-14-*-*-*-*-*-iso10646-1
XTerm*font3: -*-terminus-medium-*-*-*-16-*-*-*-*-*-iso10646-1
XTerm*font4: -*-terminus-medium-*-*-*-22-*-*-*-*-*-iso10646-1
XTerm*font5: -*-terminus-medium-*-*-*-24-*-*-*-*-*-iso10646-1
XTerm*font6: -*-terminus-medium-*-*-*-32-*-*-*-*-*-iso10646-1

" > /home/$USER/.Xresources

# make screen list videos config

echo -e "#!/bin/bash

mpv \"\$(find /home/\$USER/Videos | fzf)\"

" > /home/$USER/.mpv_fzf_screen_videos.sh

chmod +x /home/$USER/.mpv_fzf_screen_videos.sh

echo -e "
split

focus up

screen -t vim /usr/bin/vim /home/\$USER/Videos

focus down

chdir /home/\$USER/Videos

screen -t bash /bin/bash

screen -t ./mpv_fzf_screen_videos.sh /home/\$USER/.mpv_fzf_screen_videos.sh

focus up

" > /home/$USER/.screenrc.videos

# install fbpdf and mupdf

sudo pacman -S --noconfirm mupdf
yay -S --noconfirm fbpdf-git

# install cryptsetup for diskformat function

sudo pacman -S --noconfirm cryptsetup

# install timeshift for system backups

sudo pacman -S --noconfirm timeshift

# install fbcat for screenshots

yay -S --noconfirm fbcat

# install sc-im for spreadsheets

yay -S --noconfirm sc-im

# install htop for system monitoring

sudo pacman -S --noconfirm htop

# make four way screen split

echo -e "
split

split -v

focus down

split -v

focus up

focus left

screen -t bash /bin/bash

focus right

screen -t bash /bin/bash

focus left

focus down

screen -t bash /bin/bash

focus right

screen -t bash /bin/bash

focus up

focus left

" > /home/$USER/.screenrc.four_split

# make horizontal screen split

echo -e "
split

focus up

screen -t bash /bin/bash

focus down

screen -t bash /bin/bash

focus up

" > /home/$USER/.screenrc.hsplit

# make virtical screen split

echo -e "

split -v

focus left

screen -t bash /bin/bash

focus right

screen -t bash /bin/bash

focus left

" > /home/$USER/.screenrc.vsplit

# make ttysh help/selection

echo -e "\nHELP: j and k to go down and up. q to go to menu.

\nKey: \(\) denote shortcut keys, e.g. \(b\) means pressing the b key to get to the selector will load the \(b\)irthdays selection.


		Pinned/


		Internet/

			\(ly\)nx with image viewer/

			\(bro\)wsh web browser/

			\(brow\)sh configuration xorg/

			\(lib\)rewolf xorg/ 

			\(p\)ing jameschampion.xyz/

		Email/

			\(e\)mail/

			\(mu\)tt email configuation/

		Search/

			\(fi\)le manager/

			search & play video with \(t\)ty/or \(se\)earch & play with gui/

			\(fz\)f search files to open with Vim/

			search files to open with \(pdf\)/

			\(a\)rticles/

			\(w\)eather/

		Music/

			\(cm\)us/

			cmus-control: \(ne\)xt/ \(pr\)evious/ pa\(u\)se/ \(f\)orward/ \(st\)atus/

			\(al\)samixer/

			\(mus\)ic search on yt-dlp/

		Video/

			play your \(vid\)eos/

			\(l\)ist videos/

			video search on \(yt\)-dlp/

		Record/

			\(sc\)reenshot\(1,2,3,4,5,6\) TTY/

			\(re\)cord your TTY/s/

		Wordprocessing/

			\(wr\)iter/

		Calc/Spreadsheet/

			\(sp\)readsheet/

			\(ca\)lculator/

		Accessories/

			\(b\)irthdays/split/ 

			\(n\)otes/todos/split/ 

			\(d\)ate & calender/

		Backup/

			first run as sudo su!: \(di\)sk formatting and setting up removable media/

			*NOTE: RUN THE ABOVE ON REMOVABLE MEDIA BEFORE MAKING YOUR BACKUPS.

	 		first run as sudo su!: \(ba\)ckup /home/\$SUDO_USER/ to removable drive/

			first run sudo su!: \(ti\)meshift backup to removable drive/

			first run sudo su!: \(de\)lete timeshift backups from removable drive/

		New TTY/
				
			\(ch\)ange\(1,2,3,4,5,6\) TTY/

			*NOTE: cannot use this selection with screen split. Use alt+number or alt+arrow key instead

		Screen splits/

			\(scr\)een four panel split/

			\(scre\)en horizontal split/

			\(scree\)n vertical split/

		Close Xorg/

			close \(x\)org and go to TTY/

		System/Utilities

			\(up\)date the system/

			\(ht\)op/

			\(c\)lock/

			\(lo\)ck console/

			*NOTE: when you are using xorg/i3, press Ctrl + Alt + and an F key to go to the TTY
			      before you lock the console.

			\(res\)tart/

			\(sh\)utdown/

		Rerun/Help/Quit/

			rerun \(tty\)sh/

			\(h\)elp/

			edit \(hel\)p to add and remove your pinned selections

			\(q\)uit/

" > /home/$USER/.ttysh.selection

sudo mv splash_ttysh.png /home/$USER/.splash_ttysh.png
#sudo mv ttysh.sh /usr/local/bin/ttysh 
#chown root:root /usr/local/bin/ttysh

echo -e "\n	TTYSH Wizard has finished. Please exit out of TTYSH and reboot to complete.\n"
}

#
# functions for fzf
#

# function for fzf video search in the xorg/GUI
function fzfxorgvid(){
while [ $x = 0 ]; do

	echo -e "\nPress 's' to start Press 'q' to quit.\n"
	read answer
	case $answer in
	s)
	devour mpv "$(fzf)"
	x=0
	;;
	q)
	x=1
	;;
	esac
done
}

# function for fzf video in TTY
function fzfttyvid(){
while [ $x = 0 ]; do

	echo -e "\nPress 's' to start. Press 'q' to quit.\n"
	read answer
	case $answer in
	s)
	mpv "$(fzf)"
	x=0
	;;
	q)
	x=1
	;;
	esac
done
}

# function for fzf file search for vim
function fzfvim(){
while [ $x = 0 ]; do

	echo -e "\nPress 's' to start. Press 'q' to quit.\n"
	read answer
	case $answer in
	s)
	vim "$(fzf)"
	x=0
	;;
	q)
	x=1
	;;
	esac
done
}

# function for fzf pdf search
function fzfpdf(){
while [ $x = 0 ]; do

	echo -e "\nPress 's' to start. Press 'q' to quit.\n"
	read answer
	case $answer in
	s)
	sudo fbpdf-mupdf "$(fzf)"
	x=0
	;;
	q)
	x=1		
	;;
	esac
done
}

# function for yt-dlp
function yt(){

while [  $x = 0 ]; do

	echo -e "	\ny to enter video creator and video discription. x to download url from xclip.\n
 			\nyt to run again.\n
			\nq to quit\n"

	read answer
	echo
	case "$answer" in
	
	y)
	echo -e "	\nEnter the creator and discription.\n"
	read video
	echo
	yt-dlp -f 'bv*[height=480]+ba' "ytsearch1:$video"
	x=0
	;;
	x)
	yt-dlp -f 'bv*[height=480]+ba' "$url"
	x=0
	;;
	yt)
	yt
	x=1
	;;
	q)
	x=1
	;;
	esac
done
}

# function for music in yt-dlp
function ytmusic(){

while [ $x = 0 ]; do

	echo -e "	\nsm to enter creator and title. m to download music url from xclip.\n
			\nytm to run again.\n
			\nq to quit.\n"

	read answer
	echo
	case "$answer" in

	sm)
	echo -e "	\nEnter music creator and title.\n"
	read music
	yt-dlp -f 'ba' -x --audio-format mp3 "ytsearch1:$music"
	x=0
	;;
	m)
	yt-dlp -f 'ba' -x --audio-format mp3 $url
	x=0
	;;
	ytm)
	ytmusic
	x=1
	;;
	q)
	x=1
	;;
	esac
done
}

# function for searching weather in wttr.in

function weather(){
echo -e "\nEnter your city or town to see the weather forecast.\n"
read answer
curl wttr.in/$answer
}

# function for devour vid in xorg
function devourvid(){
if [ $splash = /dev/pts/ ]; then
	devour mpv /home/$USER/Videos/*
else	
	mpv /home/$USER/Videos/*
fi
}

# function for formating and setting up disks for rsync and timeshift
function diskformat(){

# format using fdisk

#variables

#functions

echo -e "\nStop! Have you run sudo su? y/n\n"
	read answer
	case $answer in
		y)
		x=1
		;;
		n)
		exit
		x=1
		;;
	esac

echo -e "\nThis is your current device storage. Do not insert your disk you wish to format yet...\n"

lsblk

echo -e "\nPlease insert the device that you want to format...\n
	 \nThis programme will resume in 10 second...\n"

sleep 10

lsblk

echo -e "\nPlease look for your inserted device above. Is it correct? y/n \n"
	read answer
	case $answer in
		y)
		x=1
		;;
		n)
		exit
		x=1
		;;
	esac

echo -e "\nPlease enter the name of your disk. e.g. 'sdb'. Do not enter any number, as these will be partitions, and we will be formatting the whole disk.
	\nBe careful not to format the wrong drive!\n"
	read answer

fdisk /dev/$answer

echo -e "\nWe need to now create your encrypted partition...\n"

lsblk

echo -e "\nWhat is the new partition name of your drive? e.g. 'sdb1' ?\n"
	read setuuid

cryptsetup luksFormat /dev/$setuuid

echo -e "\nWe need to now open the new encrypted drive.\n"

cryptsetup open /dev/$setuuid drive

echo -e "\nWe need to now add a file system. This will be ext4 filesystem.\n"

mkfs.ext4 /dev/mapper/drive

lsblk

echo -e "\nThe encrypted drive will now be closed...\n"

sync
cryptestup close drive

lsblk
ls -l /dev/disk/by-uuid/
ls -l /dev/disk/by-uuid/ | grep $setuuid | awk '{print $9}' | tr -d /.

echo -e "\nYou need to now add the UUID number of the disk you have setup for either file backups or system backups\n
	\nSee above, is this correct? y/n"
	read answer
	case $answer in
		y)
		x=1
		;;
		n)
		echo "Exiting script. Run again, or consult the developer for further instruction or support\n"
		x=1
		;;
	esac

echo -e "\nChoose what this disk will be used for. Press t for timeshift system backups or press f for file system backups\n"
	read answer
	
	case $answer in
		t)
		ls -l /dev/disk/by-uuid/ | grep $setuuid | awk '{print $9}' | tr -d /. > /home/$SUDO_USER/.uuidtimeshift
		x=1
		;;
		f)
		ls -l /dev/disk/by-uuid/ | grep $setuuid | awk '{print $9}' | tr -d /. > /home/$SUDO_USER/.uuidfiles
		x=1
		;;	
	esac

echo -e "\nThis drive is now ready to be used either file backup, or system backup, depending on your previous selection.\n
	\nIMPORTANT NOTE: IF YOU ARE USING A NEWLY SETUP DISK FOR SYSTEM BACKUPS FOR THE FIRST TIME -
	\nYOU MUST RUN 'timeshift-gtk' IN A TERMINAL IN XORG AND RUN THE SETUP WIZARD, SELECTING THIS DISK TO AVOID ERRORS.\n
	\nTHEN PRESS THE 'create' BUTTON.\n
	\nComplete. Closing."
}

# function for timeshift backups
# function for starting the timeshift process
function starttimeshift(){

	echo
	lsblk
	#sed -n 32p $SUDO_USER/timebackup.sh
	echo -e "\nStop! Have you run sudo su? Is /dev/$tdevname location correct? y/n\n"
	read answer

	case "$answer" in
		y)
		echo -e "\nContinuing...\n"
		cryptsetup open /dev/$tdevname $tencryptedname
		timeshift --create --snapshot-device /dev/mapper/$tencryptedname
		;;
		n)
		exit
		;;
	esac
}

# function for closing the drive after timeshift
function closetimeshift(){
		
	echo
	lsblk
	echo -e "\nDoes the /dev/mapper/$tencryptedname need unmounting? check MOUNTPOINT. press y for umount or n to exit\n"
	read answer

	case "$answer" in
		y)
		echo -e "\nComplete. Closing...\n"
		umount $tunmounting
		sync
		cryptsetup close $tencryptedname
		exit
		lsblk
		echo -e "\nYour storage should be correct. Finished.\n"
		$tuuid=1
		;;
		n)
		echo -e "\nComplete. Closing...\n"
		sync
		cryptsetup close $tencryptedname
		lsblk
		echo -e "\nYour storage should be correct. Finished.\n"
		exit
		$tuuid=1
		;;
	esac
}

# function for checking drive is correct
function tdrivecheck(){

	echo
	lsblk
	echo -e "\nStop! Have you run sudo su? Is /dev/$tdevname location correct? y/n\n"
	read answer

	case "$answer" in
		y)
		echo -e "\nContinuing...\n"
		cryptsetup open /dev/$tdevname $tencryptedname
		$tuuid=1
		;;
		n)
		exit
		$tuuid=1
		;;
	esac
}

# function for deleting timehsift backups
function timedelete(){

while [ $tuuid = $tdrive ]; do

	echo -e "\nDo you want to delete a backup? press d to continue\n
		\nq to exit\n"

	read answer

	case "$answer" in 
		d)
		echo -e "\nEnter the full matching name of the backup.\n"	
		read delete
		timeshift --delete --snapshot $delete
		x=0
		;;
		q)
		if [ $tdevname = $tencryptedname ]; then 
			sync
			cryptsetup close $tencryptedname
			lsblk
			echo -e "\nYour storage should be correct. Finished.\n"
			exit;
		else
			closetimeshift	
		fi
		$tuuid=1
		;;
	esac
done
}

# function for starting main timeshift backup deletions
function maintdelete(){

if [ $tuuid = $tdrive ]; then
	echo -e "\nStarting...\n";
else
	echo -e "\nDrive is not found.\n";
	exit
fi

while [ $tuuid = $tdrive ]; do

tdrivecheck
timeshift --list
timedelete

done
}

# function main for timeshift
function maintimeshift(){

if [ $tuuid = $tdrive ]; then
	echo -e "\nStarting...\n"
else
	echo -e "\nDrive is not found.\n"
	exit
fi

while [ $tuuid = $tdrive ]; do
	
starttimeshift
closetimeshift

done
}

# function for filebackup
function filebackup(){
echo "Awaiting $buuid"

if [ $buuid = $bdrive ]; then
	echo -e "\nStarting...\n";
else
	echo -e"\nDrive is not found.\n";
	exit
fi

while [ $buuid = $bdrive ]; do
	echo
	lsblk
	#sed -n 31p $SUDO_USER/backup.sh
	echo -e "\nStop! Have you run sudo su first? Have you saved your latest bookmarks? Is /dev/$bdevname correct? y/n\n" 
	read answer

	case "$answer" in
		y)
		echo -e "\nContinuing...\n"
		cryptsetup open /dev/$bdevname drive
		# enter password
		mount /dev/mapper/drive /mnt
		rsync -av /home/$SUDO_USER/ /mnt --delete
		sync
		umount /mnt
		cryptsetup close drive 
		echo -e "\nComplete. Closing...\n"
		exit
		$buuid=1
		;;
		n)
		exit
		$buuid=1
		;;
	esac
done
}

# date
function planner(){

echo -e "\nThe time and date is:\n"
date

# calender
echo -e "\nThis month's calender:\n"
cal
echo -e "\npress q when ready...\n" | less

# cat out notes/todo
echo 
cat /home/$USER/info/notes.txt | less
echo 

clear
echo
selection
}

# function for selecting everything
function selection(){
while [ $x = 0 ]; do

echo -e "\n	awaiting...\n"

	read answer

	case "$answer" in
		cm)
		cmus
		x=0
		;;
		ne)
		cmus-remote -n
		x=0
		;;
		pr)
		cmus-remote -r
		x=0
		;;
		u)
		cmus-remote -u
		x=0
		;;
		f)
		cmus-remote -k +5
		x=0
		;;
		st)
		cmus-remote -Q | less
		x=0
		;;
		al)
		alsamixer
		x=0
		;;
		yt)
		cd /home/$USER/Videos/
		yt
		x=0
		;;
		mus)
		cd /home/$USER/Music/
		ytmusic
		x=0
		;;
		ly)
			echo -e "\nStop! It is recommended to run lynx browser offline for your saved webpages. 
			\nUse Browsh/Librewolf for web online browsing and saving webpages for later. 
			\nAre you offline? Do you want to continue? y/n\n"
			read answer
			case $answer in
			y)
			screen -c /home/$USER/.screenrc.lynx
			x=0
			;;
			n)
			x=1
			;;	
			esac
		x=0
		;;
		bro)
		echo -e "\nTips: prefix 'searx.be/search?q=' or 'wiby.me/?q=' in the URL to search.\n"
		#sudo gpm -m /dev/psaux -t ps2
		# searching: searx.be/search?q=
		# searching: wiby.me/?q=
		# browsh --firefox.path /usr/bin/librewolf
		browsh
		x=0
		;;
		brow)
		browsh --firefox.with-gui
		x=0
		;;
		lib)
		devour librewolf
		x=0
		;;
		p)
		ping jameschampion.xyz
		x=0
		;;
		b)
		screen -c /home/$USER/.screenrc.birthdays_split	
		x=0
		;;
		n)
		screen -c /home/$USER/.screenrc.notes_split
		x=0
		;;
		mu)
		screen -c /home/$USER/.screenrc.mutt_conf
		x=0
		;;
		d)
		cal; date; echo -e "\nq to return to planner\n" | less
		x=0
		;;
		c)
		watch -n 1 date
		x=0
		;;
		r)
		screen -c /home/$USER/.screenrc.rss
		x=0
		;;
		e)
		mutt
		x=0
		;;
		a)
		screen -c /home/$USER/.screenrc.articles 
		;;
		sta)
		startx
		x=0
		;;
		l)
		screen -c /home/$USER/.screenrc.videos 
		x=0
		;;
		vid)
		devourvid
		x=0
		;;
		fi)
		vim /home/$USER/
		x=0
		;;
		se)
		fzfxorgvid
		x=0
		;;
		t)
		fzfttyvid	
		x=0
		;;
		fz)
		fzfvim	
		x=0
		;;
		w)
		weather
		x=0
		;;
		pdf)
		fzfpdf
		x=0
		;;
		v)
		vim 0 -c "set laststatus=0" -o /home/$USER/proj/working_on/*YEN/drafts/*1  
		x=0
		;;
		v1)
		vim /home/$USER/proj/working_on/*YEN/characters/* -o /home/$USER/proj/working_on/*YEN/notes/*screenplay_notes -o /home/$USER/proj/working_on/*YEN/notes/*prompt_notes -o /home/$USER/proj/working_on/*YEN/notes/*archive_notes
		x=0
		;;
		di)
		diskformat
		x=0
		;;
		ba)
		filebackup
		x=0
		;;
		ti)
		maintimeshift
		x=0
		;;
		de)
		maintdelete	
		x=0
		;;
		x)
		kill $xorg
		x=1
		;;
		lo)
		vlock -a
		x=0
		;;
		sc1)
		sudo fbgrab -c 1 screenshot1.png
		x=0
		;;
		sc2)
		sudo fbgrab -c 2 screenshot2.png
		x=0
		;;
		sc3)
		sudo fbgrab -c 3 screenshot3.png
		x=0
		;;
		sc4)
		sudo fbgrab -c 4 screenshot4.png
		x=0
		;;
		sc5)
		sudo fbgrab -c 5 screenshot5.png
		x=0
		;;
		sc6)
		sudo fbgrab -c 6 screenshot6.png
		x=0
		;;
		re)
		sudo ffmpeg -f fbdev -framerate 10 -i /dev/fb0 ttyrecord.webm
		x=0
		;;
		wr)
		vim
		x=0
		;;
		ca)
		python
		x=0
		;;
		sp)
		sc-im
		x=0
		;;
		ht)
		htop
		x=0
		;;
		scr)
		screen -c /home/$USER/.screenrc.four_split
		x=0
		;;
		scre)
		screen -c /home/$USER/.screenrc.hsplit
		x=0
		;;
		scree) 
		screen -c /home/$USER/.screenrc.vsplit
		x=0
		;;
		ch1)
		chvt 1
		x=0
		;;
		ch2)
		chvt 2
		x=0
		;;
		ch3)
		chvt 3
		x=0
		;;
		ch4)
		chvt 4
		x=0
		;;
		ch5)
		chvt 5
		x=0
		;;
		ch6)
		chvt 6
		x=0
		;;
		tty)
		ttysh
		x=1
		;;
		up)
		echo
		sudo pacman -Syu
		echo
		yay -Syu
		echo -e "\n You should now exit TTYSH and reboot your system to complete any new updates.\n"
		x=0
		;;	
		res)
		sudo reboot
		x=1
		;;
		sh)
		sudo poweroff
		x=1
		;;
		h)
		ttyshhelp
		x=0
		;;
		q)
		echo
		x=1
		;;	
	esac
done
}


#
# PROGRAMME START
# 

clear

#clear replaces /dev/null and variations as they crash mpv
#[[ ]] needs work, and is forcing an enter key press to continue after mpv and clear
#[[ -f /usr/local/bin/ttyhs ]] && [[ -f /home/$USER/.splash_ttysh.png ]]; mpv /home/$USER/.splash_ttysh.png; clear; || echo "If you are using this for the first time, configuration is required. Do you want to continue? y/n"
#	read answer
#	case "$answer" in
#		y)
#		echo "true"; exit
#		;;
#		n)
#		echo "false"; exit
#		;;
#	esac

# --no-terminal breaks in the TTY, --really-quiet is used as best alternative
if [ -f /usr/local/bin/ttysh ]; then
	splashscreen
	#mpv --really-quiet /home/$USER/.splash_ttysh.png; clear
else
	echo -e "\First time using TTYSH, or you do not yet have TTYSH setup and configured? Press y to begin setup, or press n to exit.\n"
	read answer

	case "$answer" in
		y)
		wizardttysh
		;;
		n)
		echo "exiting"; exit 
		;;
		esac
fi

echo -e "\n  TTYSH\n"

while [ $x = 0 ]; do

	echo -e "\n  (c)ontinue, (s)election, (h)elp, edit (hel)p, (config) wizard, or (q)uit?\n" 
		
	read intro

	case "$intro" in
	c)
	clear
	planner
	selection
	x=1
	;;	
	s)
	selection
	x=1
	;;
	h)
	ttyshhelp
	x=0
	;;
	config)
	wizardttysh
	x=0
	;;
	hel)
	vim /home/$USER/.ttysh.selection
	x=0
	;;
	q)
	echo
	x=1
	;;
	esac
done



