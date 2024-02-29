#!/bin/sh

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
#xorg=$(ps aux | grep -i xorg | awk '{print }' | sed -n '1p')


#
# FUNCTIONS
# 

# $1 arguments selection list
helpflags () {

options=$(printf "\n%s\n" "ttyshhelp fzfcmus websearch bookmarkcheck fzfxorgvid fzfttyvid fzfvim fzfpdf yt ytmusic weather planner" | tr ' ' '\n' | fzf -i --prompt "Pick the option that you would like: ")

#clear

"$options"
}

# sudo user check
sudocheck () {

[ ! "$SUDO_USER" ] && printf "\n%s\n\n" "Run as sudo su first! Exiting..." && exit || printf "\n%s\n\n%s\n\n" "Checking you are running as sudo user..." "Continuing..."
}

# /dev/mapper/drive check for timeshift
mappercheck () {

[ ! -h /dev/mapper/timeshiftbackup ] && printf "\n\n%s\n\n" "cryptsetup has failed to open /dev/mapper/timeshiftbackup from /dev/"$tdevname" . Make sure you are entering the correct password, or check your devices and mountpoints. Running lsblk and exiting..." && lsblk && exit || printf "\n\n%s\n\n" "dev/mapper/timeshiftbackup found. Continuing..." 
}

# function for tty or pts splash screen
splashscreen () {

#[ "$splash" = /dev/pts/ ] && devour mpv --really-quiet /home/"$USER"/.splash_ttysh.png && clear || mpv --really-quiet /home/"$USER"/.splash_ttysh.png && clear

[ "$splash" = /dev/pts/ ] && devour mpv --really-quiet /home/"$USER"/.splash_ttysh.png || mpv --really-quiet /home/"$USER"/.splash_ttysh.png

#if [ "$splash" = /dev/pts/ ]; then
#	devour mpv --really-quiet /home/"$USER"/.splash_ttysh.png; clear
#else	
#	mpv --really-quiet /home/"$USER"/.splash_ttysh.png; clear
#fi

}

# function for shortcuts selection 
ttyshhelp () {

less /home/"$USER"/.ttysh.selection 
}

# function for TTYSH configuration
wizardttysh () {
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

# install bc

sudo pacman -S --noconfirm bc

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

printf "%b" '--image-display-duration=1000' >> /home/"$USER"/.config/mpv/mpv.conf

#try %b with \ to try and escape characters
printf "%b\n\n%b\n\n%b\n\n%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n%b" '#!/bin/bash' 'x=0' 'while [ "$x" = 0 ]; do' 'printf "\\n%b\\n" "Press c to start your search. Press q to exit"' 'read -p "Enter your selection: " answer' 'case "$answer" in' 'c)' 'mpv "$(find /home/"$USER"/Downloads | fzf -i)"' 'x=0' ';;' 'q)' 'x=1' ';;' 'esac' 'done' > /home/"$USER"/.mpv_fzf_screen.sh

chmod +x /home/"$USER"/.mpv_fzf_screen.sh

printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'focus up' 'chdir /home/"$USER"/Downloads' 'screen -t bash /bin/bash' 'screen -t ./mpv_fzf_screen.sh /home/"$USER"/.mpv_fzf_screen.sh' 'focus down' 'screen -t lynx /usr/bin/lynx /home/"$USER"/Downloads' > /home/"$USER"/.screenrc.lynx

# install browsh web browser

yay -S --noconfirm browsh

# install librewolf

yay -S --noconfirm librewolf-bin

# install arkenfoxuser.js

yay -S --noconfirm arkenfox-user.js

# install vim, and make the .screenrc.birthdays_split file

sudo pacman -S --noconfirm vim

mkdir /home/"$USER"/info

printf "\n%s\n" "BIRTHDAYS" > /home/"$USER"/info/birthdays.txt

printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'focus up' 'screen -t vim /usr/bin/vim /home/"$USER"/info/birthdays.txt' 'focus down' 'chdir /home/"$USER"/' 'screen -t bash /bin/bash' 'focus up' > /home/"$USER"/.screenrc.birthdays_split

# make notes file and the sceenrc_notes_split

printf "\n%s\n" "NOTES" > /home/"$USER"/info/notes.txt

printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'focus up' 'screen -t vim /usr/bin/vim /home/"$USER"/info/notes.txt' 'focus down' 'chdir /home/"$USER"/' 'screen -t bash /bin/bash' 'focus up' > /home/"$USER"/.screenrc.notes_split

# install newsboat and make the .screenrc.rss and the yt.sh script

sudo pacman -S --noconfirm newsboat

printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n\t%b\n\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\n%b" '#!/bin/bash' '# A script for yt-dlp with search arguments.' 'x=0' 'url=$(xclip -o 2> /dev/null)' 'while [ "$x" = 0 ]; do' 'echo "y to enter video creator and video discription. x to download url from xclip. m to download music url from xclip. q to quit. yt to run again."' 'read -p "Enter your selection: " answer' 'case "$answer" in' 'y)' 'echo "Enter the creator and discription."' 'read video' "yt-dlp -f 'bv*[height=480]+ba' \"ytsearch1:\"\"\$video\"\"\"" 'x=0' ';;' 'x)' "yt-dlp -f 'bv*[height=480]+ba' \"\$url\"" 'x=0' ';;' 'm)' "yt-dlp -f 'ba' -x --audio-format mp3 \"\$url\"" 'x=0' ';;' 'yt)' '/home/"$USER"/./.yt.sh' 'x=1' ';;' 'q)' 'x=1' ';;' 'esac' 'done' > /home/"$USER"/.yt.sh

chmod +x /home/"$USER"/.yt.sh

printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n" 'split' 'focus up' 'screen -t newsboat /usr/bin/newsboat' 'focus down' 'chdir /home/"$USER"/Videos/' 'screen -t bash /bin/bash' 'screen -t ./yt.sh /home/"$USER"/.yt.sh' 'focus up' > /home/"$USER"/.screenrc.rss

# install mutt email and make muttrc for configuration

sudo pacman -S --noconfirm mutt

mkdir -p /home/"$USER"/.config/mutt/ && touch /home/"$USER"/.config/mutt/muttrc

printf "%b\n%b\n\n%b\n%b\n%b\n\n%b\n%b\n%b\n%b\n\n%b" 'set folder = "imaps://"' 'set smtp_url = "smtp://"' 'set from = ""' 'set realname = ""' 'set editor = "vim"' 'set spoolfile = "+INBOX"' 'set record = "+Sent"' 'set trash = "+Trash"' 'set postponed = "+Drafts"' 'mailboxes =INBOX =Sent =Trash =Drafts =Junk' > /home/"$USER"/.config/mutt/muttrc

# make mutt config screen split

printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'focus up' 'screen -t vim /usr/bin/vim /home/"$USER"/.config/mutt/muttrc' 'focus down' 'chdir /home/"$USER"/.config/mutt/' 'screen -t bash /bin/bash' 'focus up' > /home/"$USER"/.screenrc.mutt_conf

# make screen config for listing saved articles

printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'focus up' 'screen -t vim /usr/bin/vim /home/"$USER"/Downloads' 'focus down' 'chdir /home/"$USER"/Downloads' 'screen -t bash /bin/bash' 'focus up' > /home/"$USER"/.screenrc.articles

# install xorg-server, i3, etc... and make the various configuration files

sudo pacman -S --noconfirm xorg-server
sudo pacman -S --noconfirm xorg-xinit
sudo pacman -S --noconfirm i3-wm
sudo pacman -S --noconfirm xterm

printf "%s" "exec i3" > /home/"$USER"/.xinitrc

printf "%b\n%b\n%b\n%b\n\n\n%b\n%b\n\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b" '#URxvt*background: black' '#URxvt*foreground: white' '#URxvt*font: xft:monospace:size=12' '#URxvt*scrollBar: false' 'XTerm.vt100.foreground: white' 'XTerm.vt100.background: black' 'xterm*faceName: Monospace' 'xterm*faceSize: 12' 'XTerm*font: -*-terminus-medium-*-*-*-18-*-*-*-*-*-iso10646-1' '# unreadable' 'XTerm*font1: -*-terminus-medium-*-*-*-12-*-*-*-*-*-iso10646-1' '# tiny' 'XTerm*font2: -*-terminus-medium-*-*-*-14-*-*-*-*-*-iso10646-1' '# small' 'XTerm*font3: -*-terminus-medium-*-*-*-16-*-*-*-*-*-iso10646-1' '# medium' 'XTerm*font4: -*-terminus-medium-*-*-*-22-*-*-*-*-*-iso10646-1' '# large' 'XTerm*font5: -*-terminus-medium-*-*-*-24-*-*-*-*-*-iso10646-1' '# huge' 'XTerm*font6: -*-terminus-medium-*-*-*-32-*-*-*-*-*-iso10646-1' > /home/"$USER"/.Xdefaults

printf "%b\n%b\n%b\n%b\n%b\n\n%b\n%b\n%b\n%b\n%b\n%b\n%b" 'XTerm.vt100.foreground: white' 'XTerm.vt100.background: black' 'XTerm.vt100.color0: rgb:28/28/28' '! ...' 'XTerm.vt100.color15: rgb:e4/e4/e4XTerm.vt100.reverseVideo: true# default' 'XTerm*font: -*-terminus-medium-*-*-*-18-*-*-*-*-*-iso10646-1' 'XTerm*font1: -*-terminus-medium-*-*-*-12-*-*-*-*-*-iso10646-1' 'XTerm*font2: -*-terminus-medium-*-*-*-14-*-*-*-*-*-iso10646-1' 'XTerm*font3: -*-terminus-medium-*-*-*-16-*-*-*-*-*-iso10646-1' 'XTerm*font4: -*-terminus-medium-*-*-*-22-*-*-*-*-*-iso10646-1' 'XTerm*font5: -*-terminus-medium-*-*-*-24-*-*-*-*-*-iso10646-1' 'XTerm*font6: -*-terminus-medium-*-*-*-32-*-*-*-*-*-iso10646-1' > /home/"$USER"/.Xresources

# make screen list videos config

printf "%b\n\n%b" '#!/bin/bash' 'mpv "$(find /home/"$USER"/Videos | fzf -i)"' > /home/"$USER"/.mpv_fzf_screen_videos.sh

chmod +x /home/"$USER"/.mpv_fzf_screen_videos.sh

printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'focus up' 'screen -t vim /usr/bin/vim /home/"$USER"/Videos' 'focus down' 'chdir /home/"$USER"/Videos' 'screen -t bash /bin/bash' 'screen -t ./mpv_fzf_screen_videos.sh /home/"$USER"/.mpv_fzf_screen_videos.sh' 'focus up' > /home/"$USER"/.screenrc.videos

# install jfbview and mupdf

sudo pacman -S --noconfirm mupdf
yay -S --noconfirm jfbview

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

printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'split -v' 'focus down' 'split -v' 'focus up' 'focus left' 'screen -t bash /bin/bash' 'focus right' 'screen -t bash /bin/bash' 'focus left' 'focus down' 'screen -t bash /bin/bash' 'focus right' 'screen -t bash /bin/bash' 'focus up' 'focus left' > /home/"$USER"/.screenrc.four_split

# make horizontal screen split

printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'focus up' 'screen -t bash /bin/bash' 'focus down' 'screen -t bash /bin/bash' 'focus up' > /home/"$USER"/.screenrc.hsplit

# make virtical screen split

printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split -v' 'focus left' 'screen -t bash /bin/bash' 'focus right' 'screen -t bash /bin/bash' 'focus left' > /home/"$USER"/.screenrc.vsplit

printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'focus up' 'screen -t vim /usr/bin/vim /usr/share/kbd/consolefonts' 'focus down' 'screen -t vim /usr/bin/vim /etc/vconsole.conf' 'focus up' > /home/"$USER"/.screenrc.vsplit

# make ttysh help/selection

printf "\n%b\n\n%b\n\n\t\t%b\n\n%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n" 'HELP: j and k to go down and up. q to go to menu.' 'Key: () denote shortcut keys, e.g. (b) means pressing the b key to get to the selector will load the (b)irthdays selection.' 'Pinned/' 'Internet/' '(ly)nx with image viewer/' '(bro)wsh web browser/' '(brow)sh configuration xorg/' '(lib)rewolf xorg/' '(p)ing jameschampion.xyz/' 'Email/' '(e)mail/' '(mu)tt email configuation/' 'Search/' '(fi)le manager/' 'search & play video with (t)ty/or (se)earch & play with gui/' '(fz)f search files to open with Vim/' 'search images and pdfs (pdf)/' '(a)rticles/' '(w)eather/' 'Music/' '(cm)us/' 'cmus-control: (ne)xt/ (pr)evious/ pa(u)se/ (f)orward/ (st)atus/' '(al)samixer/' '(mus)ic search on yt-dlp/' 'Video/' 'play your (vid)eos/' '(l)ist videos/' 'search and (del)ete files' 'NOTE: the above command will only work effectively on properly named files. Try the command below:' 'remove (wh)ite spaces from file names/' 'video search on (yt)-dlp/' 'Record/' '(sc)reenshot(1,2,3,4,5,6) TTY/' '(re)cord your TTY/s/' 'Wordprocessing/' '(wr)iter/' 'Calc/Spreadsheet/' '(sp)readsheet/' '(ca)lculator/' 'Accessories/' '(b)irthdays/split/' '(n)otes/todos/split/' '(d)ate & calender/' 'Backup/' 'first run as sudo su!: (di)sk formatting and setting up removable media/' '*NOTE: RUN THE ABOVE ON REMOVABLE MEDIA BEFORE MAKING YOUR BACKUPS.' 'first run as sudo su!: (ba)ckup /home/"$SUDO_USER"/ to removable drive/' 'first run sudo su!: (ti)meshift backup to removable drive/' 'first run sudo su!: (de)lete timeshift backups from removable drive/' 'TTY/' '(scro)llback information for TTY/' '(ch)ange(1,2,3,4,5,6) TTY/' '*NOTE: cannot use this selection with screen split. Use alt+number or alt+arrow key instead' 'Screen splits/' '(scr)een four panel split/' '(scre)en horizontal split/' '(scree)n vertical split/' 'Close Xorg/' 'close (x)org and go to TTY/' 'System/Utilities' '(fo)nt and text change' '(up)date the system/' '(ht)op/' '(fr)ee disk space' '(c)lock/' '(lo)ck console/' '*NOTE: when you are using xorg/i3, press Ctrl + Alt + and an F key to go to the TTY' 'before you lock the console.' '(res)tart/' '(sh)utdown/' 'Rerun/Help/Quit/' 'rerun (tty)sh/' '(h)elp/' 'edit (hel)p to add and remove your pinned selections' '(q)uit/' > /home/"$USER"/.ttysh.selection

sudo mv splash_ttysh.png /home/"$USER"/.splash_ttysh.png
#sudo mv ttysh.sh /usr/local/bin/ttysh 
#chown root:root /usr/local/bin/ttysh

printf "\n%s\n" "TTYSH Wizard has finished. Please exit out of TTYSH and reboot to complete."
}


#
# functions for fzf
#


# pick music track to play in cmus remotely
fzfcmus () {

pscmus=$(ps aux | grep -i "[c]mus" | cut -d " " -f22)

[ ! "$pscmus" = cmus ] && screen -c /home/"$USER"/.screenrc.cmusplay && return || cmuspicker=$(find /home/"$USER"/Music/starred/ -type f | fzf -i --prompt "Pick the music track you want to play in cmus: ") && cmus-remote -f "$cmuspicker" && cmus-remote -Q && printf "\n" ""
}

# fzfbookmark case statement
casefzfbookmark () {

while [ 1 ]; do

	printf "\n%s\n\n" "Pick f for firefox or l for librewolf:"

	read -p "Enter your selection: " xbrowser

	case "$xbrowser" in 

		f) 
		devour firefox "$bookmark"
		break
		;;
		l)
		devour librewolf "$bookmark"
		break
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac 
done

#[ "$splash" = /dev/pts/ ] && read -p "Pick f for firefox or l for librewolf: " xbrowser && case "$xbrowser" in 
#
#										        f) 
#											[ "$splash" = /dev/pts/ ] && devour firefox "$bookmark" || browsh --startup-url "$bookmark" 
#											;;
#											l)
#											[ "$splash" = /dev/pts/ ] && devour librewolf "$bookmark" || browsh --startup-url "$bookmark" 

}

# pick a bookmark to open in TTY or X11 using the appropriate web browser
fzfbookmark () {

printf "\n" ""

bookmark=$(cat /home/"$USER"/.bookmarks_ttysh.html | fzf -i --prompt "Pick a bookmark: ") 

[ "$splash" = /dev/pts/ ] && casefzfbookmark && return || browsh --startup-url "$bookmark"
	
#printf "\n" ""
#
#
#
#[ "$splash" = /dev/pts/ ] && read -p "Pick f for firefox or l for librewolf: " xbrowser && case "$xbrowser" in 
#
#										        f) 
#											[ "$splash" = /dev/pts/ ] && devour librewolf "$bookmark" || browsh --startup-url "$bookmark" 
#											;;
#											l)
#											[ "$splash" = /dev/pts/ ] && devour librewolf "$bookmark" || browsh --startup-url "$bookmark" 
#											;;
#									       esac
#

#[ "$splash" = /dev/pts/ ] && devour librewolf "$bookmark" || browsh --startup-url "$bookmark" 

}

# check for bookmark file
bookmarkcheck () {

[ -e /home/"$USER"/.bookmarks_ttysh.html ] && printf "\n%s\n" "Bookmarks file found." && fzfbookmark && return || printf "\n%s\n" "Bookmarks file not found." && touch /home/"$USER"/.bookmarks_ttysh.html && printf "\n%s\n" "Created." && sleep 1 && printf "\n%s\n" "Remember to add your bookmarks manually, or export them from librewolf. If exported or updated, run the 'boo' command. See help for more info. Starting in 10 seconds." && sleep 10 && return
}

# format bookmarks for fzfbookmark
bookmarkformat () {

formathtml=$(find /home/"$USER"/ -name '*.html' | fzf -i --prompt "Note: if you already have a /home/"$USER"/.bookmarks_ttysh.html file, it will be overwritten. Pick the html file you want to format: ")

sed 's/\ /\n/g' "$formathtml" | grep "https\?" | cut -d '"' -f2 | grep "https\?" | grep -v "^fake-favicon-uri" > /home/"$USER"/.bookmarks_ttysh.html

printf "\n%s\n" "Your /home/"$USER"/.bookmarks_ttysh.html is now formatted for the 'bo' command"
}

# websearch case statement
casewebsearch () {

while [ 1 ]; do

	printf "\n%s\n\n" "Pick f for firefox or l for librewolf:"

	read -p "Enter your selection: " xbrowser

	case "$xbrowser" in 

		f) 
		printf "\n" ""
		read -p "Search: " webpick
		devour firefox searx.be/search?q="$webpick"
		break
		;;
		l)
		printf "\n" ""
		read -p "Search: " webpick
		devour librewolf searx.be/search?q="$webpick"
		break
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac 
done
}

# search the internet
websearch () {

printf "\n" ""

[ "$splash" = /dev/pts/ ] && casewebsearch && return || read -p "Search: " webpick && browsh --startup-url searx.be/search?q="$webpick"
	
#[ $splash" = /dev/pts/ ] && devour librewolf searx.be/search?q="$webpick" || browsh --startup-url searx.be/search?q="$webpick"
}

# function for fzf video search in the xorg/GUI
fzfxorgvid () {

while [ 1 ]; do

	printf "\n%s\n" "Press s to start Press q to quit."

	read -p "Enter you selection: " answer

	case "$answer" in
		s)
		devour mpv "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the video you want to watch in the GUI: ")"
		;;
		q)
		break
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for fzf video in TTY
fzfttyvid () {

while [ 1 ]; do

	printf "\n%s\n" "Press s to start. Press q to quit."

	read -p "Enter your selection: " answer

	case "$answer" in
		s)
		mpv "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the video you want to watch in the TTY: ")"
		;;
		q)
		break
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done

#while [ "$x" = 0 ]; do
#
#	printf "\n%s\n" "Press s to start. Press q to quit."
#
#	read -p "Enter your selection: " answer
#
#	case "$answer" in
#		s)
#		mpv "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the video you want to watch in the TTY: ")"
#		x=0
#		;;
#		q)
#		x=1
#		;;
#		*)
#		printf "\n%s\n" "Not a valid selection."
#		x=0
#		;;
#	esac
#done

}

# function for fzf file search for vim
fzfvim () {

while [ 1 ]; do

	printf "\n%s\n" "Press s to start. Press q to quit."

	read -p "Enter your selection: " answer

	case "$answer" in
		s)
		vim "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the file you want to open in vim: ")"
		;;
		q)
		break	
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for fzf pdf search
fzfpdf () {

while [ 1 ]; do

	printf "\n%s\n" "Press s to start. Press q to quit."

	read -p "Enter your selection: " answer

	case "$answer" in
		s)
		sudo jfbview "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the pdf you want to view. ESC to exit: ")"
		;;
		q)
		break		
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for fzf file search and deletion
fzfdelete () {

while [ 1 ]; do

	printf "\n%s\n" "Press s to start. Press q to quit."

	read -p "Enter your selection: " answer

	case "$answer" in
		s)
		rm -iv $(find /home/"$USER"/ -type f | fzf -i --multi --prompt "Pick the file for deletion. ESC to exit: ")
		;;
		q)
		break	
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for fzf directory and file search to remove white space
fzfwhitespace () {

while [ 1 ]; do

	printf "\n%s\n" "Press s to start. Press q to quit."

	read -p "Enter your selection: " answer

	case "$answer" in
		s)
		chosendir="$(find /home/"$USER"/ | fzf -i --prompt "Pick the directory with the files names that you want to remove white space from: ")"
		for file in "$chosendir"/*
		do
			read -p "Did you pick something, or do you want to quit? Press c to continue, or e to exit: " pick
			case "$pick" in
				c)
				mv "$file" "$(echo "$file" | sed -e 's/\ /_/g')"
				break
				;;
				e)
				break
				;;
				*)
				printf "\n%s\n" "Not a valid selection."
				;;
			esac
		done
		;;
		q)
		break	
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for yt-dlp
yt () {

while [ 1 ]; do

	printf "\n%s\n" "y to enter video creator and video discription. x to download url from xclip. yt to run again. q to quit"

	read -p "Enter your selection: " answer

	printf "\n%s\n" ""

	case "$answer" in
		y)
		printf "\n%s\n" "Enter the creator and discription: "
		read video
		printf "\n%s\n"	""
		yt-dlp -f 'bv*[height=480]+ba' "ytsearch1:""$video"""
		;;
		x)
		url=$(xclip -o)
		yt-dlp -f 'bv*[height=480]+ba' "$url"
		;;
		yt)
		yt
		break
		;;
		q)
		break
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for music in yt-dlp
ytmusic () {

while [ 1 ]; do

	printf "\n%s\n"	"sm to enter creator and title. m to download music url from xclip. ytm to run again. q to quit."

	read -p "Enter your selection: " answer

	printf "\n%s\n" ""

	case "$answer" in
		sm)
		printf "\n%s\n" "Enter music creator and title: "
		read music
		yt-dlp -f 'ba' -x --audio-format mp3 "ytsearch1:""$music"""
		;;
		m)
		url=$(xclip -o)
		yt-dlp -f 'ba' -x --audio-format mp3 "$url"
		;;
		ytm)
		ytmusic
		break
		;;
		q)
		break
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for searching weather in wttr.in
weather () {

printf "\n%s\n" "Enter your city or town to see the weather forecast: "

read answer

curl wttr.in/"$answer"
#wget -qO- wttr.in/"$answer"
}

# function for devour vid in xorg
devourvid () {

[ "$splash" = /dev/pts/ ] && devour mpv /home/"$USER"/Videos/* || mpv /home/"$USER"/Videos/*

#if [ "$splash" = /dev/pts/ ]; then
#	devour mpv /home/"$USER"/Videos/*
#else	
#	mpv /home/"$USER"/Videos/*
#fi

}

# function for formating and setting up disks for rsync and timeshift
diskformat () {

sudocheck

while [ 1 ]; do

	printf "\n%s\n" "Stop! Have you run sudo su? y/n"

	read -p "Enter your selection: " answer

	case "$answer" in
		y)
		break
		;;
		n)
		exit
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done

printf "\n%s\n" "This is your current device storage. Do not insert your disk you wish to format yet..."

lsblk

printf "\n%s\n%s\n" "Please insert the device that you want to format..." "This programme will resume in 10 second..."

sleep 10

lsblk

while [ 1 ]; do

	printf "\n%s\n" "Please look for your inserted device above. Is it correct? y/n"

	read -p "Enter your selection: " answer

	case "$answer" in
		y)
		break
		;;
		n)
		exit
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done

printf "\n%s\n%s\n" "\nPlease enter the name of your disk. e.g. sdb. Do not enter any number, as these will be partitions, and we will be formatting the whole disk." "Be careful not to format the wrong drive!"

	read answer

fdisk /dev/"$answer"

printf "\n%s\n" "We need to now create your encrypted partition..."

lsblk

printf "\n%s\n" "What is the new partition name of your drive? e.g. sdb1 ?"
	read setuuid

cryptsetup luksFormat /dev/"$setuuid"

printf "\n%s\n" "We need to now open the new encrypted drive."

cryptsetup open /dev/"$setuuid" drive

printf "\n%s\n" "We need to now add a file system. This will be ext4 filesystem."

mkfs.ext4 /dev/mapper/drive

lsblk

printf "\n%s\n" "The encrypted drive will now be closed..."

sync

cryptestup close drive

lsblk

ls -l /dev/disk/by-uuid/

ls -l /dev/disk/by-uuid/ | grep "$setuuid" | awk '{print $9}' | tr -d /.

while [ 1 ]; do

	printf "\n%s\n%s\n" "You need to now add the UUID number of the disk you have setup for either file backups or system backups." "See above, is this correct? y/n"

	read -p "Enter your selection: " answer

	case "$answer" in
		y)
		break
		;;
		n)
		printf "\n%s\n" "Exiting script. Run again, or consult the developer for further instruction or support"
		exit
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done

while [ 1 ]; do

	printf "\n%s\n" "Choose what this disk will be used for. Press t for timeshift system backups or press f for file system backups"

	read -p "Enter your selection: " answer
	
	case "$answer" in
		t)
		ls -l /dev/disk/by-uuid/ | grep "$setuuid" | awk '{print $9}' | tr -d /. > /home/"$SUDO_USER"/.uuidtimeshift
		break
		;;
		f)
		ls -l /dev/disk/by-uuid/ | grep "$setuuid" | awk '{print $9}' | tr -d /. > /home/"$SUDO_USER"/.uuidfiles
		break
		;;	
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done

printf "\n%s\n%s\n%s\n%s\n%s\n" "This drive is now ready to be used either file backup, or system backup, depending on your previous selection." "IMPORTANT NOTE: IF YOU ARE USING A NEWLY SETUP DISK FOR SYSTEM BACKUPS FOR THE FIRST TIME - " "YOU MUST RUN timeshift-gtk IN A TERMINAL IN XORG AND RUN THE SETUP WIZARD, SELECTING THIS DISK TO AVOID ERRORS." "THEN PRESS THE create BUTTON." "Complete. Closing."
}

# function for timeshift backups
# function for starting the timeshift process
starttimeshift () {

# timeshift
# find uuid
tdrive=$(cat /home/"$SUDO_USER"/.uuidtimeshift)
tuuid=$(echo "$tdrive")
#devname=$(lsblk | awk '{print $1}' | sed -n 8p | sed s/└─//g)
tdevname=$(ls /dev/disk/by-uuid/ -l | grep "$tuuid" | awk '{print $11}' | tr -d /.)
tencryptedname="timeshiftbackup"
tunmounting=$(lsblk | grep "$tencryptedname" | awk '{print $7}')
#echo -e "\nAwaiting $tuuid\n"
lstdevname=$(ls /dev/disk/by-uuid -l | grep "$tuuid")

printf "\n%s\n" ""

lsblk

#sed -n 32p $SUDO_USER/timebackup.sh
	
printf "\n%s\n" "Stop! Have you run sudo su? Is /dev/"$tdevname" location correct? y/n"

read -p "Enter your selection: " answer

case "$answer" in
	y)
	printf "\n%s\n" "Continuing..."
	cryptsetup open /dev/"$tdevname" "$tencryptedname"
	mappercheck
	timeshift --create --snapshot-device /dev/mapper/"$tencryptedname"
	;;
	n)
	exit
	;;
	*)
	printf "\n%s\n" "Not a valid selection."
	;;
esac
}

# function for closing the drive after timeshift
closetimeshift () {
		
printf "\n%s\n" ""

lsblk

while [ 1 ]; do

	printf "\n%s\n" "Does the /dev/mapper/"$tencryptedname" need unmounting? check MOUNTPOINT. press y for umount or n to exit"

	read -p "Enter your selection: " answer

	case "$answer" in
		y)
		printf "\n%s\n" "Complete. Closing..."
		umount "$tunmounting"
		sync
		cryptsetup close "$tencryptedname"
		lsblk
		printf "\n%s\n" "Your storage should be correct. Finished."
		exit
		;;
		n)
		printf "\n%s\n" "Complete. Closing..."
		sync
		cryptsetup close "$tencryptedname"
		lsblk
		printf "\n%s\n" "Your storage should be correct. Finished."
		exit
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for checking drive is correct
tdrivecheck () {

sudocheck

printf "\n%s\n" ""

lsblk

while [ 1 ]; do

	printf "\n%s\n" "Stop! Have you run sudo su? Is /dev/"$tdevname" location correct? y/n"

	read -p "Enter your selection: " answer

	case "$answer" in
		y)
		printf "\n%s\n" "Continuing..."
		cryptsetup open /dev/"$tdevname" "$tencryptedname"
		mappercheck
		break
		;;
		n)
		exit
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for deleting timehsift backups
timedelete () {

while [ 1 ]; do

	printf "\n%s\n" "Do you want to delete a backup? press d to continue or q to exit"

	read -p "Enter your selection: " answer

	case "$answer" in 
		d)
		read -p "Enter the line number matching the backup you want to delete: " delete
		tdelete=$(timeshift --list | grep -i -m 1 "^"$delete"" | awk '{print $3}')
		timeshift --delete --snapshot "$tdelete"
		;;
		q)
		closetimeshift	
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for starting main timeshift backup deletions
maintdelete () {

sudocheck

# timeshift
# find uuid
tdrive=$(cat /home/"$SUDO_USER"/.uuidtimeshift)
tuuid=$(echo "$tdrive")
#devname=$(lsblk | awk '{print $1}' | sed -n 8p | sed s/└─//g)
tdevname=$(ls /dev/disk/by-uuid/ -l | grep "$tuuid" | awk '{print $11}' | tr -d /.)
tencryptedname="timeshiftbackup"
tunmounting=$(lsblk | grep "$tencryptedname" | awk '{print $7}')
#echo -e "\nAwaiting $tuuid\n"
lstdevname=$(ls /dev/disk/by-uuid -l | grep "$tuuid")

printf "\n%s\n" "Looking for "$tdrive"..."

[ "$lstdevname" ] && printf "\n%s\n" ""$tdrive" has been found. Starting..." && tdrivecheck && timeshift --list | less && timedelete || printf "\n%s\n\n" "Cannot find "$tuuid". Check you are run as sudo su. Check that you have connected your drive. Exiting..." && lsblk && printf "\n%s" "" && exit

#if [ "$lstdevname" ]; then
#
#	printf "\n%s\n" ""$tdrive" has been found. Starting..."
#
#	tdrivecheck
#	timeshift --list
#	timedelete
#
#else
#
#	printf "\n%s\n\n" "Cannot find "$tuuid". Check you are run as sudo su. Check that you have connected your drive. Exiting..."
#
#	lsblk
#
#	printf "\n%s" ""
#
#	exit
#
#fi

}

# function main for timeshift
maintimeshift () {

sudocheck

# timeshift
# find uuid
tdrive=$(cat /home/"$SUDO_USER"/.uuidtimeshift)
tuuid=$(echo "$tdrive")
#devname=$(lsblk | awk '{print $1}' | sed -n 8p | sed s/└─//g)
tdevname=$(ls /dev/disk/by-uuid/ -l | grep "$tuuid" | awk '{print $11}' | tr -d /.)
tencryptedname="timeshiftbackup"
tunmounting=$(lsblk | grep "$tencryptedname" | awk '{print $7}')
#echo -e "\nAwaiting $tuuid\n"
lstdevname=$(ls /dev/disk/by-uuid -l | grep "$tuuid")

printf "\n%s\n" "Looking for "$tdrive"..."

[ "$lstdevname" ] && printf "\n%s\n" ""$tdrive" has been found. Starting..." && starttimeshift && closetimeshift || printf "\n%s\n\n" "Cannot find "$tuuid". Check you are run as sudo su. Check that you have connected your drive. Exiting..." && lsblk && printf "\n%s" "" && exit

#if [ "$lstdevname" ]; then
#
#	printf "\n%s\n" ""$tdrive" has been found. Starting..."
#
#	starttimeshift
#	closetimeshift
#
#else
#
#	printf "\n%s\n\n" "Cannot find "$tuuid". Check you are run as sudo su. Check that you have connected your drive. Exiting..."
#
#	lsblk
#
#	printf "\n%s" ""
#
#	exit
#
#fi

}

# function for filebackup
filebackup () {

sudocheck

# find uuid variables
bdrive=$(cat /home/"$SUDO_USER"/.uuidfiles)
buuid=$(echo "$bdrive")
bdevname=$(ls /dev/disk/by-uuid/ -l | grep "$buuid" | cut -d "/" -f3)
#bdevname=$(ls /dev/disk/by-uuid/ -l | grep "$buuid" | colrm 1 85)
lsbdevname=$(ls /dev/disk/by-uuid -l | grep "$buuid")

printf "\n%s\n" "Looking for "$bdrive"..."

if [ "$lsbdevname" ]; then

	printf "\n%s\n\n" ""$bdrive" has been found. Starting..."

	lsblk

while [ 1 ]; do

	printf "\n%s\n" "Stop! Have you run sudo su first? Have you saved your latest bookmarks? Is /dev/"$bdevname" correct? y/n" 

	read -p "Enter your selection: " answer

	case "$answer" in
		y)
		printf "\n%s\n" "Continuing..."
		cryptsetup open /dev/"$bdevname" drive
		# enter password
		[ ! -h /dev/mapper/drive ] && printf "\n\n%s\n\n" "cryptsetup has failed to open /dev/mapper/drive from /dev/"$bdevname" . Make sure you are entering the correct password, or check your devices and mountpoints. Running lsblk and exiting..." && lsblk && exit || printf "\n\n%s\n\n" "dev/mapper/drive found. Continuing..." 
		mount /dev/mapper/drive /mnt
		rsync -av /home/"$SUDO_USER"/ /mnt --delete
		sync
		umount /mnt
		cryptsetup close drive 
		printf "\n%s\n" "Complete. Closing..."
		lsblk
		printf "\n%s\n" "Your storage should be correct. Finished."
		exit
		;;
		n)
		exit
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done

else

	printf "\n%s\n\n" "Cannot find "$buuid". Check you are run as sudo su. Check that you have connected your drive. Exiting..."

	lsblk

	printf "\n%s" ""

	#sed -n 31p $SUDO_USER/backup.sh
	
	exit

fi
}

# date
planner () {

printf "\n%s\n\n" "The time and date is:"
date

# calender
printf "\n%s\n\n" "This month's calender:"
cal
printf "\n%s\n" "press q when ready..." | less

# cat out notes/todo
printf "\n%s\n" ""
less /home/"$USER"/info/notes.txt 
printf "\n%s\n" ""

# i3 configured to open bookmark selector for web browser and email in seperate windows
startx

#clear

printf "\n%s\n" ""

selection
}

# function for selecting everything
selection () {

while [ 1 ]; do

printf "\n%s" ""

	read -p "Enter your selection. h and enter if you need help: " answer

	case "$answer" in
		cm)
		cmus
		;;
		ne)
		cmus-remote -n
		cmus-remote -Q
		;;
		pr)
		cmus-remote -r
		;;
		u)
		cmus-remote -u
		;;
		f)
		cmus-remote -k +5
		;;
		st)
		cmus-remote -Q | less
		;;
		au)
		printf "\n%s" ""; amixer -c 0 -- sset Master unmute; amixer -c 0 -- sset Master playback -10dB
		;;
		al)
		alsamixer
		;;
		yt)
		cd /home/"$USER"/Videos/
		yt
		;;
		mus)
		cd /home/"$USER"/Music/
		ytmusic
		;;
		pi)
		fzfcmus
		;;
		we)
		websearch
		;;
		boo)
		bookmarkformat
		;;
		bo)
		bookmarkcheck
		;;
		ly)
		printf "\n%s\n%s\n%s\n" "Stop! It is recommended to run lynx browser offline for your saved webpages." "Use Browsh/Librewolf for web online browsing and saving webpages for later." "Are you offline? Do you want to continue? y/n"

		read -p "Enter your selection: " answer

		case "$answer" in
			y)
			screen -c /home/"$USER"/.screenrc.lynx
			;;
			n)
			selection
			break	
			;;	
		esac
		;;
		bro)
		printf "\n%s\n" "Tips: prefix 'searx.be/search?q=' or 'wiby.me/?q=' in the URL to search."
		#sudo gpm -m /dev/psaux -t ps2
		# searching: searx.be/search?q=
		# searching: wiby.me/?q=
		# browsh --firefox.path /usr/bin/librewolf
		browsh
		;;
		brow)
		browsh --firefox.with-gui
		;;
		lib)
		devour librewolf
		;;
		p)
		ping jameschampion.xyz
		;;
		b)
		screen -c /home/"$USER"/.screenrc.birthdays_split	
		;;
		n)
		screen -c /home/"$USER"/.screenrc.notes_split
		;;
		mu)
		screen -c /home/"$USER"/.screenrc.mutt_conf
		;;
		d)
		cal; date; printf "\n%s\n" "q to return to planner" | less
		;;
		c)
		watch -td -n 1 date
		#screen -c /home/"$USER"/.screenrc.clock
		;;
		r)
		screen -c /home/"$USER"/.screenrc.rss
		;;
		e)
		mutt
		;;
		a)
		screen -c /home/"$USER"/.screenrc.articles 
		;;
		sta)
		startx
		;;
		l)
		screen -c /home/"$USER"/.screenrc.videos 
		;;
		vid)
		devourvid
		;;
		fi)
		vim /home/"$USER"/
		;;
		se)
		fzfxorgvid
		;;
		t)
		fzfttyvid	
		;;
		fz)
		fzfvim	
		;;
		del)
		fzfdelete
		;;
		wh)
		fzfwhitespace
		;;
		w)
		#until curl wttr.in 1>/dev/null; do
			#sleep 1
			#echo "Awaiting wttr.in to respond. The server might be down. You could try again later."
			#break
		#done
		weather
		;;
		pdf)
		fzfpdf
		;;
		v)
		vim 0 -c "set laststatus=0" -o /home/"$USER"/proj/working_on/*YEN/drafts/*1  
		;;
		v1)
		vim /home/"$USER"/proj/working_on/*YEN/characters/* -o /home/"$USER"/proj/working_on/*YEN/notes/*screenplay_notes -o /home/"$USER"/proj/working_on/*YEN/notes/*prompt_notes -o /home/"$USER"/proj/working_on/*YEN/notes/*archive_notes
		;;
		di)
		diskformat
		;;
		ba)
		filebackup
		;;
		ti)
		maintimeshift
		;;
		de)
		maintdelete	
		;;
		x)
		pkill "Xorg"
		;;
		lo)
		vlock -a
		;;
		sc1)
		sudo fbgrab -c 1 screenshot1.png
		;;
		sc2)
		sudo fbgrab -c 2 screenshot2.png
		;;
		sc3)
		sudo fbgrab -c 3 screenshot3.png
		;;
		sc4)
		sudo fbgrab -c 4 screenshot4.png
		;;
		sc5)
		sudo fbgrab -c 5 screenshot5.png
		;;
		sc6)
		sudo fbgrab -c 6 screenshot6.png
		;;
		re)
		sudo ffmpeg -f fbdev -framerate 60 -i /dev/fb0 ttyrecord.mp4
		;;
		wr)
		vim
		;;
		ca)
		bc
		;;
		sp)
		sc-im
		;;
		ht)
		htop
		;;
		fr)
		printf "\n%s\n" ""
		df -h
		;;
		scr)
		screen -c /home/"$USER"/.screenrc.four_split
		;;
		scre)
		screen -c /home/"$USER"/.screenrc.hsplit
		;;
		scree) 
		screen -c /home/"$USER"/.screenrc.vsplit
		;;
		scro)
		printf "\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n" "How To Achieve Scrollback In A TTY" "Login to a TTY and run the following: " "bash | tee /tmp/scrollback" "Now login to a seperate TTY and run: " "less +F /tmp/scrollback" "Now switch back to your first TTY. When you want to scrollback then return to your second TTY and press CTRL+C to interrupt less from following your file. You can then scroll back through your output. When you have finished scrolling back through your history press SHIFT+F in less and it'll go back to following the /tmp/scrollback file"
		;;
		ch1)
		chvt 1
		;;
		ch2)
		chvt 2
		;;
		ch3)
		chvt 3
		;;
		ch4)
		chvt 4
		;;
		ch5)
		chvt 5
		;;
		ch6)
		chvt 6
		;;
		tty)
		ttysh
		exit
		;;
		up)
		printf "\n%s" ""
		sudo pacman -Syu
		printf "\n%s" ""
		yay -Syu
		printf "\n%s\n" "You should now exit TTYSH and reboot your system to complete any new updates."
		;;	
		fo)
		sudo screen -c /home/"$USER"/.screenrc.font_conf
		printf "\n%b\n" "You should reboot your system to see any changes that you have made."
		;;
		res)
		sudo reboot
		exit
		;;
		sh)
		sudo poweroff
		exit
		;;
		h)
		ttyshhelp
		;;
		q)
		printf "\n%s" ""
		exit
		;;	
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}


#
# PROGRAMME START
# 

#clear

#clear replaces /dev/null and variations as they crash mpv
#[[ ]] needs work, and is forcing an enter key press to continue after mpv and clear
#[[ -f /usr/local/bin/ttyhs ]] && [[ -f /home/"$USER"/.splash_ttysh.png ]]; mpv /home/"$USER"/.splash_ttysh.png; clear; || echo "If you are using this for the first time, configuration is required. Do you want to continue? y/n"
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
if [ -e /usr/bin/jfbview ]; then
	#printf "%s" ""
	splashscreen
	#mpv --really-quiet /home/"$USER"/.splash_ttysh.png; clear
else
	printf "\n%s\n" "First time using TTYSH, or you do not yet have TTYSH setup and configured? Press y to begin setup, or press n to exit."

	read -p "Enter your selection: " answer

	case "$answer" in
		y)
		wizardttysh
		;;
		n)
		printf "\n%s\n" "exiting"; exit 
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
fi

#[ "$1" ] && "$1" || printf "\n\t%s\n" "TTYSH"

#options="${1:-$(printf "Use the following options after typing ttysh, e.g. ttsyh planner Note: ttysh flags create a menu picker ttyshhelp fzfcmus websearch bookmarkcheck fzfxorgvid fzfttyvid fzfvim fzfpdf yt ytmusic weather planner"}"

[ "$1" ] && options=$(printf "%s" "fzfcmus websearch bookmarkcheck fzfxorgvid fzfttyvid fzfvim fzfpdf yt ytmusic weather planner helpflags" | tr ' ' '\n' | grep "$1") && "$options" || printf "\n\t%s\n" "TTYSH"

while [ 1 ]; do

	printf "\n\t%s\n\n" "(c)ontinue, (s)election, (h)elp, edit (hel)p, (config) wizard, or (q)uit?"
		
	read -p "Enter your selection: " intro

	case "$intro" in
		c)
		clear
		planner
		selection
		;;	
		s)
		selection
		break
		;;
		h)
		ttyshhelp
		;;
		config)
		wizardttysh
		;;
		hel)
		vim /home/"$USER"/.ttysh.selection
		;;
		q)
		printf "\n%s" ""
		exit
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
