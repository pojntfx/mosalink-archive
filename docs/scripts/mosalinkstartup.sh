echo
echo
echo "SECTION 3: STARTUP"
echo
echo
echo "	SECTION 3.1: SOUNDMODEM"
echo
echo
echo "	Starting Soundmodem ..."
# (not needed since script should be executed with sudo! echo "	Enter your password in the new terminal window and don't close it, then return here!"
xterm -e sudo soundmodem &
sleep 1

echo "	Done!"
echo
echo "	Do you want to start set your audio volume for soundmodem using alsamixer? (y/n)"

read answer
if echo "$answer" | grep -iq "^y"; then
	echo "	To exit alsamixer, use esc!"
	sleep 2
	alsamixer
else
	echo
fi

echo
echo "	Stopping smbd and nmbd (if they are running) ..."

service smbd stop
service nmbd stop

echo "	Done!"
echo
echo
echo "	SECTION 3.2: EOAX"
echo
echo
echo "	Starting eoax"

# if this does not work, you've probably updated to a new kernel. You will have to recompile and reconfigure the kernel module as described in the tutorial/installation script.
depmod
modprobe eoax
ip link set dev eoax0 down
ip link set dev eoax0 up

echo "	Done!"
echo
echo "	Assigning ipv4 address to eoax0 ..."

{
avahi-autoipd eoax0
avahi-autoipd eoax0 -D
} &> /dev/null
sleep 12

echo "	Done!"
echo
echo
echo "	SECTION 3.3: BATMAN-ADV"
echo
echo
echo "	Starting batman-adv ..."

modprobe batman-adv
batctl if add eoax0
ip link set dev bat0 down
ip link set dev bat0 up

echo "	Done!"
echo
echo "	Assigning ipv4 address to bat0 ..."

{
avahi-autoipd bat0
avahi-autoipd bat0 -D
} &> /dev/null
sleep 20

echo "	Done!"
echo
echo
echo "	STARTUP DONE!"
echo
echo
echo "  Do you want to see the network interfaces that have been set up? (y/n)"

read answer
if echo "$answer" | grep -iq "^y"; then
        echo
	ip link list dev ax0
	echo
	ip link list dev eoax0
	echo
	ip link list dev bat0
else
        echo
fi

echo
echo "  Do you want to see all batman-adv nodes in range? (y/n)"

read answer
if echo "$answer" | grep -iq "^y"; then
        echo
	batctl o;
else
        echo
fi

echo
echo
echo "Interfaces are now set up for a MOSALINK connection with the info below:"
echo
echo "ax0 ipv4 address: 012345678910" #this will use some sort of grep info later on!
echo "eoax0 ipv4 address: 012345678910"
echo "bat0 ipv4 address: 012345678010"
echo
echo "Visit alphahorizon.com to find more information about this script and the MOSANET Project!"
