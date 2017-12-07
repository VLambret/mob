#! /bin/bash

function notify_new_session()
{
	MEMBER=$1
	echo $MEMBER
}

function wait_until_period_end()
{
	PERIOD=$1
	sleep $PERIOD
	mplayer beep.mp3 > /dev/null 2>&1 &
}

if [ "$#" -lt "3" ]
then
	echo "You should be at least two for mob programming"
	exit
fi

DELAY=$1

shift

for I in $@ ;
do
	notify_new_session $I
	wait_until_period_end $DELAY
done

