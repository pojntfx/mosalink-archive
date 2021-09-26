#script to quickly establish a MOSALINK
echo
echo
echo "PART 3: STARTUP!"
echo
echo
echo "Starting soundmodem ..."

soundmodem -v 0

echo "Done!"
echo
echo
echo "Starting alsamixer in 5s ..."
echo "Use escape to exit and come back to this script!"
echo -n "."
sleep 1
echo -n "."
sleep 1
echo -n "."
sleep 1
echo -n "."
sleep 1
echo -n "."
sleep 1

alsamixer
echo "Done!"
echo "Stopping smbd and nmbd services (if they are running) ..." 
{
service smbd stop
service nmbd stop
} &> /dev/null
echo "Done!"
echo
echo "Starting eoax ..."
depmod
sudo modprobe eoax
sudo ip link set dev eaox0 down
sudo ip link set dev eaox0 up
echo "Done!"
echo "Assigning ipv4 address to eoax0 ..."

{
sudo avahi-autoipd eoax0
} &> /dev/null
sleep 12
break

echo "Done"
echo
echo "Starting batman-adv ..."
sudo modprobe batman-adv
sudo batctl if add eoax0
sudo ip link set dev bat0 down
sudo ip link set dev bat0 up
echo "Success!"
echo "Assigning ipv4 address to bat0 ..."
{
sudo avahi-autoipd bat0
} &> /dev/null
echo "Success!"
echo
echo "All Network interfaces:"
ip link list dev ax0
ip link list dev eoax0
ip link list dev bat0
echo
echo "All batman-adv nodes in range:"
sudo batctl o
echo
echo "Interfaces are now set up for a MOSALINK connection with the info below:"
echo "ax0 ipv4 address: 012345678910"
echo "eoax0 ipv4 address: 012345678910"
echo "bat0 ipv4 address: 012345678010"
sleep 100
{
sudo avahi-autoipd bat0
} &> /dev/null
